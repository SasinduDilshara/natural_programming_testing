# Expense Claims Management System

A Ballerina-based service for managing employee expense claims with automatic approval capabilities and status tracking.

## Modules

### Main Module
Handles HTTP endpoints for claim submission and status retrieval with the following features:
- Automatic claim approval based on configurable limits
- Claim status verification with user authorization
- Database persistence for claims
- Unique claim ID generation

### Claims Implementation Module (`claims.impl`)
Provides core business logic including

## Prerequisites

- Ballerina Swan Lake 2201.8.0 or later
- Java Database (H2)

## Configuration

Configure the service using `Config.toml`:

```toml
# Maximum amount for automatic claim approval
claimLimit = 1500.0

# Finance team email for manual approvals
financeTeamEmail = "finance@example.com"

# Database configurations (in claims.impl module)
dbUrl = "jdbc:h2:file:./claims"
dbUsername = "sa"
dbPassword = ""
```

## API Endpoints

### Submit Claim

Submit a new expense claim for processing.

**Endpoint:** POST `/claims/add/submit`

**Request Body:**
```json
{
    "claimId": "",
    "userId": "EMP123",
    "amount": 450.00,
    "status": "",
    "description": "Travel expenses for client meeting"
}
```

**Response:**
```json
{
    "message": "Claim approved automatically",
    "claimId": "CLAIM_1",
    "status": "APPROVED"
}
```

### Get Claim Status

Retrieve status of a specific claim.

**Endpoint:** GET `/claims/prove/status/{claimId}`

**Headers:**
```
userId: EMP123
```

**Response:**
```json
{
    "message": "Claim status retrieved successfully",
    "claim": {
        "claimId": "CLAIM_1",
        "userId": "EMP123",
        "amount": 450.00,
        "status": "APPROVED",
        "description": "Travel expenses for client meeting"
    }
}
```

## Database Schema

```sql
CREATE TABLE claims (
    claim_id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(50),
    amount DECIMAL(10,2),
    status VARCHAR(20),
    description TEXT
);
```

## Running the Service

1. Create the database schema
2. Configure `Config.toml`
3. Start the service:
   ```bash
   bal run
   ```

The service runs on port 1220.