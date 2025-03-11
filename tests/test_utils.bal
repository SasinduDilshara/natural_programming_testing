import ballerina/sql;

function cleanupTestData(string guestName) returns error? {
    sql:ParameterizedQuery query = `DELETE FROM visits WHERE guest_name = ${guestName}`;
    _ = check dbClient->execute(query);
}

function setupFrequentVisitor(string guestName, string residentName) returns error? {
    // Add 6 visits within the past week
    sql:ParameterizedQuery query = `
        INSERT INTO visits (guest_name, resident_name, visit_time) 
        VALUES 
        (${guestName}, ${residentName}, NOW() - INTERVAL 1 DAY),
        (${guestName}, ${residentName}, NOW() - INTERVAL 2 DAY),
        (${guestName}, ${residentName}, NOW() - INTERVAL 3 DAY),
        (${guestName}, ${residentName}, NOW() - INTERVAL 4 DAY),
        (${guestName}, ${residentName}, NOW() - INTERVAL 5 DAY),
        (${guestName}, ${residentName}, NOW() - INTERVAL 6 DAY)`;
    _ = check dbClient->execute(query);
}