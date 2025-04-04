import ballerina/http;
import hello_bi.claims.impl;

# Maximum claim amount that can be automatically approved without manual review
configurable decimal claimLimit = 1500.0;

# Email address for the finance team to handle manual claim approvals
configurable string financeTeamEmail = "finance@example.com";

# Service to handle expense claim submissions and processing
service /claims/add on new http:Listener(8080) {
    
    # Processes a new expense claim submission
    # + claim - The expense claim details to be processed
    # + return - A ClaimResponse with submission status
    resource function post submit(@http:Payload Claim claim) returns ClaimResponse|error {
        decimal totalAmount = check impl:getTotalClaimsAmount(claim.userId);
        totalAmount += claim.amount;

        string claimId = impl:generateClaimId(claim.claimId);
        claim.claimId = claimId;

        if totalAmount <= claimLimit {
            claim.status = "APPROVED";
            _ = check impl:dbClient->execute(`
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
            _ = check impl:dbClient->execute(`
                INSERT INTO claims (claim_id, user_id, amount, status, description)
                VALUES (${claim.claimId}, ${claim.userId}, ${claim.amount}, ${claim.status}, ${claim.description})
            `);

            return {
                message: "Claim pending approval as it exceeds the pre-authorized limit. Finance team will contact you.",
                claimId: claim.claimId,
                status: claim.status
            };
        }
    }

    # Retrieves the status of a specific claim
    # + claimId - The unique identifier of the claim
    # + userId - The identifier of the user requesting the status
    # + return - A StatusResponse with claim details or an error if retrieval fails
    resource function get status/[string claimId](@http:Header string userId) returns StatusResponse|error {
        Claim? claim = impl:generateClaim(claimId);
        
        if claim is () {
            return {
                message: "Claim not found",
                claim: ()
            };
        }

        if claim.userId != userId {
            return error("Unauthorized access: You can only view your own claims");
        }

        return {
            message: "Claim status retrieved successfully",
            claim: claim
        };
    }
}
