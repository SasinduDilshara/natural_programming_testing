// Prompt 1
type PROMPT1 Session;
type Session record {|
    string title;
    string date;
    string time;
    string location;
    string[] speakers;
    string description;
|};

type Product record {
    string name;
    string description;
};

type Customer record {
    string companyName;
    string usageSummary;
};

type User record {|
    string attendeeName;
    string company;
    string role;
|};

type ConferenceData record {
    Session[] sessions;
    Product[] products;
    Customer customer;
    User user;
};

// Prompt 2
type PROMPT2 Match;

type Match record {|
    string id;
    string reason;
    string[] tags;
|};

// Prompt 3
type PROMPT3 reviewAverage;
type reviewAverage int[];

// Prompt 4
type PROMPT4 ReviewSingle;
type ReviewSingle string[];

// Prompt 5
type PROMPT5 ReviewSingleWord;
type ReviewSingleWord string;

// Prompt 6
type PROMPT6 ReviewSingleInteger;
type ReviewSingleInteger int;

// Prompt 7
type PROMPT7 Order;
type Order record {|
    string OrderID;
    string ProductName;
    int Quantity;
    decimal Price;
    string Date;
|};

type CustomerDetails record {
    string Name;
    int Age;
    string Email;
    string Address;
    string Phone;
    Order[] Orders;
};

type Employee record {
    string EmployeeID;
    string Name;
    string Position;
    string Department;
    string HireDate;
    string[] Skills;
};

type Company record {
    string CompanyName;
    string Founded;
    string Location;
    int Employees;
    decimal AnnualRevenue;
    string Industry;
};

type BusinessData record {
    CustomerDetails customer;
    Employee employee;
    Company company;
};

// Prompt 8
type PROMPT8 Event;
type Event record {|
    string eventName;
    string eventDate;
    string location;
    string companyName;
    string keynoteSpeaker;
    string keynoteTopic;
    int numberOfAttendees;
    string[] industriesRepresented;
    string[] productsAnnounced;
    string[] executiveNames;
    string panelModeratorName;
    string panelModeratorAffiliation;
|};

// Prompt 9
type PROMPT9 Match;
type InvalidExp Match;

type PROMPT10 PROMPT1|PROMPT2;
type PROMPT11 PROMPT1?;
type PROMPT12 PROMPT2|PROMPT1;
type PROMPT13 PROMPT2|PROMPT1?;

type PROMPT14 PROMPT4|PROMPT5;
type PROMPT15 PROMPT5?;
type PROMPT16 PROMPT6|PROMPT6;
type PROMPT17 PROMPT1|PROMPT7?;

type PROMPT18 PROMPT1?|PROMPT1?;
