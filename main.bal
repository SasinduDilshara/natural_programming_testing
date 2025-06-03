const int COUNT = 25;

type Employee record {
    string name;
    int id;
    decimal salary;
    Department department;
};

type Department record {
    string name;
    int[] employees;
};

public function main() returns error? {
    Employee[] employees = const natural {
        Give me a list of ${COUNT} employees where some employees are in the same department also.
    
        Make sure to reflect real-world data. For example, make sure the data is proportionate to 
        the department sizes and IDs of employees from the same department aren't always contiguous.
    };
    
    printEmployeeDataByDepartment(employees);
}

function printEmployeeDataByDepartment(Employee[] employees) = @code {
    prompt: string `Print the employee data grouped by department, in the following format.
    
    Department: <Department Name>
    =================================================
    Employee ID: <Employee 1 ID>, Name: <Employee 1 Name>, Salary: <Employee 1 Salary>
    ...
    Employee ID: <Employee n ID>, Name: <Employee n Name>, Salary: <Employee n Salary>
    `
} external;
