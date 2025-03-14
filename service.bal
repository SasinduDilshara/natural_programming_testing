import ballerina/http;
import ballerina/email;

# Finance team email address
configurable string financeTeamEmail = "finance@example.com";

# SMTP configuration
configurable string smtpHost = "smtp.email.com";
configurable string smtpUsername = "username";
configurable string smtpPassword = "password";

# Initialize SMTP client
final email:SmtpClient smtpClient = check new (
    host = smtpHost,
    username = smtpUsername,
    password = smtpPassword
);

# Store claims in memory
map<Claim> claims = {};

# Store user's total claims
map<decimal> userTotalClaims = {};

# Counter for generating claim IDs
isolated int claimCounter = 0;

# Service for claims management
service /claims on new http:Listener(8080) {
    # Submit a new claim
    #
    # + userId - ID of the user submitting the claim
    # + request - Claim request details
    # + return - Claim response or error
    resource function post .(string userId, @http:Payload ClaimRequest request) returns ClaimResponse|error {
        string claimId = check getNextClaimId();
        decimal currentTotal = userTotalClaims[userId] ?: 0d;
        decimal newTotal = currentTotal + request.amount;

        Claim claim = {
            id: claimId,
            userId: userId,
            amount: request.amount,
            status: newTotal <= 10d ? APPROVED : PENDING
        };

        claims[claimId] = claim;
        userTotalClaims[userId] = newTotal;

        if claim.status == PENDING {
            check sendEmailNotification(userId, claimId, request.amount);
        }

        string message = claim.status == APPROVED ? 
            "Claim approved automatically" : 
            "Claim pending approval. Finance team will contact you.";

        return {
            id: claimId,
            status: claim.status,
            message: message
        };
    }


    # Get claim status
    #
    # + userId - ID of the user requesting claim status
    # + claimId - ID of the claim
    # + return - Claim response or error
    resource function get [string claimId](string userId) returns ClaimResponse|error {
        Claim? claim = claims[claimId];
        
        if claim is () {
            return error("Claim not found");
        }

        if claim.userId != userId {
            return error("Unauthorized to view this claim");
        }

        return {
            id: claim.id,
            status: claim.status,
            message: claim.status == APPROVED ? "Claim is approved" : "Claim is pending approval"
        };
    }
}

# Get next claim ID
#
# + return - Generated claim ID or error
isolated function getNextClaimId() returns string|error {
    int nextId;
    lock {
        nextId = claimCounter + 1;
        claimCounter = nextId;
    }
    return string `CLAIM-${nextId}`;
}

# Send email notification for pending claims
#
# + userId - ID of the user
# + claimId - ID of the claim
# + amount - Amount of the claim
# + return - Error if sending email fails
function sendEmailNotification(string userId, string claimId, decimal amount) returns error? {
    string subject = string `Claim ${claimId} Pending Approval`;
    string body = string `Claim ${claimId} for amount $${amount} is pending approval as it exceeds the pre-authorized limit. 
    The finance team will contact you soon.`;

    // Send email to user
    check smtpClient->sendMessage({
        to: userId,
        subject: subject,
        body: body
    });


    // Send email to finance team
    check smtpClient->sendMessage({
        to: financeTeamEmail,
        subject: string `New Pending Claim: ${claimId}`,
        body: string `New claim ${claimId} from ${userId} for amount $${amount} needs approval.`
 
   });
}
