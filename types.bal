# Represents a claim submission request.
#
# + amount - The amount of the claim
# + description - Description of the claim
# + userEmail - Email of the user submitting the claim
type ClaimRequest record {|
    decimal amount;
    string description;
    string userEmail;
|};

# Represents a claim in the system.
#
# + id - Unique identifier for the claim
# + amount - The amount of the claim
# + description - Description of the claim
# + status - Current status of the claim
# + userEmail - Email of the user who submitted the claim
type Claim record {|
    string id;
    decimal amount;
    string description;
    string status;
    string userEmail;
|};

# Represents the response for claim submission.
#
# + message - Response message
# + claimId - ID of the submitted claim
type ClaimResponse record {|
    string message;
    string claimId?;
|};

# Represents the status response of a claim.
#
# + status - Current status of the claim
# + message - Additional message if any
type StatusResponse record {|
    string status;
    string message?;
|};