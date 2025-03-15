// Guest record with QR code
public type Guest record {|
    string id;
    string name;
    string email;
    string phoneNumber;
    string qrCode;
|};

// Guest create request
public type GuestCreateRequest record {|
    string name;
    string email;
    string phoneNumber;
|};

// Guest update request
public type GuestUpdateRequest record {|
    string name;
    string email;
    string phoneNumber;
|};

// Error response record
public type ErrorResponse record {|
    string message;
    string code;
|};

// Database guest record
type DbGuest record {|
    string id;
    string name;
    string email;
    string phone_number;
    string qr_code;
|};