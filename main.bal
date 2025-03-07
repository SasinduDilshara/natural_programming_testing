import ballerinax/java.jdbc;
import ballerina/sql;

# Database URL for the visitor management system.
configurable string dbUrl = ?;

# Database host for authentication.
configurable string dbUser = ?;

# Database password for authentication.
configurable string dbPassword = ?;

# JDBC client for database operations.
final jdbc:Client dbClient = check new (
    url = dbUrl,
    user = dbUser,
    password = dbPassword,
    options = {
        datasourceName: "com.mysql.cj.jdbc.MysqlDataSource"
    }
);

public function registerGuest(Guest guest) returns string|error {
    sql:ParameterizedQuery query = `
        INSERT INTO guests (guest_id, first_name, last_name, email, phone_number, id_type, id_number)
        VALUES (${guest.guestId}, ${guest.firstName}, ${guest.lastName}, ${guest.email}, 
                ${guest.phoneNumber}, ${guest.idType}, ${guest.idNumber})
    `;
    
    sql:ExecutionResult result = check dbClient->execute(query);
    return guest.guestId;
}

# Creates a guest record in the system.
#
# + visit - Visit record containing the visit details
# + return - Visit check in time if creation is successful, error if operation fails
public function createVisit(Visit visit) returns string|error {
    sql:ParameterizedQuery query = `
        INSERT INTO visits (visit_id, guest_id, host_id, purpose, check_in_time, status)
        VALUES (${visit.visitId}, ${visit.guestId}, ${visit.hostId}, ${visit.purpose}, 
                ${visit.checkInTime}, ${visit.status})
    `;
    
    sql:ExecutionResult result = check dbClient->execute(query);
    return visit.visitId;
}

# Records the check-out time for a visitor and updates the visit status.
#
# + visitId - Identifier of the visit to be updated
# + checkOutTime - Time when the visitor checked out
# + return - Error if the operation fails
public function checkOutVisitor(string visitId, string checkOutTime) returns error? {
    sql:ParameterizedQuery query = `
        UPDATE visits 
        SET check_out_time = ${checkOutTime}, status = 'COMPLETED'
        WHERE visit_id = ${visitId}
    `;
    
    _ = check dbClient->execute(query);
}

public function generateBadge(Badge badge) returns string|error {
    sql:ParameterizedQuery query = `
        INSERT INTO badges (badge_id, visit_id, guest_name, host_name, valid_until)
        VALUES (${badge.badgeId}, ${badge.visitId}, ${badge.guestName}, 
                ${badge.hostName}, ${badge.validUntil})
    `;
    
    sql:ExecutionResult result = check dbClient->execute(query);
    return badge.badgeId;
}

# Retrieves visit details for a specific visit.
#
# + visitId - Identifier of the visit to retrieve
# + return - Visit record if found, error if operation fails
public function getVisitDetails(string visitId) returns Visit|error {
    sql:ParameterizedQuery query = `
        SELECT * FROM visits WHERE visit_id = ${visitId}
    `;
    
    Visit visit = check dbClient->queryRow(query);
    return {
        visitId: "", 
        guestId: "", 
        hostId: "", 
        purpose: "", 
        checkInTime: "", 
        checkOutTime: "",   
        status: ""
    };
}


public function getActiveVisits() returns Visit[]|error {
    sql:ParameterizedQuery query = `
        SELECT * FROM visits WHERE status = 'ACTIVE'
    `;
    
    stream<Visit, sql:Error?> resultStream = dbClient->query(query);
    Visit[] visits = check from Visit visit in resultStream
        select visit;
    
    return visits;
}
