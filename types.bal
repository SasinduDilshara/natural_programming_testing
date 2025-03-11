# Represents a guest check-in request
#
# + fullName - Full name of the guest
# + residentName - Name of the resident to visit
public type GuestCheckInRequest record {|
    string fullName;
    string residentName;
|};

# Represents a guest visit record
#
# + id - Visit ID
# + guestName - Name of the guest
# + residentName - Name of the resident visited
# + visitTime - Timestamp of the visit
public type Visit record {|
    int id;
    string guestName;
    string residentName;
    string visitTime;
|};

# Represents check-in response
#
# + status - Status of the check-in request
# + message - Additional message about the check-in
public type CheckInResponse record {|
    string status;
    string message;
|};

# Represents security validation request
#
# + guestName - Name of the guest
# + residentName - Name of the resident
# + securityNote - Additional notes from security
public type SecurityValidationRequest record {|
    string guestName;
    string residentName;
    string securityNote;
|};

# Represents resident response
#
# + approved - Whether the visit is approved
# + message - Optional message from resident
public type ResidentResponse record {|
    boolean approved;
    string message;
|};