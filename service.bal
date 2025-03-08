import ballerina/http;
import ballerina/sql;
import ballerina/io;

@http:ServiceConfig {
    cors: {
        allowOrigins: ["*"]
    }
}
service /api on new http:Listener(8080) {

    resource function post orders(@http:Payload OrderCreationRequest orderRequest) returns Order|ErrorResponse|error {
        decimal totalAmount = 0;
        foreach OrderItem item in orderRequest.items {
            totalAmount += item.price * item.quantity;
        }

        // Using timestamp-based order ID instead of random
        sql:ParameterizedQuery seqQuery = `SELECT EXTRACT(EPOCH FROM NOW())::INTEGER`;
        int timeStamp = check dbClient->queryRow(seqQuery);
        string orderId = "ORD" + timeStamp.toString();

        sql:ParameterizedQuery query = `INSERT INTO orders (order_id, user_id, total_amount, status) 
                                      VALUES (${orderId}, ${orderRequest.userId}, ${totalAmount}, 'CREATED')`;
        _ = check dbClient->execute(query);

        foreach OrderItem item in orderRequest.items {
            sql:ParameterizedQuery itemQuery = `INSERT INTO order_items (order_id, item_id, quantity, price) 
                                              VALUES (${orderId}, ${item.itemId}, ${item.quantity}, ${item.price})`;
            _ = check dbClient->execute(itemQuery);
        }

        Order newOrder = {
            orderId: orderId,
            userId: orderRequest.userId,
            items: orderRequest.items,
            totalAmount: totalAmount,
            status: "CREATED"
        };

        // Add log entry
        string logMessage = string `New order created - Order ID: ${orderId}, User ID: ${orderRequest.userId}, Total Amount: ${totalAmount}\n`;
        _ = check io:fileWriteString("./orders.log", logMessage, option = io:APPEND);

        return newOrder;
    }

    resource function put orders/[string orderId](@http:Payload Order orderUpdate) returns Order|ErrorResponse|error {
        sql:ParameterizedQuery query = `UPDATE orders SET status = ${orderUpdate.status}, 
                                      total_amount = ${orderUpdate.totalAmount} 
                                      WHERE order_id = ${orderId}`;
        sql:ExecutionResult result = check dbClient->execute(query);

        if result.affectedRowCount == 0 {
            return <ErrorResponse>{
                message: string `Order ${orderId} not found`,
                code: "404"
            };
        }

        sql:ParameterizedQuery deleteItems = `DELETE FROM order_items WHERE order_id = ${orderId}`;
        _ = check dbClient->execute(deleteItems);

        foreach OrderItem item in orderUpdate.items {
            sql:ParameterizedQuery itemQuery = `INSERT INTO order_items (order_id, item_id, quantity, price) 
                                              VALUES (${orderId}, ${item.itemId}, ${item.quantity}, ${item.price})`;
            _ = check dbClient->execute(itemQuery);
        }

        return orderUpdate;
    }

    resource function delete orders/[string orderId]() returns ErrorResponse|error {
        sql:ParameterizedQuery query = `DELETE FROM orders WHERE order_id = ${orderId}`;
        sql:ExecutionResult result = check dbClient->execute(query);

        if result.affectedRowCount == 0 {
            return <ErrorResponse>{
                message: string `Order ${orderId} not found`,
                code: "404"
            };
        }

        return {
            message: "Order deleted successfully",
            code: "200"
        };
    }

    resource function get orders/users/[string userId]() returns Order[]|ErrorResponse|error {
        sql:ParameterizedQuery query = `SELECT o.order_id, o.user_id, o.total_amount, o.status,
                                      i.item_id, i.quantity, i.price
                                      FROM orders o
                                      LEFT JOIN order_items i ON o.order_id = i.order_id
                                      WHERE o.user_id = ${userId}`;
        stream<record {}, error?> resultStream = dbClient->query(query);
        Order[] orders = check processOrderResults(resultStream);
        check resultStream.close();
        return orders;
    }

    resource function get users/[string userId]/orders() returns Order[]|ErrorResponse|error {
        sql:ParameterizedQuery query = `SELECT o.order_id, o.user_id, o.total_amount, o.status,
                                      i.item_id, i.quantity, i.price
                                      FROM orders o
                                      LEFT JOIN order_items i ON o.order_id = i.order_id
                                      WHERE o.user_id = ${userId}`;
        stream<record {}, error?> resultStream = dbClient->query(query);
        Order[] orders = check processOrderResults(resultStream);
        check resultStream.close();
        return orders;
    }

    resource function get users() returns User[]|ErrorResponse|error {
        sql:ParameterizedQuery query = `SELECT user_id, user_name, email FROM users`;
        stream<User, error?> resultStream = dbClient->query(query);
        User[] users = check from User user in resultStream
            select user;
        check resultStream.close();
        return users;
    }
}

// Helper function to process order results
isolated function processOrderResults(stream<record {}, error?> resultStream) returns Order[]|error {
    map<Order> orderMap = {};

    check from record {} result in resultStream
        do {
            string orderId = result["order_id"].toString();
            if !orderMap.hasKey(orderId) {
                orderMap[orderId] = {
                    orderId: orderId,
                    userId: result["user_id"].toString(),
                    items: [],
                    totalAmount: <decimal>result["total_amount"],
                    status: result["status"].toString()
                };
            }

            if result["item_id"] != () {
                OrderItem item = {
                    itemId: result["item_id"].toString(),
                    quantity: <int>result["quantity"],
                    price: <decimal>result["price"]
                };
                orderMap.get(orderId).items.push(item);
            }
        };

    return orderMap.toArray();
}