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

type ErrorResponse record {|
    string message;
    string errorCode;
|};
