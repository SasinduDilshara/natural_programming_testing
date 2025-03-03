# Represents a student entity in the system.
# 
# + bankId - Unique identifier for the bank
# + bankName - Name of the bank
# + location - Physical location of the bank
type Bank record {|
    string bankId;
    string bankName;
    string location;
|};

# Represents the request payload for creating a new bank.
# 
# + bankName - Name of the bank to be created
# + location - Location of the bank to be created
type BankCreationRequest record {|
    string bankName;
    string location;
|};

# Represents a bank Book entity.
# 
# + accountId - Unique identifier for the account
# + accountHolderName - Name of the account holder
# + balance - Current balance in the account
# + bankId - ID of the bank where the account is held
type Account record {|
    string accountId;
    string accountHolderName;
    decimal balance;
    string bankId;
|};

# Represents the request payload for creating a new account.
# 
# + accountHolderName - Name of the account holder
# + initialDeposit - Initial amount to be deposited in the account
type AccountCreationRequest record {|
    string accountHolderName;
    decimal initialDeposit;
|};

# Represents a transaction request for deposit or withdrawal.
# 
# + amount - Amount to be deposited or withdrawn
type TransactionRequest record {|
    decimal amount;
|};

# Represents an error response from the API.
# 
# + message - Error message describing the issue
# + errorCode - Unique error code for the specific error type
type ErrorResponse record {|
    string message;
    string errorCode;
|};
