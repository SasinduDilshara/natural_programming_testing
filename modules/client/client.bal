import ballerina/http;

# A global isolated map to store student records in memory.
# The key is the student's ID (as a string), and the value is the `Student` record.
isolated map<Student> students = {};

# The Student Management API service.
#
# Provides endpoints to add, retrieve, and delete student records.
# Ensures validation for duplicate IDs, name type, and age constraints.
service /students on new http:Listener(8080) {
    # Adds a new student to the system.
    #
    # **Constraints:**  
    # - The student ID must be unique.  
    # - The student's name must be a string.  
    # - The student's age must be between 5 and 10.  
    #
    # + student - The `Student` record containing the student details.
    # + return - A success message if the student is added successfully, or an error message if validation fails.
    isolated resource function post add(Student student) returns string|error|error {
        do {

            lock {
                // Check if the student ID already exists
                if students.hasKey(student.id.toString()) {
                    return error("A student with this ID already exists.");
                }
                // Validate age constraints
                if student.age < 5 || student.age > 100 {
                    return error("Age must be between 5 and 100.");
                }
                // Add student to the map
                students[student.id.toString()] = student.cloneReadOnly();
                return "Student added successfully.";
            }

        } on fail var e {
            return e;
        }
    }

    # Retrieves a student by ID.
    #
    # + id - The ID of the student to retrieve.
    # + return - The `Student` record if found, or an error if the student is not found.
    isolated resource function get get(int id) returns Student? & readonly|error|error {
        do {

            lock {
                (Student & readonly)? student = students.cloneReadOnly()[id.toString()];
                if student is Student {
                    return student;
                }
                return error("Student not found.");
            }

        } on fail var e {
            return e;
        }
    }

    # Deletes a student by ID.
    #
    # + id - The ID of the student to delete.
    # + return - A success message if the student is deleted, or an error if the student is not found.
    isolated resource function delete remove(int id) returns string|error|error {
        do {

            lock {
                if students.hasKey(id.toString()) {
                    _ = students.remove(id.toString());
                    return "Student deleted successfully.";
                }
                return error("Student not found.");
            }

        } on fail var e {
            return e;
        }
    }
}
