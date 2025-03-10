# Represents a claim submission request.
#
# + amount - The claim amount
# + description - Description of the claim
# + userId - ID of the user submitting the claim
public type ClaimRequest record {|
    decimal amount;
    string description;
    string userId;
|};

# Represents a claim in the system.
#
# + id - Unique identifier for the claim
# + amount - The claim amount
# + description - Description of the claim
# + status - Current status of the claim
# + userId - ID of the user who submitted the claim
public type Claim record {|
    string id;
    decimal amount;
    string description;
    string status;
    string userId;
|};

# Represents a claim status request.
#
# + claimId - ID of the claim to check
# + userId - ID of the user requesting the status
public type StatusRequest record {|
    string claimId;
    string userId;
|};