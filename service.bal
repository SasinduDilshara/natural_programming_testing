import ballerinax/np;
import ballerina/io;

// fuction to loadCategories
public function loadCategories() returns readonly & string[] {
    return ["Technology", "Lifestyle", "Travel", "Food", "Fashion"];
}

final readonly & string[] categories = loadCategories();

public type Blog record {|
    string title;
    string content;
|};

type Review record {|
    string? countryName;
    int rating;
|};

// public isolated function reviewBlog(
//     np:Prompt prompt = `Tell me the best countries to visit on 2025`) returns Review[]|error = @np:LlmCall external;

public isolated function reviewBlog(
    np:Prompt prompt = `Who is the best football player in the world, Please tell me the name only`) returns string|error = @np:NaturalFunction external;

public function main() returns error? {
    // Review[] review = check reviewBlog();
    anydata review = check reviewBlog();
    io:println(review);
}
