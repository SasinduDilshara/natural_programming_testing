# Represents an expense claim.
#
# + id - Unique identifier for the claim
# + amount - Claim amount in dollars
# + status - Current status of the claim
# + userId - ID of the user who submitted the claim
public type Claim record {|
    string id;
    decimal amount;
    string status;
    string userId;
|};

# Represents a claim submission request.
#
# + amount - Claim amount in dollars
# + userId - ID of the user submitting the claim
public type ClaimRequest record {|
    decimal amount;
    string userId;
|};

# Represents a claim status response.
#
# + id - Claim ID
# + status - Current status of the claim
public type ClaimResponse record {|
    string id;
    string status;
|};