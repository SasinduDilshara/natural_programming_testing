import ballerina/io;

function printEmployeeDataByDepartmentNPGenerated(Employee[] employees) {
    map<Employee[]> departmentGroups = {};

    foreach Employee employee in employees {
        string departmentName = employee.department.name;
        if !departmentGroups.hasKey(key = departmentName) {
            departmentGroups[departmentName] = [];
        }
        Employee[] existingEmployees = departmentGroups.get(key = departmentName);
        departmentGroups[departmentName] = [...existingEmployees, employee];
    }

    string[] departmentNames = departmentGroups.keys();
    foreach string departmentName in departmentNames {
        io:println("Department: " + departmentName);
        io:println("=================================================");

        Employee[] departmentEmployees = departmentGroups.get(key = departmentName);
        foreach Employee employee in departmentEmployees {
            string employeeDetails = string:concat(
                    "Employee ID: ", employee.id.toString(),
                    ", Name: ", employee.name,
                    ", Salary: ", employee.salary.toString()
            );
            io:println(employeeDetails);
        }
        io:println("");
    }
}

