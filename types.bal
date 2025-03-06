# Represents a Student in the system.
#
# + id - Unique identifier for the guest
# + name - Name of the guest
# + email - Email address of the guest
# + phoneNumber - Contact number of the guest
public type Guest record {|
    string id;
    string name;
    string email;
    string phoneNumber;
|};

# Represents a request to create a new guest.
#
# + name - Name of the student
# + email - Email address of the guest
# + phoneNumber - Contact number of the guest
public type GuestCreateRequest record {|
    string name;
    string email;
    string phoneNumber;
|};

# Represents a request to update an existing guest.
#
# + name - Updated name of the guest
# + email - Updated email address of the guest
# + phoneNumber - Updated contact number of the guest
public type GuestUpdateRequest record {|
    string name;
    string email;
    string phoneNumber;
|};

# Represents an error response.
#
# + message - Error message
# + code - Error code
public type ErrorResponse record {|
    string message;
    string code;
|};
