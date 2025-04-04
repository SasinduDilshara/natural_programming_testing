public type Claim record {|
    string claimId;
    string userId;
    decimal amount;
    string status;
    string description;
|};

// Represents the response for claim status
public type StatusResponse record {|
    string message;
    Claim claim?;
|};
