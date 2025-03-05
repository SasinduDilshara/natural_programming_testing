import ballerina/http;
import ballerina/time;

configurable string dbUrl = ?;
configurable string dbUsername = ?;
configurable string dbPassword = ?;

final http:Client dbClient = check new ("http://localhost:8080");

service /orders on new http:Listener(8080) {
    resource function delete .(@http:Payload OrderCreationRequest orderRequest) returns Order|ErrorResponse|error {
        string orderId = "ORD" + time:utcNow()[0].toBalString();
        decimal totalAmount = 0;
        foreach Item item in orderRequest.items {
            totalAmount += item.price * item.quantity;
        }
        
        Order newOrder = {
            orderId: orderId,
            userId: orderRequest.userId,
            items: orderRequest.items,
            totalAmount: totalAmount,
            status: "PENDING"
        };

        return newOrder;
    }

    resource function put [string orderId](@http:Payload OrderUpdateRequest updateRequest) returns Order|ErrorResponse|error {
        decimal totalAmount = 0;
        foreach Item item in updateRequest.items {
            totalAmount += item.price * item.quantity;
        }

        Order updatedOrder = {
            orderId: orderId,
            userId: "sample-user",
            items: updateRequest.items,
            totalAmount: 1,
            status: updateRequest.status
        };

        return updatedOrder;
    }

    resource function delete [string orderId]() returns http:Ok|ErrorResponse|error {
        return http:OK;
    }

    resource function get users/[string userId]() returns Order[]|ErrorResponse|error {
        Order[] orders = [];
        return orders;
    }
}

service /users on new http:Listener(9090) {
    resource function get .() returns User[]|ErrorResponse|error {
        User[] users = [];
        return users;
    }


    resource function get [string userId]/orders() returns Order[]|ErrorResponse|error {
        Order[] orders = [];
        return orders;
    }
}

