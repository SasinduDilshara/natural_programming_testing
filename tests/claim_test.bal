import ballerina/test;
import ballerina/http;
import ballerina/email;

final http:Client testClient = check new("http://localhost:8080");

@test:Mock {
    moduleName: "ballerina/email",
    functionName: "sendMessage"
}
test:MockFunction emailMockFn = new();

@test:BeforeSuite
function setupEmailMock() {
    test:when(emailMockFn).call("mockSendEmail");
}

@test:Config {}
function testAutoApprovedClaim() returns error? {
    ClaimRequest request = {
        userId: "user1",
        amount: 10.00
    };

    ClaimResponse response = check testClient->/claims.post(request);
    test:assertEquals(response.status, "APPROVED");
    test:assertTrue(response.id.length() > 0);
}

@test:Config {}
function testPendingClaim() returns error? {
    ClaimRequest request = {
        userId: "user1",
        amount: 100.00
    };

    ClaimResponse response = check testClient->/claims.post(request);
    test:assertEquals(response.status, "PENDING");
    test:assertTrue(response.id.length() > 0);
}

@test:Config {
    dependsOn: [testAutoApprovedClaim]
}
function testAuthorizedStatusRetrieval() returns error? {
    // First create a claim
    ClaimRequest request = {
        userId: "user2",
        amount: 5.00
    };
    ClaimResponse createResponse = check testClient->/claims.post(request);
    
    // Then retrieve its status
    map<string> headers = {"userId": "user2"};
    ClaimResponse statusResponse 
        = check testClient->/claims/[createResponse.id].get(headers = headers);
    test:assertEquals(statusResponse.status, "APPROVED");
    test:assertEquals(statusResponse.id, createResponse.id);
}

@test:Config {
    dependsOn: [testAutoApprovedClaim]
}
function testUnauthorizedStatusRetrieval() returns error? {
    // First create a claim
    ClaimRequest request = {
        userId: "user3",
        amount: 5.00
    };
    ClaimResponse createResponse = check testClient->/claims.post(request);
    
    // Try to retrieve with different user
    map<string> headers = {"userId": "unauthorized_user"};
    error|ClaimResponse response = testClient->/claims/[createResponse.id].get(headers = headers);
    test:assertTrue(response is error);
    if response is error {
        test:assertEquals(response.message(), "Unauthorized to view this claim");
    }
}

@test:Config {}
function testNonExistentClaim() returns error? {
    map<string> headers = {"userId": "user1"};
    error|ClaimResponse response = testClient->/claims/["non-existent-id"].get(headers = headers);
    test:assertTrue(response is error);
    if response is error {
        test:assertEquals(response.message(), "Claim not found");
    }
}

function mockSendEmail(email:Message message) returns email:Error? {
    return ();
}