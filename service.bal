import ballerina/http;
import ballerina/sql;
import ballerinax/mysql;

# Configurable variable for database host
configurable string dbHost = ?;
# Configurable variable for database port
configurable int dbPort = ?;
# Configurable variable for database name
configurable string dbName = ?;
# Configurable variable for database username
configurable string dbUsername = ?;
# Configurable variable for database password
configurable string dbPassword = ?;

# MySQL client for database operations
final mysql:Client dbClient = check new (
    host = dbHost,
    user = dbUsername,
    password = dbPassword,
    port = dbPort,
    database = dbName
);

# Guest Management service for luxury apartment
service /guest\-management on new http:Listener(8080) {

    # Handle guest check-in process
    #
    # + checkInRequest - Guest check-in request details
    # + return - Check-in response or error
    resource function post check\-in(@http:Payload GuestCheckInRequest checkInRequest) returns CheckInResponse|error {
        string guestName = checkInRequest.fullName;
        
        // Basic identity validation
        if guestName.length() == 0 {
            return {
                status: "REJECTED",
                message: "Identity verification failed."
            };
        }

        // Check if guest is a frequent visitor
        boolean isFrequentVisitor = check self.isFrequentVisitor(guestName);

        if isFrequentVisitor {
            // Log the visit for frequent visitor
            check self.logVisit(guestName, checkInRequest.residentName);
            return {
                status: "APPROVED",
                message: "Welcome back! Access granted as frequent visitor."
            };
        }

        // Log the visit for regular visitor
        check self.logVisit(guestName, checkInRequest.residentName);
        return {
            status: "PENDING_VALIDATION",
            message: "Please wait for security validation."
        };
    }

    # Handle security validation with resident
    #
    # + validationRequest - Security validation request details
    # + return - Resident's response or error
    resource function post security/validate(@http:Payload SecurityValidationRequest validationRequest) returns ResidentResponse|error {
        string guestName = validationRequest.guestName;
        string residentName = validationRequest.residentName;
        string securityNote = validationRequest.securityNote;

        // Check if there's a pending visit
        sql:ParameterizedQuery query = `SELECT visit_time 
                                      FROM visits 
                                      WHERE guest_name = ${guestName} 
                                      AND resident_name = ${residentName}
                                      AND visit_time >= NOW() - INTERVAL 1 HOUR`;

        record {|string visit_time;|}|sql:Error result = dbClient->queryRow(query);

        if result is sql:NoRowsError {
            return {
                approved: false,
                message: "No recent check-in request found for this guest."
            };
        }

        // In a real implementation, this would integrate with a resident notification system
        // For now, we'll simulate an approval
        return {
            approved: true,
            message: "Resident has approved the visit."
        };
    }

    # Check if a guest is a frequent visitor
    #
    # + guestName - Name of the guest
    # + return - True if frequent visitor, false otherwise
    private function isFrequentVisitor(string guestName) returns boolean|error {
        sql:ParameterizedQuery query = `SELECT COUNT(*) as visit_count 
                                      FROM visits 
                                      WHERE guest_name = ${guestName} 
                                      AND visit_time >= NOW() - INTERVAL 7 DAY`;

        record {|int visit_count;|} result = check dbClient->queryRow(query);
        return result.visit_count > 5;
    }

    # Log a guest visit
    #
    # + guestName - Name of the guest
    # + residentName - Name of the resident
    # + return - Error if operation fails
    private function logVisit(string guestName, string residentName) returns error? {
        sql:ParameterizedQuery query = `INSERT INTO visits (guest_name, resident_name, visit_time) 
                                      VALUES (${guestName}, ${residentName}, NOW())`;
        _ = check dbClient->execute(query);
    }
}