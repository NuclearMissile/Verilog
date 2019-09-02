`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/29 12:57:30
// Design Name: 
// Module Name: Slave_confirm
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

module Slave(input clk,input en,input[255:0] modulos,input[31:0] mp,
                    input[255:0] indata,input pow_bit,
                    input[255:0] multiplicand,
                    output endflag,output[255:0] answer);
        reg [4:0] STAT; 
       // reg endflag;
       // reg[255:0] answer;
        reg endflag_kari;
        reg[255:0] answer1;
        reg[31:0] multiplier_part;
        reg[255:0] multiplicand1;
        wire[287:0] data1 = multiplicand1 * multiplier_part;//biA
        wire[31:0] data2 = answer1 + data1;
        wire[31:0] data3 = data2[31:0];
        wire[31:0] data4 = data3 * mp;  //qi
        wire[287:0] data5 = data4 * modulos; //qiM
        wire[287:0] data6 = answer + data5 + data1;
        wire[255:0] answer_next = data6[287:32];
        assign endflag = endflag_kari;
        assign answer = answer1; 
           always@(posedge clk or posedge en)begin
              if(en == 0)begin //wait start signal from RSA_PBL
                  STAT<=5'd0;        
                  endflag_kari <= 0;
                  answer1 <= 256'b0;
                  multiplicand1 <= multiplicand;
                  multiplier_part <= multiplicand[31:0];
              end else begin  
                 if (STAT == 5'd0) begin
                    multiplier_part <= multiplicand[63:32];
                    answer1 <= answer_next; 
                    STAT <= STAT+1;
                 end if (STAT == 5'd1) begin
                    multiplier_part <= multiplicand[95:64];
                    answer1 <= answer_next; 
                    STAT <= STAT+1;
                 end if (STAT == 5'd2) begin
                    multiplier_part <= multiplicand[127:96];
                    answer1 <= answer_next;
                    STAT <= STAT+1;
                 end if (STAT == 5'd3) begin
                    multiplier_part <= multiplicand[159:128];
                    answer1 <= answer_next;
                    STAT <= STAT+1;
                 end if (STAT == 5'd4) begin
                    multiplier_part <= multiplicand[191:160];
                    answer1 <= answer_next; 
                    STAT <= STAT+1;
                 end if (STAT == 5'd5) begin
                    multiplier_part <= multiplicand[223:192];
                    answer1 <= answer_next; 
                    STAT <= STAT+1;    
                 end if (STAT == 5'd6) begin
                    multiplier_part <= multiplicand[255:224];
                    answer1 <= answer_next; 
                    STAT <= STAT+1;  
                 end if (STAT == 5'd7) begin
                    if (pow_bit == 1) begin 
                       STAT <= STAT+1;
                       answer1 <= answer_next;
                    end else if (pow_bit == 0) begin
                       STAT <= 5'd17; 
                       answer1 <= answer_next;   
                    end 
                 end if (STAT == 5'd8) begin
                    multiplicand1 <= answer1;
                    answer1 <= 256'b0;
                    multiplier_part <= indata[31:0];
                    STAT <= STAT+1;
                 end if (STAT == 5'd9) begin
                    multiplier_part <= indata[63:32];
                    answer1 <= answer_next;
                    STAT <= STAT +1;                     
                 end if (STAT == 5'd10) begin
                    multiplier_part <= indata[95:64];
                    answer1 <= answer_next;
                    STAT <= STAT +1;                     
                 end if (STAT == 5'd11) begin
                    multiplier_part <= indata[127:96];
                    answer1 <= answer_next;
                    STAT <= STAT +1;                     
                 end if (STAT == 5'd12) begin
                    multiplier_part <= indata[159:128];
                    answer1 <= answer_next;
                    STAT <= STAT +1;                     
                 end if (STAT == 5'd13) begin
                    multiplier_part <= indata[191:160];
                    answer1 <= answer_next;
                    STAT <= STAT +1;                     
                 end if (STAT == 5'd14) begin
                    multiplier_part <= indata[223:192];
                    answer1 <= answer_next;
                    STAT <= STAT +1;                     
                 end if (STAT == 5'd15) begin
                    multiplier_part <= indata[255:224];
                    answer1 <= answer_next;
                    STAT <= STAT +1;                     
                 end if (STAT == 5'd16) begin
                    answer1 <= answer_next;
                    STAT <= STAT +1;                     
                 end if (STAT == 5'd17) begin
                    endflag_kari <= 1;
                    STAT <= STAT +1;                   
                 end if (STAT == 5'd18) begin
                    endflag_kari <= 0; 
                 end     
              end
           end
    endmodule

