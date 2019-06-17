`timescale 1ns/1ps

module adder(
    count,
    sum,
    a,
    b,
    cin
);
    input [2:0] a, b;
    input cin;
    output count;
    output [2:0] sum;
    assign {count, sum} = a + b + cin;
endmodule // 

module counter(
    q,cout,reset, cin, clk
);
    parameter N = 4;
    output reg [N:1]q;
    output cout;
    input reset, cin, clk;
    always @(posedge clk) 
    begin
        q <= reset ? 0 : q + cin;
    end
    assign cout = &q && cin;
endmodule // counter