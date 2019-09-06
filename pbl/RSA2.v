`timescale 1ns / 1ps
   
module RSA2(
        input clk, rstn,
        input[255:0] indata, modulos, 
        input[31:0] pow, mp,
        output[255:0] outdata, output end_flag
    );
    reg[5:0] state, state1; 
    reg en; 
    reg[255:0] answer;
    reg flag;
    reg pow_bit;
    
    assign end_flag = flag;
    wire[5:0] index = 6'd31 - state1;
    wire slave_endflag;

    MM2 Slave(.clk(clk),.en(en),.modulos(modulos),
        .mp(mp),.indata(indata),.multiplicand(answer),
        .endflag(slave_endflag),.answer(outdata),.pow_bit(pow_bit));
    
    always@(posedge clk or negedge rstn) begin
        if(!rstn) begin 
            state <= 6'd0;
            state1 <= 6'd0;
            en <= 0;
            answer <= 256'h212ba4f27ffffff5a2c62effffffffcdb939ffffffffff8a15ffffffffffff8e; //?????l?????
            pow_bit <= pow[index]; 
            flag <= 0;   
        end else begin 
            case (state)
                6'd0: begin
                    state <= 6'd1;
                    en <= 1;
                end 
                6'd32: begin
                    en <= 1;
                    if (slave_endflag) begin
                        answer <= outdata;
                        flag <= 1;
                    end else begin
                        ;
                    end
                end
                default: begin
                    en <= 1;
                    state1 <= state;
                    if (slave_endflag) begin
                        answer <= outdata;
                        en <= 0;
                        pow_bit <= pow[index];
                        state <= state + 6'd1;
                    end else begin
                        ;
                    end
                end
            endcase  
        end   
    end
endmodule

module MM2(input clk, en, pow_bit, 
    input[255:0] modulos, indata, multiplicand, 
    input[31:0] mp, output endflag, output[255:0] answer
);
    reg[4:0] state; 
    reg endflag1;
    reg[255:0] answer1;
    reg[31:0] multiplier_part;
    reg[255:0] multiplicand1;
    // combinational logic
    wire[287:0] data1 = multiplicand1 * multiplier_part;//biA
    wire[31:0] data2 = answer1 + data1;
    wire[31:0] data3 = data2[31:0];
    wire[31:0] data4 = data3 * mp;  //qi
    wire[287:0] data5 = data4 * modulos; //qiM
    wire[287:0] data6 = answer + data5 + data1;
    wire[255:0] answer_next = data6[287:32];
    // wire[9:0] index = 31 + 32 * state;
    // wire[9:0] index1 = index - 256;

    assign endflag = endflag1;
    assign answer = answer1; 

    // always @(posedge clk) begin
    //     if (!en) begin
    //         state <= 5'd0;
    //         endflag1 <= 0;
    //         answer1 <= 256'b0;
    //         multiplicand1 <= multiplicand;
    //         multiplier_part <= multiplicand[31:0];
    //     end else begin
    //         case (state)
    //             5'd7: begin
    //                 if (pow_bit == 1) begin
    //                     state <= state + 1;
    //                     answer1 <= answer_next;
    //                 end else if (pow_bit == 0) begin
    //                     state <= 5'd17;
    //                     endflag1 <= 1;
    //                     answer1 <= answer_next;
    //                 end
    //             end 
    //             5'd8: begin
    //                 multiplicand1 <= answer1;
    //                 answer1 <= 256'b0;
    //                 multiplier_part <= indata[31:0];
    //                 state <= state + 1;
    //             end
    //             5'd16: begin
    //                 answer1 <= answer_next;
    //                 endflag1 <= 1;
    //                 state <= state + 1;
    //             end
    //             5'd17: begin
    //                 endflag1 <= 0;
    //             end
    //             default: begin
    //                 state <= state + 1;
    //             end
    //         endcase
    //     end
    // end  
    
    // always @(state) begin
    //     if (state >= 5'd0 && state <= 5'd6 && en) begin
    //         multiplier_part <= multiplicand[index-:6'd32];
    //         answer1 <= answer_next; 
    //     end else if (state >= 5'd9 && state <= 5'd15 && en) begin
    //         multiplier_part <= indata[index1-:6'd32];
    //         answer1 <= answer_next;
    //     end 
    // end

    always @(posedge clk) begin
        if (!en) begin
            state <= 5'd0;
            endflag1 <= 0;
            answer1 <= 256'b0;
            multiplicand1 <= multiplicand;
            multiplier_part <= multiplicand[31:0];
        end else begin
            case (state)
                5'd0: begin 
                    multiplier_part <= multiplicand[63:32];
                    answer1 <= answer_next; 
                    state <= state+1;
                end 
                5'd1:begin
                    multiplier_part <= multiplicand[95:64];
                    answer1 <= answer_next; 
                    state <= state+1;
                end
                5'd2: begin 
                    multiplier_part <= multiplicand[127:96];
                    answer1 <= answer_next; 
                    state <= state+1;
                end 
                5'd3:begin
                    multiplier_part <= multiplicand[159:128];
                    answer1 <= answer_next; 
                    state <= state+1;
                end
                5'd4: begin 
                    multiplier_part <= multiplicand[191:160];
                    answer1 <= answer_next; 
                    state <= state+1;
                end 
                5'd5:begin
                    multiplier_part <= multiplicand[223:192];
                    answer1 <= answer_next; 
                    state <= state+1;
                end
                5'd6: begin
                    multiplier_part <= multiplicand[255:224];
                    answer1 <= answer_next; 
                    state <= state+1; 
                end 
                5'd7:begin
                    if (pow_bit) begin 
                       state <= state + 1;
                       answer1 <= answer_next;
                    end else begin
                       state <= 5'd17; 
                       answer1 <= answer_next;
                       endflag1 <= 1;   
                    end 
                end
                5'd8: begin 
                    multiplicand1 <= answer1;
                    answer1 <= 256'b0;
                    multiplier_part <= indata[31:0];
                    state <= state + 1;
                end 
                5'd9:begin
                    multiplier_part <= indata[63:32];
                    answer1 <= answer_next;
                    state <= state + 1; 
                end
                5'd10: begin 
                    multiplier_part <= indata[95:64];
                    answer1 <= answer_next;
                    state <= state + 1; 
                end 
                5'd11:begin
                    multiplier_part <= indata[127:96];
                    answer1 <= answer_next;
                    state <= state + 1;                    
                end
                5'd12: begin
                    multiplier_part <= indata[159:128];
                    answer1 <= answer_next;
                    state <= state + 1;  
                end 
                5'd13:begin
                    multiplier_part <= indata[191:160];
                    answer1 <= answer_next;
                    state <= state + 1; 
                end
                5'd14: begin
                    multiplier_part <= indata[223:192];
                    answer1 <= answer_next;
                    state <= state + 1;  
                end 
                5'd15:begin
                    multiplier_part <= indata[255:224];
                    answer1 <= answer_next;
                    state <= state + 1; 
                end
                5'd16: begin
                    answer1 <= answer_next;
                    state <= state + 1;   
                    endflag1 <= 1; 
                end 
                5'd17:begin
                    endflag1 <= 0;
                end
                default: begin
                    ;
                end
            endcase
        end
    end   
endmodule    
    