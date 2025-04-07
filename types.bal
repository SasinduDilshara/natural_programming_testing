# Represents an expense claim submitted by a user
# + claimId - Unique identifier for the claim
# + userId - Identifier of the user submitting the claim
# + amount - The monetary amount being claimed
# + status - Current status of the claim (APPROVED/PENDING)
# + description - Detailed description of the expense
public type Claim record {|
    string claimId;
    string userId;
    decimal amount;
    string status;
    string description;
|};

# Represents the response when querying the status of a claim
#
# + message - Descriptive message about the claim status  
# + claimId - claim ID  
# + status - field description
public type ClaimResponse record {|
    string message;
    string claimId;
    string status;
|};

# Represents the response when querying the status of a claim
# + message - Descriptive message about the claim status
# + claim - The claim details if found, or nil if not found
public type StatusResponse record {|
    string message;
    Claim? claim;
|};