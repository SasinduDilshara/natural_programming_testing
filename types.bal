# Represents a claim in the system.
#
# + id - Unique identifier for the claim
# + userId - ID of the user who submitted the claim
# + amount - Amount of the claim
# + status - Current status of the claim
type Claim record {|
    string id;
    string userId;
    decimal amount;
    ClaimStatus status;
|};

# Represents the status of a claim.
#
# + APPROVED - Claim is approved
# + PENDING - Claim is pending approval
public enum ClaimStatus {
    APPROVED,
    PENDING
}

# Represents the response for a claim submission.
#
# + id - Unique identifier for the claim
# + status - Status of the claim
# + message - Additional message about the claim
type ClaimResponse record {|
    string id;
    ClaimStatus status;
    string message;
|};

# Represents a new claim request.
#
# + amount - Amount of the claim
type ClaimRequest record {|
    decimal amount;
|};