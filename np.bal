import ballerina/http;
import ballerinax/np;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;

# Configuration for database connection.
#
# + host - Database host
# + user - Database user
# + password - Database password
# + database - Database name
# + port - Database port
public type DbConfig record {|
    string host;
    string user;
    string password;
    string database;
    int port = 3306;
|};

# Configurable database configuration
configurable DbConfig dbConfig = ?;

# MySQL client instance
final mysql:Client db = check new (...dbConfig);

# Available blog categories
final readonly & string[] categories = [
    "Tech Innovations & Software Development",
    "Programming Languages & Frameworks",
    "DevOps, Cloud Computing & Automation",
    "Career Growth in Tech",
    "Open Source & Community-Driven Development"
];

# Represents a blog post.
#
# + title - Title of the blog post
# + content - Content of the blog post
public type Blog record {|
    string title;
    string content;
|};

# Represents a blog record with additional metadata.
#
# + category - Category of the blog post
# + rating - Rating of the blog post
type BlogRecord record {|
    *Blog;
    string category;
    int rating;
|};

# Represents a review of a blog post.
#
# + suggestedCategory - Suggested category for the blog post
# + rating - Rating given to the blog post
type Review record {|
    string? suggestedCategory;
    int rating;
|};

# Service for managing blog posts.
#
# + listener - The HTTP listener instance
service on new http:Listener(8080) {

    # Creates a new blog post.
    #
    # + blog - Blog post to create
    # + return - Created response on success, bad request on validation failure, or internal server error
    resource function post blog(Blog blog) returns http:Created|http:BadRequest|http:InternalServerError {
        do {
            Blog {title, content} = blog;

            Review {suggestedCategory, rating} = check rateBlog(blog);

            if suggestedCategory is () || rating < 4 {
                return <http:BadRequest>{
                    body: "Blog rejected due to low rating or no matching category"};
            }

            _ = db->execute(`INSERT INTO Blog (title, content, rating, category) VALUES (${
                                            title}, ${content}, ${rating}, ${suggestedCategory})`);
            return <http:Created> {body: "Blog accepted"};            
        } on fail {
            return <http:InternalServerError>{body: "Blog submission failed"};
        }
    }

    # Retrieves blogs by category.
    #
    # + category - Category to filter blogs
    # + return - Array of blogs or internal server error
    resource function get blogs/[string category]() returns Blog[]|http:InternalServerError {
        do {
            stream<BlogRecord, error?> result = 
                db->query(
                    `SELECT title, content, rating, category FROM Blog WHERE category = ${
                        category} ORDER BY rating DESC LIMIT 10`);
            return check from BlogRecord blog in result select {title: blog.title, content: blog.content};
        } on fail {
            return <http:InternalServerError>{body: "Failed to retrieve blogs"};
        }
    }    
}

# Represents a student identifier.
public type Student string;

# Evaluates and rates a student.
#
# + student - The student to evaluate
# + prompt - Custom AI prompt for content evaluation
# + return - A Review object containing the evaluation results, or an error if the operation fails
public function rateStudent(
    Student student, 
    np:Prompt prompt = `You are an expert content reviewer for a blog site that 
        categorizes posts under the following categories: ${categories}

        Your tasks are:
        1. Suggest a suitable category for the blog from exactly the specified categories. 
           If there is no match, use null.

        2. Rate the blog post on a scale of 1 to 10 based on the following criteria:
        - **Relevance**: How well the content aligns with the chosen category.
        - **Depth**: The level of detail   and insight in the content.
        - **Clarity**: How easy it is to read and understand.
        - **Originality**: Whether the content introduces fresh perspectives or ideas.
        - **Language Quality**: Grammar, spelling, and overall writing quality.

        Here is the blog post content and submitted category:
        **Blog Post Content:**
        ${blog.title}
        ${blog.content}`) returns Review|error = @np:LlmCall external;
