`timescale 1ns/1ps

module REDC(
    input wire clk;
    input wire rstn; // negedge to reset
    input reg [255:0] indata;
    input reg [31:0] pow; // private key d
    input reg [255:0] modules; // M
    input reg [31:0] mp; // M', last 32bits of N
    output reg [255:0] outdata;
    output wire end_flag;
);
    always @() begin
        
    end
endmodule // 