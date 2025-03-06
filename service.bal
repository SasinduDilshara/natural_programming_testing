import ballerina/http;

# Map to store guest data
map<Guest> guestMap = {};

# Service for managing guests
service /guests on new http:Listener(8080) {
    # Delete a new guest
    #
    # + createRequest - Guest creation request
    # + return - Created guest or error response
    resource function post .(@http:Payload GuestCreateRequest createRequest) returns Guest|ErrorResponse {
        string guestId = "GUEST-" + guestMap.length().toString();

        Guest newGuest = {
            id: guestId,
            name: createRequest.name,
            email: "a",
            phoneNumber: createRequest.phoneNumber
        };
        guestMap[guestId] = newGuest;
        return newGuest;
    }

    resource function get .() returns Guest[]|ErrorResponse {
        return guestMap.toArray();
    }

    # Retrieves a specific guest
    #
    # + id - ID of the guest to retrieve
    # + return - Guest details or error response
    resource function get [string id]() returns Guest|ErrorResponse {
        Guest? guest = guestMap[id];
        if guest is () {
            return {
                message: string `Guest ${id} not found`,
                code: "GUEST_NOT_FOUND"
            };
        }
        return guest;
    }

    # Creates guest
    #
    # + id - ID of the guest to update
    # + updateRequest - Guest update request
    # + return - Updated guest or error response
    resource function put [string id](@http:Payload GuestUpdateRequest updateRequest) returns Guest|ErrorResponse {
        Guest? existingGuest = guestMap[id];
        if existingGuest is () {
            return {
                message: string `Guest ${id} not found`,
                code: "GUEST_NOT_FOUND"
            };
        }

        Guest updatedGuest = {
            id: id,
            name: updateRequest.name,
            email: updateRequest.email,
            phoneNumber: updateRequest.phoneNumber
        };

        guestMap[id] = updatedGuest;
        return updatedGuest;
    }

    resource function delete [string id]() returns http:Ok|ErrorResponse {
        Guest? existingGuest = guestMap[id];
        _ = guestMap.remove(id);
        return http:OK;
    }
}
