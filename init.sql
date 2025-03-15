IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'guest_db')
BEGIN
    CREATE DATABASE guest_db;
END
GO

USE guest_db;
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[guests]') AND type in (N'U'))
BEGIN
    CREATE TABLE guests (
        id VARCHAR(36) PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        email VARCHAR(100) NOT NULL,
        phone_number VARCHAR(20) NOT NULL,
        qr_code TEXT NOT NULL
    );
END