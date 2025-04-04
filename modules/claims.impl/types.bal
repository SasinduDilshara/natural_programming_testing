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