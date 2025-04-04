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

service /claims/add on new http:Listener(8080) {
    // Submit a new claim
    resource function post submit(@http:Payload Claim claim) returns ClaimResponse|error {
        // Get total claims amount for the user
        decimal totalAmount = check getTotalClaimsAmount(claim.userId);
        totalAmount += claim.amount;

        // Generate claim ID
        string claimId = generateClaimId();
        claim.claimId = claimId;

        if totalAmount <= claimLimit {
            claim.status = "APPROVED";
            // Store claim in database
            _ = check dbClient->execute(`
                INSERT INTO claims (claim_id, user_id, amount, status, description)
                VALUES (${claim.claimId}, ${claim.userId}, ${claim.amount}, ${claim.status}, ${claim.description})
            `);

            return {
                message: "Claim approved automatically",
                claimId: claim.claimId,
                status: claim.status
            };
        } else {
            claim.status = "PENDING";
            // Store claim in database
            _ = check dbClient->execute(`
                INSERT INTO claims (claim_id, user_id, amount, status, description)
                VALUES (${claim.claimId}, ${claim.userId}, ${claim.amount}, ${claim.status}, ${claim.description})
            `);

            // Note: Email sending functionality would be implemented here
            // but is not included as it's not in the provided API docs

            return {
                message: "Claim pending approval as it exceeds the pre-authorized limit. Finance team will contact you.",
                claimId: claim.claimId,
                status: claim.status
            };
        }
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