# Represents a guest in the visitor management system.
#
# + guestId - Unique identifier for the guest
# + firstName - First name of the guest
# + lastName - Last name of the guest
# + email - Email address of the guest
# + phoneNumber - Contact number of the guest
# + idType - Type of identification document (e.g., Passport, Driver's License)
# + idNumber - Identification document number
public type Guest record {|
    string guestId;
    string firstName;
    string lastName;
    string email;
    string phoneNumber;
    string idType;
    string idNumber;
|};

# Represents a host in the visitor management system.
#
# + hostId - Unique identifier for the host
# + firstName - First name of the host
# + lastName - Last name of the host
# + email - Email address of the host
# + department - Department where the host works
# + phoneNumber - Contact number of the host
public type Host record {|
    string hostId;
    string firstName;
    string lastName;
    string email;
    string department;
    string phoneNumber;
|};

# Represents a Student in the visitor management system.
#
# + visitId - Unique identifier for the visit
# + guestId - Identifier of the guest making the visit
# + hostId - Identifier of the host being visited
# + purpose - Purpose of the visit
# + checkInTime - Time when the visit started
# + checkOutTime - Time when the visit ended (null if visit is ongoing)
# + status - Current status of the visit (e.g., ACTIVE, COMPLETED)
public type Visit record {|
    string visitId;
    string guestId;
    string hostId;
    string purpose;
    string checkInTime;
    string? checkOutTime;
    string status;
|};

# Represents a visitor badge in the visitor management system.
#
# + badgeId - Unique identifier for the badge
# + visitId - Associated visit identifier
# + guestName - Name of the guest
# + hostName - Name of the host
# + validUntil - Badge validity end time
public type Badge record {|
    string badgeId;
    string visitId;
    string guestName;
    string hostName;
    string validUntil;
|};
