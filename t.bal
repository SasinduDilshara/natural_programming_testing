// const int COUNT = 25;

// type Employee record {
//     string name;
//     int id;
//     decimal salary;
//     Department department;
// };

// type Department record {
//     string name;
//     int[] employees;
// };

// public function main() returns error? {
//     int employees = 2;
    
// }

// ((SimpleNameReferenceNode)(((BinaryExpressionNode)(((ReturnStatementNode)(((FunctionBodyBlockNode)(((FunctionDefinitionNode)(modulePartNode.members().get(0))).functionBody())).statements().get(0))).expression().get())).lhsExpr()))

import ballerina/io;

configurable float discount = 0.1;

function calculateThePrice(float[] prices) returns float = @code {
    prompt: string `Calculate total price after discount`
} external;

public function main2() {
    float[] cart = [100.0, 200.0, 300.0];
    float total = calculateThePrice(cart);
    io:println("Total after discount: " + total.toString());
}
