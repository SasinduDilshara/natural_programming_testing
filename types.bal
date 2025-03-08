// Record to represent an order item
public type OrderItem record {|
    string itemId;
    int quantity;
    decimal price;
|};

// Record to represent an order
public type Order record {|
    string orderId;
    string userId;
    OrderItem[] items;
    decimal totalAmount;
    string status;
|};

// Record to represent order creation request
public type OrderCreationRequest record {|
    string userId;
    OrderItem[] items;
|};

// Record to represent a user
public type User record {|
    string userId;
    string userName;
    string email;
|};

// Record to represent error response
public type ErrorResponse record {|
    string message;
    string code;
|};