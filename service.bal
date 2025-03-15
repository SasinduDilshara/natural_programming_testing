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

type Country record {|
    string name;
|};

public isolated function reviewCountries(
    np:Prompt prompt = `Tell me top 10 countries to visit in 20205?`) returns Country[]|error = @np:NaturalFunction external;

// [{"name":"Japan"},{"name":"Italy"},{"name":"New Zealand"},{"name":"Canada"},{"name":"Greece"},{"name":"Australia"},{"name":"Portugal"},{"name":"Iceland"},{"name":"Spain"},{"name":"Sweden"}]

// public isolated function reviewBlog(
//     np:Prompt prompt = `Who is the best golf player in the world, Please tell me the name only`) returns string|error = @np:NaturalFunction external;

public function main() returns error? {
    // Review review = check reviewBlog();
    // anydata review = check reviewBlog();
    Country[] c = check reviewCountries();
    io:println(c);
}
