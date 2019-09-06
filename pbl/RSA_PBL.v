`timescale 1ns / 1ps

module RSA_PBL(
    input clk,
    input rstn,
    input [255:0] indata, //�Í���
    input [31:0] pow, //�閧��d
    input [255:0] modulos,
    input [31:0] mp, //M'(N'�̉���32bit)
    output [255:0] outdata,//��������
    output end_flag
    );
  reg[5:0] state; //
  reg en; //start flag
  reg[255:0] answer;
  reg flag;
  wire Slave_endflag;
  reg pow_bit;
  assign end_flag = flag;
  //Slave�ɐڑ�
  Slave Slave1(.clk(clk),.en(en),.modulos(modulos),.mp(mp),.indata(indata),
               .multiplicand(answer),
               .endflag(Slave_endflag),.answer(outdata),.pow_bit(pow_bit));
 always@(posedge clk) begin
     if(rstn == 0) begin //inilltial set
         state <= 6'd0;
         en <= 0;
         answer <= 256'h212ba4f27ffffff5a2c62effffffffcdb939ffffffffff8a15ffffffffffff8e; //�����l�ԈႦ��
         pow_bit <= pow[31]; 
         flag <= 0;   
     end else begin //rstn == 1
            if (state == 6'd0) begin
                 state<=6'd1;//change next state
                 en <= 1;  //Start Signal of Slave   
            end else if (state == 6'd1) begin
                 if(Slave_endflag == 1) begin  //finish Slave processing
                       answer <= outdata;
                       en <= 0;
                       state <= 6'd2;
                       pow_bit <= pow[30];
                 end
            end else if (state == 6'd2) begin
                 en <= 1;   
                 if(Slave_endflag == 1) begin 
                       answer <= outdata;
                       en <= 0;
                       state <= 6'd3;
                       pow_bit <= pow[29];
                 end      
            end else if (state == 6'd3) begin
                 en <= 1;
                 if(Slave_endflag == 1) begin 
                       answer <= outdata;
                       en <= 0;
                       state <= 6'd4;
                       pow_bit <= pow[28];
                 end
            end else if (state == 6'd4) begin
                 en <= 1;
                 if(Slave_endflag == 1) begin 
                       answer <= outdata;
                       en <= 0;
                       state <= 6'd5;
                       pow_bit <= pow[27];
                 end      
            end else if (state == 6'd5) begin
                 en <= 1;
                 if(Slave_endflag == 1) begin 
                       answer <= outdata;
                       en <= 0;
                       state <= 6'd6;
                       pow_bit <= pow[26];
                 end
            end else if (state == 6'd6) begin
                 en <= 1;
                 if(Slave_endflag == 1) begin 
                       answer <= outdata;
                       en <= 0;
                       state <= 6'd7;
                       pow_bit <= pow[25];
                 end
            end else if (state == 6'd7) begin
                 en <= 1;
                 if(Slave_endflag == 1) begin 
                       answer <= outdata;
                       en <= 0;
                       state <= 6'd8;
                       pow_bit <= pow[24];
                 end
             end else if (state == 6'd8) begin
                 en <= 1;
                 if(Slave_endflag == 1) begin 
                       answer <= outdata;
                       en <= 0;
                       state <= 6'd9;
                       pow_bit <= pow[23];
                 end
            end else if (state == 6'd9) begin
                 en <= 1;
                 if(Slave_endflag == 1) begin 
                       answer <= outdata;
                       en <= 0;
                       state <= 6'd10;
                       pow_bit <= pow[22];
                 end
            end else if (state == 6'd10) begin
                 en <= 1;   
                 if(Slave_endflag == 1) begin 
                       answer <= outdata;
                       en <= 0;
                       state <= 6'd11;
                       pow_bit <= pow[21];
                 end      
            end else if (state == 6'd11) begin
                 en <= 1;
                 if(Slave_endflag == 1) begin 
                       answer <= outdata;
                       en <= 0;
                       state <= 6'd12;
                       pow_bit <= pow[20];
                 end
            end else if (state == 6'd12) begin
                 en <= 1;
                 if(Slave_endflag == 1) begin 
                       answer <= outdata;
                       en <= 0;
                       state <= 6'd13;
                       pow_bit <= pow[19];
                 end      
            end else if (state == 6'd13) begin
                 en <= 1;
                 if(Slave_endflag == 1) begin 
                       answer <= outdata;
                       en <= 0;
                       state <= 6'd14;
                       pow_bit <= pow[18];
                 end
            end else if (state == 6'd14) begin
                 en <= 1;
                 if(Slave_endflag == 1) begin 
                       answer <= outdata;
                       en <= 0;
                       state <= 6'd15;
                       pow_bit <= pow[17];
                 end
            end else if (state == 6'd15) begin
                 en <= 1;
                 if(Slave_endflag == 1) begin 
                       answer <= outdata;
                       en <= 0;
                       state <= 6'd16;
                       pow_bit <= pow[16];
                 end
             end else if (state == 6'd16) begin
                 en <= 1;
                 if(Slave_endflag == 1) begin 
                       answer <= outdata;
                       en <= 0;
                       state <= 6'd17;
                       pow_bit <= pow[15];
                 end
            end else if (state == 6'd17) begin
                 en <= 1;
                 if(Slave_endflag == 1) begin 
                       answer <= outdata;
                       en <= 0;
                       state <= 6'd18;
                       pow_bit <= pow[14];
                 end
             end else if (state == 6'd18) begin
                 en <= 1;   
                 if(Slave_endflag == 1) begin 
                       answer <= outdata;
                       en <= 0;
                       state <= 6'd19;
                       pow_bit <= pow[13];
                 end      
            end else if (state == 6'd19) begin
                 en <= 1;
                 if(Slave_endflag == 1) begin 
                       answer <= outdata;
                       en <= 0;
                       state <= 6'd20;
                       pow_bit <= pow[12];
                 end
            end else if (state == 6'd20) begin
                 en <= 1;
                 if(Slave_endflag == 1) begin 
                       answer <= outdata;
                       en <= 0;
                       state <= 6'd21;
                       pow_bit <= pow[11];
                 end      
            end else if (state == 6'd21) begin
                 en <= 1;
                 if(Slave_endflag == 1) begin 
                       answer <= outdata;
                       en <= 0;
                       state <= 6'd22;
                       pow_bit <= pow[10];
                 end
            end else if (state == 6'd22) begin
                 en <= 1;
                 if(Slave_endflag == 1) begin 
                       answer <= outdata;
                       en <= 0;
                       state <= 6'd23;
                       pow_bit <= pow[9];
                 end
            end else if (state == 6'd23) begin
                 en <= 1;
                 if(Slave_endflag == 1) begin 
                       answer <= outdata;
                       en <= 0;
                       state <= 6'd24;
                       pow_bit <= pow[8];
                 end
             end else if (state == 6'd24) begin
                 en <= 1;
                 if(Slave_endflag == 1) begin 
                       answer <= outdata;
                       en <= 0;
                       state <= 6'd25;
                       pow_bit <= pow[7];
                 end
            end else if (state == 6'd25) begin
                 en <= 1;
                 if(Slave_endflag == 1) begin 
                       answer <= outdata;
                       en <= 0;
                       state <= 6'd26;
                       pow_bit <= pow[6];
                 end
            end else if (state == 6'd26) begin
                 en <= 1;   
                 if(Slave_endflag == 1) begin 
                       answer <= outdata;
                       en <= 0;
                       state <= 6'd27;
                       pow_bit <= pow[5];
                 end      
            end else if (state == 6'd27) begin
                 en <= 1;
                 if(Slave_endflag == 1) begin 
                       answer <= outdata;
                       en <= 0;
                       state <= 6'd28;
                       pow_bit <= pow[4];
                 end
            end else if (state == 6'd28) begin
                 en <= 1;
                 if(Slave_endflag == 1) begin 
                       answer <= outdata;
                       en <= 0;
                       state <= 6'd29;
                       pow_bit <= pow[3];
                 end      
            end else if (state == 6'd29) begin
                 en <= 1;
                 if(Slave_endflag == 1) begin 
                       answer <= outdata;
                       en <= 0;
                       state <= 6'd30;
                       pow_bit <= pow[2];
                 end
            end else if (state == 6'd30) begin
                 en <= 1;
                 if(Slave_endflag == 1) begin 
                       answer <= outdata;
                       en <= 0;
                       state <= 6'd31;
                       pow_bit <= pow[1];
                 end
            end else if (state == 6'd31) begin
                 en <= 1;
                 if(Slave_endflag == 1) begin 
                       answer <= outdata;
                       en <= 0;
                       pow_bit <= pow[0];
                       state <= 6'd32;
                 end
            end  else if (state == 6'd32) begin
                 en <= 1;
                 if(Slave_endflag == 1) begin 
                      answer <= outdata;
                      flag <= 1;
                 end
            end              
     end                      
 end
endmodule

module Slave(input clk,input en,input[255:0] modulos,input[31:0] mp,
                    input[255:0] indata,input pow_bit,
                    input[255:0] multiplicand,
                    output endflag,output[255:0] answer);
        reg [4:0] STAT; 
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
           always@(posedge clk)begin
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
                       endflag_kari <= 1;   
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
                    endflag_kari <= 1;                  
                 end if (STAT == 5'd17) begin
                    endflag_kari <= 0;            
                 end     
              end
           end
    endmodule
    



