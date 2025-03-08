import ballerinax/postgresql;

// Database configuration
configurable string dbHost = "localhost";
configurable string dbUser = "postgres";
configurable string dbPassword = "postgres";
configurable string dbName = "order_management";
configurable int dbPort = 5432;

// Initialize PostgreSQL client
final postgresql:Client dbClient = check new (
    username = dbUser,
    password = dbPassword,
    database = dbName,
    host = dbHost,
    port = dbPort
);