# Represents a guest in the system
#
# + id - Unique identifier for the guest
# + name - Full name of the guest
# + email - Email address of the guest
# + phoneNumber - Contact number of the guest
# + status - Current status of the guest (CHECKED_IN, CHECKED_OUT)
public type Guest record {|
    int id?;
    string name;
    string email;
    string phoneNumber;
    string status;
|};

# Represents a host in the system
#
# + id - Unique identifier for the host
# + name - Full name of the host
# + email - Email address of the host
# + department - Department or section of the host
public type Host record {|
    int id?;
    string name;
    string email;
    string department;
|};

# Represents a guest registration
#
# + id - Unique identifier for the registration
# + guestId - ID of the guest
# + hostId - ID of the host
# + purpose - Purpose of visit
# + checkInTime - Check-in timestamp
# + checkOutTime - Check-out timestamp
# + qrCode - Generated QR code for the visit
public type Registration record {|
    int id?;
    int guestId;
    int hostId;
    string purpose;
    string checkInTime;
    string checkOutTime?;
    string qrCode;
|};