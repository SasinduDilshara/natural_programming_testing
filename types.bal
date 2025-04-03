# Represents a student with an ID, name, and age.
# 
# + id - The unique identifier for the student.
# + name - The name of the student (string).
# + age - The age of the student (must be between 5 and 100).
type Student record {|
    int id;
    string name;
    int age;
|};
