import ballerina/http;
import ballerinax/java.jdbc;
import ballerina/lang.runtime;

// Configurable variables
configurable decimal claimLimit = 500.0;
configurable string financeTeamEmail = "finance@example.com";
configurable string dbUrl = "jdbc:h2:file:./claims";
configurable string dbUsername = "sa";
configurable string dbPassword = "";

// Counter for claim ID generation
int claimCounter = 0;

// Initialize JDBC client
final jdbc:Client dbClient = check new (
    url = dbUrl,
    user = dbUsername,
    password = dbPassword
);

service /claims/get on new http:Listener(8080) {
    // Get claim status
    resource function get status/[string claimId](@http:Header string userId) returns StatusResponse|error {
        // Query claim from database
        record {|
            string claim_id;
            string user_id;
            decimal amount;
            string status;
            string description;
        |} result = check dbClient->queryRow(`
            SELECT * FROM claims WHERE claim_id = ${claimId}
        `);

        // Check if user is authorized to view this claim
        if result.user_id != userId {
            return {
                message: "Unauthorized to view this claim",
                claim: ()
            };
        }

        Claim claim = {
            claimId: result.claim_id,
            userId: result.user_id,
            amount: result.amount,
            status: result.status,
            description: result.description
        };

        return {
            message: "Claim details retrieved successfully",
            claim: claim
        };
    }
}

// Function to get total claims amount for a user
function getTotalClaimsAmount(string userId) returns decimal|error {
    record {|decimal total;|} result = check dbClient->queryRow(`
        SELECT COALESCE(SUM(amount), 0) as total 
        FROM claims 
        WHERE user_id = ${userId}
    `);
    return result.total;
}

// Function to generate a unique claim ID
function generateClaimId() returns string {
    lock {
        claimCounter += 1;
        runtime:sleep(0.001); // Ensure unique counter
        return string `CLAIM_${claimCounter}`;
    }
}