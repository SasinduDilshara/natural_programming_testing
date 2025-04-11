import ballerina/email;
import ballerina/http;
import ballerina/uuid;

# SMTP client configuration
configurable string smtpHost = "smtp.email.com";
configurable string smtpUsername = "username";
configurable string smtpPassword = "password";

# Email configuration
final string FINANCE_EMAIL = "finance@example.com";

# Claim statuses
final string STATUS_APPROVED = "APPROVED";
final string STATUS_PENDING = "PENDING";

# Initialize SMTP client
final email:SmtpClient smtpClient = check new (
	host = smtpHost,
	username = smtpUsername,
	password = smtpPassword
);

# In-memory storage for claims
map<Claim> claims = {};

# Service to manage expense claims
service / on new http:Listener(8080) {
	# Submit a new expense claim
	#
	# + request - The claim submission request
	# + return - The claim response or error
	resource function post claims(@http:Payload ClaimRequest request) returns ClaimResponse|error {
		string claimId = uuid:createType1AsString();

		Claim claim = {
			id: claimId,
			userId: request.userId,
			amount: request.amount,
			status: request.amount <= 10d ? STATUS_APPROVED : STATUS_PENDING
		};
		
		claims[claimId] = claim;

		if claim.status == STATUS_PENDING {
			email:Error? emailError = sendEmailNotifications(claim);
			if emailError is email:Error {
				return error("Failed to send email notifications", emailError);
			}
		}

		return {
			id: claim.id,
			status: claim.status
		};
	}

	# Check the status of an existing claim
	#
	# + claimId - The ID of the claim to check
	# + userId - The ID of the user requesting the status
	# + return - The claim response or error
	resource function get claims/[string claimId](@http:Header string userId) returns ClaimResponse|error {
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

# Send email notifications for pending claims
#
# + claim - The claim details
# + return - Error if sending email fails
function sendEmailNotifications(Claim claim) returns email:Error? {
	email:Message emailMessage = {
		'from: smtpUsername,
		subject: string `New Expense Claim Pending Review - ${claim.id}`,
		to: [FINANCE_EMAIL, claim.userId],
		body: string `A new expense claim (ID: ${claim.id}) for $${claim.amount} requires review.`
	};

	check smtpClient->sendMessage(email = emailMessage);
}
