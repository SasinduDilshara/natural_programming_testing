import ballerinax/java.jdbc;

# Configuration for database connection
configurable string dbHost = "localhost";
configurable string dbName = "gms_db";
configurable string dbUser = "root";
configurable string dbPassword = "root";

# Initialize JDBC Client
final jdbc:Client dbClient = check new (
    url = string `jdbc:mysql://${dbHost}/${dbName}`,
    user = dbUser,
    password = dbPassword
);