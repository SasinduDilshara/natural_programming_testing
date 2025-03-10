CREATE TABLE claims (
    id VARCHAR(36) PRIMARY KEY,
    amount DECIMAL(10,2) NOT NULL,
    description TEXT NOT NULL,
    status VARCHAR(20) NOT NULL,
    user_id VARCHAR(36) NOT NULL
);