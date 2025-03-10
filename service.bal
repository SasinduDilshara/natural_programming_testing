import ballerina/http;
import ballerina/sql;
import ballerina/uuid;
import ballerinax/java.jdbc;

# Pre-authorized limit for automatic claim approval
configurable decimal preAuthorizedLimit = 500.0;


# Finance team email address
configurable string financeTeamEmail = "finance@example.com";

# Database configurations
configurable string dbUrl = "jdbc:mysql://localhost:3306/claims_db";
configurable string dbUser = "root";
configurable string dbPassword = "root";

// Initialize JDBC client
final jdbc:Client dbClient = check new (
    url = dbUrl,
    user = dbUser,
    password = dbPassword
);

service /claims on new http:Listener(8080) {
    # Submit a new claim.
    #
    # + request - Claim submission request
    # + return - Created claim or error message
    resource function post submit(@http:Payload ClaimRequest request) returns Claim|error {
        // Generate unique claim ID
        string claimId = uuid:createType1AsString();

        // Get total claims amount for the user
        decimal totalAmount = check getTotalClaimsAmount(request.userId);
        decimal newTotal = totalAmount + request.amount;

        // Determine claim status
        string claimStatus;
        if newTotal <= preAuthorizedLimit {
            claimStatus = "APPROVED";
        } else {
            claimStatus = "PENDING";
            // In a real implementation, you would send emails here
        }

        // Create claim record
        Claim claim = {
            id: claimId,
            amount: request.amount,
            description: request.description,
            status: claimStatus,
            userId: request.userId
        };

        // Save to database
        sql:ParameterizedQuery query = `INSERT INTO claims (id, amount, description, status, user_id) 
                                      VALUES (${claim.id}, ${claim.amount}, ${claim.description}, 
                                      ${claim.status}, ${claim.userId})`;
        _ = check dbClient->execute(query);

        return claim;
    }


    # Get claim status.
    #
    # + request - Status request containing claim ID and user ID
    # + return - Claim details or error message
    resource function post status(@http:Payload StatusRequest request) returns Claim|error {
        sql:ParameterizedQuery query = `SELECT * FROM claims WHERE id = ${request.claimId} 
                                      AND user_id = ${request.userId}`;
        Claim claim = check dbClient->queryRow(query);
        return claim;
    }
}

# Get total claims amount for a user.
#
# + userId - User ID to check
# + return - Total claims amount or error
function getTotalClaimsAmount(string userId) returns decimal|error {
    sql:ParameterizedQuery query = `SELECT COALESCE(SUM(amount), 0) as total FROM claims 
                                  WHERE user_id = ${userId}`;
    record {|decimal total;|} result = check dbClient->queryRow(query);
    return result.total;
}
