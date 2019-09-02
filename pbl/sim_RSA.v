`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/01/10 17:32:42
// Design Name: 
// Module Name: sim_RSA
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

module sim_RSA(

    );
 
    reg clk,rstn;
    reg [31:0] pow;
    reg [255:0] in_data;
    reg[255:0] modulos;
    reg[31:0] mp;
    wire [255:0] finalans;
    wire Master_end;
    
    RSA_PBL RSA (
        .clk(clk),
        .rstn(rstn),
        .pow(pow),
        .indata(in_data),
        .modulos(modulos),
        .mp(mp),
        .outdata(finalans),
        .end_flag(Master_end)
    );
    

           
    always #(1) clk = ~clk;
           
    initial begin
        clk = 1'b1;
        rstn = 1'b1;
         
        //in_data = 256'd3272068392;    
        pow = 32'd3272068392;  
        in_data  = 256'h1d33e562bfffffe98b58107fffffff931152ffffffffff0084ffffffffffff09;//2
        //in_3  = 256'h193c25d2ffffffdd73e9f1ffffffff58696bfffffffffe76f3fffffffffffe84;
        modulos  = 256'h2523648240000001ba344d80000000086121000000000013a700000000000013;
        mp =  32'hd79435e5;
               
        #5;
        rstn = 1'b0;
        #10 
        rstn = 1'b1;
        #(1000);
        $finish;
    end    
endmodule
