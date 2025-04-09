import ballerina/email;
import ballerina/http;
import ballerina/uuid;

# Email configuration for SMTP client
configurable string smtpHost = "smtp.email.com";
configurable string smtpUsername = "claims@company.com";
configurable string smtpPassword = "password";
configurable string financeTeamEmail = "finance@example.com";

# Pre-authorized limit for automatic approval
final decimal PRE_AUTHORIZED_LIMIT = 10.0;

# Initialize SMTP client
final email:SmtpClient smtpClient = check new (
    host = smtpHost,
    username = smtpUsername,
    password = smtpPassword
);

# In-memory storage for claims
map<Claim> claims = {};

# Service for claims management
service / on new http:Listener(8080) {
    # Submit a new claim
    #
    # + request - Claim request details
    # + return - Claim submission response or error
    resource function post claims(@http:Payload ClaimRequest request) returns ClaimResponse|error {
        string claimId = uuid:createType1AsString();

        decimal totalAmount = request.amount;
        foreach Claim claim in claims {
            if claim.userEmail == request.userEmail {
                totalAmount += claim.amount;
            }
        }

        string status;
        string message;

        if totalAmount <= PRE_AUTHORIZED_LIMIT {
            status = "APPROVED";
            message = "Claim approved automatically";
        } else {
            status = "PENDING";
            message = "Claim pending approval as total claims exceed pre-authorized limit";

            // Send email notification
            email:Message emailMessage = {
                to: [request.userEmail],
                cc: [financeTeamEmail],
                subject: "Claim Pending Approval",
                body: string `Your claim (ID: ${claimId}) is pending approval as the total claims exceed the pre-authorized limit. 
                The finance team will contact you shortly.`
            };
            check smtpClient->sendMessage(emailMessage);
        }

        Claim claim = {
            id: claimId,
            amount: request.amount,
            description: request.description,
            status: status,
            userEmail: request.userEmail
        };
        claims[claimId] = claim;

        return {
            message: message,
            claimId: claimId
        };
    }

    # Get status of a claim
    #
    # + claimId - ID of the claim
    # + userEmail - Email of the user requesting status
    # + return - Status response or error
    resource function get claims/[string claimId](@http:Header string userEmail) returns StatusResponse|error {
        Claim? claim = claims[claimId];

        if claim is () {
            return error("Claim not found");
        }

        if claim.userEmail != userEmail {
            return error("Unauthorized to view this claim");
        }

        return {
            status: claim.status
        };
    }
}