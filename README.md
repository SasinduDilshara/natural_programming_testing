# Banking System API

This is a simple banking system implemented using Ballerina. The system provides RESTful APIs for managing banks and accounts, including operations such as creating banks, opening accounts, making deposits, and withdrawals.

## Features
- Create and retrieve banks
- Create and retrieve accounts
- Deposit and withdraw funds from accounts

## API Endpoints

### Banks
- **Create a bank**: `POST /banks`
- **Retrieve a bank**: `GET /banks/{bankId}`
- **List all banks**: `GET /banks`

### Accounts
- **Create an account**: `POST /banks/{bankId}/accounts`
- **Retrieve an account**: `GET /banks/{bankId}/accounts/{accountId}`
- **List all accounts in a bank**: `GET /banks/{bankId}/accounts`

### Transactions
- **Deposit funds**: `POST /banks/{bankId}/accounts/{accountId}/deposit`
- **Withdraw funds**: `POST /banks/{bankId}/accounts/{accountId}/withdraw`

## Data Structures

### Bank
```json
{
  "bankId": "string",
  "bankName": "string",
  "location": "string"
}
```

### Account
```json
{
  "accountId": "string",
  "accountHolderName": "string",
  "balance": "number",
  "bankId": "string"
}
```

### BankCreationRequest
```json
{
  "bankName": "string",
  "location": "string"
}
```

### AccountCreationRequest
```json
{
  "accountHolderName": "string",
  "initialDeposit": "number"
}
```

### TransactionRequest
```json
{
  "amount": "number"
}
```

## Error Responses
```json
{
  "message": "string",
  "errorCode": "string"
}
```

## Running the Service
Run the following command to start the banking service:
```sh
bal run
```

The service will be available at `http://localhost:8080/`.

## License
This project is licensed under the MIT License.

