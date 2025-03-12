import ballerina/sql;

# Register a new guest in the system
#
# + guest - Guest information
# + return - Guest ID if successful, error if failed
public function registerGuest(Guest guest) returns int|error {
    sql:ExecutionResult result = check dbClient->execute(`
        INSERT INTO guests (name, email, phone_number, status)
        VALUES (${guest.name}, ${guest.email}, ${guest.phoneNumber}, 'REGISTERED')
    `);

    int|string? generatedId = result.lastInsertId;
    if generatedId is int {
        return generatedId;
    }
    return error("Failed to retrieve generated ID");
}

# Create a new registration entry
#
# + registration - Registration information
# + return - Registration ID if successful, error if failed
public function createRegistration(Registration registration) returns int|error {
    sql:ExecutionResult result = check dbClient->execute(`
        INSERT INTO registrations (guest_id, host_id, purpose, check_in_time, qr_code)
        VALUES (${registration.guestId}, ${registration.hostId}, ${registration.purpose}, 
                ${registration.checkInTime}, ${registration.qrCode})
    `);

    int|string? generatedId = result.lastInsertId;
    if generatedId is int {
        return generatedId;
    }
    return error("Failed to retrieve generated ID");
}

# Get guest details by ID
#
# + guestId - ID of the guest
# + return - Guest record if found, error if not found
public function getGuestById(int guestId) returns Guest|error {
    Guest guest = check dbClient->queryRow(`
        SELECT id, name, email, phone_number as phoneNumber, status 
        FROM guests WHERE id = ${guestId}
    `);
    return guest;
}

# Update guest check-in status
#
# + guestId - ID of the guest
# + status - New status to set
# + return - Error if operation fails
public function updateGuestStatus(int guestId, string status) returns error? {
    _ = check dbClient->execute(`
        UPDATE guests SET status = ${status}
        WHERE id = ${guestId}
    `);
}

# Get daily guest report
#
# + date - Date for the report
# + return - Array of guests checked in on the given date, error if operation fails
public function getDailyGuestReport(string date) returns Guest[]|error {
    stream<Guest, error?> guestStream = dbClient->query(`
        SELECT g.id, g.name, g.email, g.phone_number as phoneNumber, g.status
        FROM guests g
        JOIN registrations r ON g.id = r.guest_id
        WHERE DATE(r.check_in_time) = ${date}
    `);

    Guest[] guests = [];
    check from Guest guest in guestStream
        do {
            guests.push(guest);
        };

    return guests;
}
