import ballerina/email;
import ballerina/http;
import ballerina/uuid;

# SMTP client configuration
configurable string smtpHost = "smtp.email.com";
configurable string smtpUsername = "user@example.com";
configurable string smtpPassword = "password";

# Finance team email address
final string FINANCE_EMAIL = "finance@example.com";

# Email client for sending notifications
final email:SmtpClient smtpClient = check new (
    host = smtpHost,
    username = smtpUsername,
    password = smtpPassword
);

# In-memory storage for claims
map<Claim> claims = {};

# Service to manage expense claims
service /claims on new http:Listener(8080) {

    # Submit a new expense claim
    #
    # + request - Claim submission details
    # + return - Claim response with ID and status, or error
    resource function post submit(@http:Payload ClaimRequest request) returns ClaimResponse|error {
        string claimId = uuid:createType1AsString();

        Claim claim = {
            id: claimId,
            amount: request.amount,
            status: request.amount <= 10.0d ? APPROVED : PENDING,
            userId: request.userId
        };

        claims[claimId] = claim;

        if claim.status == PENDING {
            email:Message emailMessage = {
                'from: smtpUsername,
                subject: "New Expense Claim Pending",
                to: [FINANCE_EMAIL, request.userId],
                body: string `New expense claim (ID: ${claimId}) for $${claim.amount} requires review.`
            };
            check smtpClient->sendMessage(emailMessage);
        }

        return {
            id: claim.id,
            status: claim.status
        };
    }

    # Check status of a claim
    #
    # + claimId - ID of the claim to check
    # + userId - ID of the user requesting status
    # + return - Claim status response or error
    resource function get status/[string claimId](@http:Header string userId) returns ClaimResponse|error {
        Claim? claim = claims[claimId];

        if claim is () {
            return error("Claim not found");
        }

        if claim.userId != userId {
            return error("Unauthorized to view this claim");
        }

        return {
            id: claim.id,
            status: claim.status
        };
    }
}

enum Status {
    PENDING,
    APPROVED
};
