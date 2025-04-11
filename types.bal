# Represents a claim request
public type ClaimRequest record {|
    # Amount of the claim
    decimal amount;
    # Description of the claim
    string description;
    # ID of the user submitting the claim
    string userId;
    # Email of the user
    string userEmail;
|};

# Represents a claim status request
public type StatusRequest record {|
    # ID of the claim to check
    string claimId;
    # ID of the user requesting status
    string userId;
|};

# Represents a claim
public type Claim record {|
    # Unique identifier for the claim
    string id;
    # Amount of the claim
    decimal amount;
    # Description of the claim
    string description;
    # Current status of the claim
    string status;
    # ID of the user who submitted the claim
    string userId;
|};