`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/05/11 10:00:03
// Design Name: 
// Module Name: sim_MM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module sim_MM();

    reg [255:0] x;
    reg [255:0] y;
    wire [255:0] z;
    reg [255:0] p;
    reg [31:0] pp;
    reg clk;
    reg rstn;
    wire end_flag;
    
   MM2 uut(
        .indata(x),
        .multiplicand(y),
        .answer(z),
        .modulos(p),
        .mp(pp),
        .clk(clk),
        .en(rstn),
        .endflag(end_flag),
        .pow_bit(1'b1)
    );
    

    
    parameter CLOCK_TERM = 10;
    
        always #(CLOCK_TERM)begin
            clk = ~clk;
        end
/*    
        initial begin
            // Initialize Inputs

            x = 256'd2;
            y = 256'd3;
            p = 256'd16798108731015832284940804142231733909889187121439069848933715426072753864723;
            pp = 32'hD79435E5; //itann suru-
            clk = 0;
            rstn = 0;
    
            // Wait 100 ns for global reset to finish
            #100;
            rstn = 1;
            #110;

             
        end
    
endmodule
*/

initial begin
     x = 256'd2;
     y = 256'd3;
     p = 256'd16798108731015832284940804142231733909889187121439069848933715426072753864723;
     pp = 32'hD79435E5; //itann suru-
     clk = 0;
     rstn = 0;
          
     // Wait 100 ns for global reset to finish
     #100;
     rstn = 1;
     #600;
           
     $finish;
    end
endmodule

