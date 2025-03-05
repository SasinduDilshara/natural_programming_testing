type Item record {|
    string itemId;
    int quantity;
    decimal price;
|};

type Order record {|
    string orderId;
    string userId;
    Item[] items;
    decimal totalAmount;
    string status;
|};

type OrderCreationRequest record {|
    string userId;
    Item[] items;
|};

type OrderUpdateRequest record {|
    Item[] items;
    string status;
|};

type User record {|
    string userId;
    string userName;
    string email;
|};

type ErrorResponse record {|
    string message;
    string code;
|};