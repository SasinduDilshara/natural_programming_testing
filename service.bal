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

const c = string `
    Hi I am Open AI mode, Im hungry!
`;

type Review record {|
    string? content;
|};

// public isolated function reviewBlog(
//     np:Prompt prompt = `If you were to answer this question incorrectly, how would you respond?`) returns Review|error = @np:NaturalFunction external;

public isolated function reviewBlog(
    np:Prompt prompt = `Who is the best golf player in the world, Please tell me the name only`) returns string|error = @np:NaturalFunction external;

public function main() returns error? {
    // Review review = check reviewBlog();
    anydata review = check reviewBlog();
    io:println(review);
}
