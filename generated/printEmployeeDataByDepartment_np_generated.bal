import ballerina/io;

function printEmployeeDataByDepartmentNPGenerated(Employee[] employees) {
    map<Employee[]> departmentGroups = {};

    foreach Employee currentEmployee in employees {
        string departmentName = currentEmployee.department.name;
        if !departmentGroups.hasKey(key = departmentName) {
            departmentGroups[departmentName] = [];
        }
        departmentGroups[departmentName].push(currentEmployee);
    }

    string[] departmentNames = departmentGroups.keys();
    foreach string departmentName in departmentNames {
        io:println("Department: ", departmentName);
        io:println("=================================================");

        Employee[] departmentEmployees = departmentGroups.get(key = departmentName);
        foreach Employee currentEmployee in departmentEmployees {
            int employeeId = currentEmployee.id;
            string employeeName = currentEmployee.name;
            decimal employeeSalary = currentEmployee.salary;
            io:println("Employee ID: ", employeeId, ", Name: ", employeeName, ", Salary: ", employeeSalary);
        }

        io:println();
    }
}

