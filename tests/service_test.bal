import ballerina/http;
import ballerina/sql;
import ballerina/test;

final http:Client testClient = check new ("http://localhost:8080");

@test:BeforeSuite
function setupTestDatabase() returns error? {
    sql:ParameterizedQuery createTable = `
        CREATE TABLE IF NOT EXISTS visits (
            id INT AUTO_INCREMENT PRIMARY KEY,
            guest_name VARCHAR(255) NOT NULL,
            resident_name VARCHAR(255) NOT NULL,
            visit_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )`;
    _ = check dbClient->execute(createTable);
}

// Test 1: Regular Guest Check-in Process
@test:Config {}
function testRegularGuestCheckIn() returns error? {
    GuestCheckInRequest checkInRequest = {
        fullName: "John Smith",
        residentName: "Alice Brown"
    };

    http:Response response = check testClient->/guest\-management/check\-in.post(checkInRequest);
    test:assertEquals(response.statusCode, 200);
    
    CheckInResponse checkInResponse = check (check response.getJsonPayload()).cloneWithType(CheckInResponse);
    test:assertEquals(checkInResponse.status, "PENDING_VALIDATION");
    test:assertEquals(checkInResponse.message, "Please wait for security validation.");

    check cleanupTestData("John Smith");
}

// Test 2: Frequent Visitor Check-in
@test:Config {}
function testFrequentVisitorCheckIn() returns error? {
    string guestName = "Robert Wilson";
    string residentName = "Carol Davis";

    // Setup frequent visitor history
    check setupFrequentVisitor(guestName, residentName);

    GuestCheckInRequest checkInRequest = {
        fullName: guestName,
        residentName: residentName
    };

    http:Response response = check testClient->/guest\-management/check\-in.post(checkInRequest);
    test:assertEquals(response.statusCode, 200);
    
    CheckInResponse checkInResponse = check (check response.getJsonPayload()).cloneWithType(CheckInResponse);
    test:assertEquals(checkInResponse.status, "APPROVED");
    test:assertEquals(checkInResponse.message, "Welcome back! Access granted as frequent visitor.");

    check cleanupTestData(guestName);
}

// Test 3: Failed Identity Validation
@test:Config {}
function testFailedIdentityValidation() returns error? {
    GuestCheckInRequest checkInRequest = {
        fullName: "",
        residentName: "David Miller"
    };

    http:Response response = check testClient->/guest\-management/check\-in.post(checkInRequest);
    test:assertEquals(response.statusCode, 200);
    
    CheckInResponse checkInResponse = check (check response.getJsonPayload()).cloneWithType(CheckInResponse);
    test:assertEquals(checkInResponse.status, "REJECTED");
    test:assertEquals(checkInResponse.message, "Identity verification failed.");
}

// Test 4: Security Validation Process
@test:Config {}
function testSecurityValidation() returns error? {
    // First create a check-in
    GuestCheckInRequest checkInRequest = {
        fullName: "Eve Johnson",
        residentName: "Frank White"
    };

    _ = check testClient->/guest\-management/check\-in.post(checkInRequest);

    // Then test security validation
    SecurityValidationRequest validationRequest = {
        guestName: "Eve Johnson",
        residentName: "Frank White",
        securityNote: "Identity verified with driver's license"
    };

    http:Response response = check testClient->/guest\-management/security/validate.post(validationRequest);
    test:assertEquals(response.statusCode, 200);
    
    ResidentResponse validationResponse = check (check response.getJsonPayload()).cloneWithType(ResidentResponse);
    test:assertTrue(validationResponse.approved);

    check cleanupTestData("Eve Johnson");
}

// Test 5: Invalid Security Validation Request
@test:Config {}
function testInvalidSecurityValidation() returns error? {
    SecurityValidationRequest validationRequest = {
        guestName: "Unknown Guest",
        residentName: "Unknown Resident",
        securityNote: "No prior check-in"
    };

    http:Response response = check testClient->/guest\-management/security/validate.post(validationRequest);
    test:assertEquals(response.statusCode, 200);
    
    ResidentResponse validationResponse = check (check response.getJsonPayload()).cloneWithType(ResidentResponse);
    test:assertFalse(validationResponse.approved);
    test:assertEquals(validationResponse.message, "No recent check-in request found for this guest.");
}

// Test 6: Visit Logging Verification
@test:Config {}
function testVisitLogging() returns error? {
    string guestName = "Grace Green";
    string residentName = "Henry Hall";

    GuestCheckInRequest checkInRequest = {
        fullName: guestName,
        residentName: residentName
    };

    _ = check testClient->/guest\-management/check\-in.post(checkInRequest);

    // Verify visit was logged
    sql:ParameterizedQuery query = `SELECT COUNT(*) as count FROM visits 
                                   WHERE guest_name = ${guestName} 
                                   AND resident_name = ${residentName}`;
    record {|int count;|} result = check dbClient->queryRow(query);
    test:assertEquals(result.count, 1);

    check cleanupTestData(guestName);
}

@test:AfterSuite
function cleanupTestDatabase() returns error? {
    sql:ParameterizedQuery dropTable = `DROP TABLE IF EXISTS visits`;
    _ = check dbClient->execute(dropTable);
}