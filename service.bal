import ballerina/email;
import ballerina/http;
import ballerina/sql;
import ballerina/uuid;
import ballerinax/java.jdbc;

# Pre-authorized limit for automatic claim approval
configurable decimal preAuthorizedLimit = 10.0;

# Finance team email address
configurable string financeTeamEmail = "finance@example.com";

# SMTP configuration
configurable string smtpHost = "smtp.email.com";
configurable string smtpUsername = "claims@example.com";
configurable string smtpPassword = "password";

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

// Initialize SMTP client
final email:SmtpClient smtpClient = check new (
    host = smtpHost,
    username = smtpUsername,
    password = smtpPassword
);

service /claims on new http:Listener(8080) {
    # Submit a new claim.
    #
    # + request - Claim submission request
    # + return - Created claim
    resource function post submit(@http:Payload ClaimRequest request) returns Claim|error {
        // Generate unique claim ID
        string claimId = uuid:createType1AsString();

        // Determine claim status based on amount
        string claimStatus;
        if request.amount <= preAuthorizedLimit {
            claimStatus = "APPROVED";
        } else {
            claimStatus = "PENDING";
            // Send email notifications
            check sendEmailNotifications(request);
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

# Send email notifications for pending claims.
#
# + request - Claim request details
# + return - Error if sending fails
function sendEmailNotifications(ClaimRequest request) returns error? {
    // Prepare email message for user
    email:Message userEmail = {
        to: request.userEmail,
        subject: "Claim Submission Pending Approval",
        body: string `Your claim for $${request.amount} has been submitted and is pending approval.`
    };

    // Prepare email message for finance team
    email:Message financeEmail = {
        to: financeTeamEmail,
        subject: "New Claim Pending Approval",
        body: string `A new claim for $${request.amount} has been submitted by ${request.userEmail} and requires approval.`
    };

    // Send emails
    check smtpClient->sendMessage(userEmail);
    check smtpClient->sendMessage(financeEmail);
}