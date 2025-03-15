import ballerina/http;
import ballerina/lang.value;
import ballerina/sql;
import ballerinax/mssql;
import ballerina/uuid;

configurable string host = "localhost";
configurable int port = 1433;
configurable string user = "sa";
configurable string password = "your-password";
configurable string database = "guest_db";

final mssql:Client dbClient = check new(
    host = host,
    user = user,
    password = password,
    port = port,
    database = database
);

service /guests on new http:Listener(8080) {
    resource function post .(@http:Payload GuestCreateRequest guestRequest) returns Guest|ErrorResponse|error {
        string guestId = uuid:createType1AsString();

        record {|
            string id;
            string name;
            string email;
            string phoneNumber;
        |} qrData = {
            id: guestId,
            name: guestRequest.name,
            email: guestRequest.email,
            phoneNumber: guestRequest.phoneNumber
        };
        
        string qrCodeContent = check value:toJsonString(qrData);
        
        sql:ParameterizedQuery query = `INSERT INTO guests (id, name, email, phone_number, qr_code) 
            VALUES (${guestId}, ${guestRequest.name}, ${guestRequest.email}, ${guestRequest.phoneNumber}, ${qrCodeContent})`;
        
        sql:ExecutionResult|sql:Error result = check dbClient->execute(query);
        if result is sql:Error {
            return {
                message: "Failed to create guest",
                code: "DB_ERROR"
            };
        }

        Guest newGuest = {
            id: guestId,
            name: guestRequest.name,
            email: guestRequest.email,
            phoneNumber: guestRequest.phoneNumber,
            qrCode: qrCodeContent
        };

        error? emailError = sendEmailToAll(newGuest);
        if emailError is error {
            return {
                message: "Guest created but email notification failed",
                code: "EMAIL_ERROR"
            };
        }

        return newGuest;
    }

    resource function get .() returns Guest[]|ErrorResponse {
        sql:ParameterizedQuery query = `SELECT * FROM guests`;
        stream<DbGuest, sql:Error?> guestStream = dbClient->query(query);

        Guest[] guests = [];
        error? err = guestStream.forEach(function(DbGuest dbGuest) {
            guests.push({
                id: dbGuest.id,
                name: dbGuest.name,
                email: dbGuest.email,
                phoneNumber: dbGuest.phone_number,
                qrCode: dbGuest.qr_code
            });
        });

        if err is error {
            return {
                message: "Failed to retrieve guests",
                code: "DB_ERROR"
            };
        }

        return guests;
    }

    resource function get [string id]() returns Guest|ErrorResponse {
        sql:ParameterizedQuery query = `SELECT * FROM guests WHERE id = ${id}`;
        DbGuest|sql:Error result = dbClient->queryRow(query);

        if result is sql:Error {
            return {
                message: "Guest not found",
                code: "NOT_FOUND"
            };
        }

        return {
            id: result.id,
            name: result.name,
            email: result.email,
            phoneNumber: result.phone_number,
            qrCode: result.qr_code
        };
    }

    resource function put [string id](@http:Payload GuestUpdateRequest guestRequest) returns Guest|ErrorResponse|error {
        record {|
            string id;
            string name;
            string email;
            string phoneNumber;
        |} qrData = {
            id: id,
            name: guestRequest.name,
            email: guestRequest.email,
            phoneNumber: guestRequest.phoneNumber
        };
        
        string qrCodeContent = check value:toJsonString(qrData);
        
        sql:ParameterizedQuery query = `UPDATE guests 
            SET name = ${guestRequest.name}, 
                email = ${guestRequest.email}, 
                phone_number = ${guestRequest.phoneNumber}, 
                qr_code = ${qrCodeContent}
            WHERE id = ${id}`;
        
        sql:ExecutionResult|sql:Error result = check dbClient->execute(query);
        if result is sql:Error {
            return {
                message: "Failed to update guest",
                code: "DB_ERROR"
            };
        }

        return {
            id: id,
            name: guestRequest.name,
            email: guestRequest.email,
            phoneNumber: guestRequest.phoneNumber,
            qrCode: qrCodeContent
        };
    }

    resource function delete [string id]() returns http:Response|ErrorResponse {
        sql:ParameterizedQuery query = `DELETE FROM guests WHERE id = ${id}`;
        sql:ExecutionResult|sql:Error result = dbClient->execute(query);

        if result is sql:Error {
            return {
                message: "Failed to delete guest",
                code: "DB_ERROR"
            };
        }

        http:Response response = new;
        response.statusCode = 200;
        return response;
    }
}