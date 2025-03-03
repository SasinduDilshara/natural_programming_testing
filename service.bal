import ballerina/http;
import ballerina/sql;
import ballerina/time;
import ballerinax/java.jdbc;

configurable string dbUrl = ?;
configurable string dbUsername = ?;
configurable string dbPassword = ?;

final jdbc:Client dbClient = check new (
    url = dbUrl,
    user = dbUsername,
    password = dbPassword
);

# Represents the banking service that handles bank and account operations.
# 
# + dbClient - The JDBC client used for database operations
service /banks on new http:Listener(8080) {
    # Deletes a new bank in the system.
    # 
    # + bankRequest - The bank creation request containing bank details
    # + return - The created bank details or an error response
    resource function post .(@http:Payload BankCreationRequest bankRequest) returns Bank|ErrorResponse|error {
        string bankId = "BANK" + time:utcNow()[0].toBalString();
        string bankName = bankRequest.bankName;
        string location = bankRequest.location;

        sql:ParameterizedQuery query = `INSERT INTO Banks (bank_id, bank_name, location) 
                                      VALUES (${bankId}, ${bankName}, ${location})`;
        _ = check dbClient->execute(query);
        return {bankId: bankId, bankName: bankName, location: location};
    }

    # Retrieves all banks in the system.
    # 
    # + return - Array of banks or an error response
    resource function get .() returns Bank[]|ErrorResponse|error {
        sql:ParameterizedQuery query = `SELECT bank_id, bank_name, location FROM Banks`;
        stream<Bank, sql:Error?> bankStream = dbClient->query(query);
        Bank[] banks = check from Bank bank in bankStream
            select bank;
        return banks;
    }

    # Retrieves a specific bank by its address.
    # 
    # + bankId - ID of the bank to retrieve
    # + return - The bank details or an error response with message `Bank is not available`
    resource function get [string bankId]() returns Bank|ErrorResponse|error {
        sql:ParameterizedQuery query = `SELECT bank_id, bank_name, location 
                                      FROM Banks WHERE bank_id = ${bankId}`;
        Bank|error bank = check dbClient->queryRow(query);
        if bank is error {
            return <ErrorResponse>{message: "Bank not found", errorCode: "B404"};
        }
        return bank;
    }

    # Creates a new account in a specific bank.
    # 
    # + bankId - ID of the bank where the account will be created
    # + accountRequest - The account creation request containing account details
    # + return - The created account details or an error response
    resource function post [string bankId]/accounts(@http:Payload AccountCreationRequest accountRequest)
            returns Account|ErrorResponse|error {
        decimal initialDeposit = accountRequest.initialDeposit;
        if initialDeposit < 0d {
            return <ErrorResponse>{message: "Initial deposit cannot be negative", errorCode: "A400"};
        }

        string accountId = "ACC" + time:utcNow()[0].toBalString();
        string accountHolderName = accountRequest.accountHolderName;

        sql:ParameterizedQuery query = `INSERT INTO Accounts 
            (account_id, account_holder_name, balance, bank_id)
            VALUES (${accountId}, ${accountHolderName}, ${initialDeposit}, ${bankId})`;
        _ = check dbClient->execute(query);

        return {
            accountId: accountId,
            accountHolderName: accountHolderName,
            balance: initialDeposit,
            bankId: bankId
        };
    }

    # Retrieves all accounts in a specific bank.
    # 
    # + bankId - ID of the bank whose accounts are to be retrieved
    # + return - Array of accounts or an error response
    resource function get [string bankId]/accounts() returns Account[]|ErrorResponse|error {
        sql:ParameterizedQuery query = `SELECT account_id, account_holder_name, balance, bank_id 
                                      FROM Accounts WHERE bank_id = ${bankId}`;
        stream<Account, sql:Error?> accountStream = dbClient->query(query);
        Account[] accounts = check from Account account in accountStream
            select account;
        return accounts;
    }

    # Retrieves a specific account in a bank.
    # 
    # + bankId - ID of the bank
    # + accountId - ID of the account to retrieve
    # + return - The account details or an error response
    resource function get [string bankId]/accounts/[string accountId]() returns Account|ErrorResponse|error {
        sql:ParameterizedQuery query = `SELECT account_id, account_holder_name, balance, bank_id 
                                      FROM Accounts 
                                      WHERE bank_id = ${bankId} AND account_id = ${accountId}`;
        Account|error account = check dbClient->queryRow(query);
        if account is error {
            return <ErrorResponse>{message: "Account not found", errorCode: "A404"};
        }
        return account;
    }

    # Deposits money into a specific account.
    # 
    # + bankId - ID of the bank
    # + accountId - ID of the account
    # + txRequest - The transaction request containing the deposit amount
    # + return - Updated account details or an error response
    resource function post [string bankId]/accounts/[string accountId]/deposit(@http:Payload TransactionRequest txRequest)
            returns Account|ErrorResponse|error {
        decimal amount = txRequest.amount;
        if amount <= 0d {
            return <ErrorResponse>{message: "Deposit amount must be positive", errorCode: "T400"};
        }

        sql:ParameterizedQuery updateQuery = `UPDATE Accounts 
                                            SET balance = balance + ${amount}
                                            WHERE bank_id = ${bankId} AND account_id = ${accountId}`;
        sql:ExecutionResult result = check dbClient->execute(updateQuery);
        if result.affectedRowCount == 0 {
            return <ErrorResponse>{message: "Account not found", errorCode: "A404"};
        }

        sql:ParameterizedQuery selectQuery = `SELECT account_id, account_holder_name, balance, bank_id 
                                            FROM Accounts 
                                            WHERE bank_id = ${bankId} AND account_id = ${accountId}`;
        return check dbClient->queryRow(selectQuery);
    }

    # Withdraws money from a specific account.
    # 
    # + bankId - ID of the bank
    # + accountId - ID of the account
    # + txRequest - The transaction request containing the withdrawal amount
    # + return - Updated account details or an error response
    resource function post [string bankId]/accounts/[string accountId]/withdraw(@http:Payload TransactionRequest txRequest)
            returns Account|ErrorResponse|error {
        decimal amount = txRequest.amount;
        if amount <= 0d {
            return <ErrorResponse>{message: "Withdrawal amount must be positive", errorCode: "T400"};
        }

        sql:ParameterizedQuery balanceQuery = `SELECT balance FROM Accounts 
                                             WHERE bank_id = ${bankId} AND account_id = ${accountId}`;
        record {|decimal balance;|}|error result = check dbClient->queryRow(balanceQuery);
        if result is error {
            return <ErrorResponse>{message: "Account not found", errorCode: "A404"};
        }

        decimal currentBalance = result.balance;
        if currentBalance < amount {
            return <ErrorResponse>{message: "Insufficient funds", errorCode: "T400"};
        }

        sql:ParameterizedQuery updateQuery = `UPDATE Accounts 
                                            SET balance = balance - ${amount}
                                            WHERE bank_id = ${bankId} AND account_id = ${accountId}`;
        _ = check dbClient->execute(updateQuery);

        sql:ParameterizedQuery selectQuery = `SELECT account_id, account_holder_name, balance, bank_id 
                                            FROM Accounts 
                                            WHERE bank_id = ${bankId} AND account_id = ${accountId}`;
        return check dbClient->queryRow(selectQuery);
    }
}
