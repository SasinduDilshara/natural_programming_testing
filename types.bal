# Represents a claim request
#
# + userId - ID of the user submitting the claim  
# + amount - Amount of the expense claim
public type ClaimRequest record {|
    string userId;
    decimal amount;
|};

# Represents a claim response
#
# + id - Unique identifier of the claim
# + status - Status of the claim (APPROVED/PENDING)
public type ClaimResponse record {|
    string id;
    string status;
|};

# Represents a claim record
#
# + id - Unique identifier of the claim
# + userId - ID of the user who submitted the claim
# + amount - Amount of the expense claim
# + status - Status of the claim (APPROVED/PENDING)
public type Claim record {|
    string id;
    string userId;
    decimal amount;
    string status;
|};