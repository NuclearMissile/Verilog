`timescale 1ns / 1ps

module RSA(
    input clk, input rstn, input[255:0] indata, input[31:0] pow,
    input[255:0] modulos, input[31:0] mp,
    output[255:0] outdata, output end_flag
);
    reg[5:0] STATE;
    reg en;
    reg[255:0] answer;
    reg flag;
    reg pow_bit;

    assign end_flag = flag;
    wire slave_endflag;
    wire[5:0] index = 31 - STATE;

    parameter S0 = 6'd0, S32 = 6'd32;

    MM Slave(
        .clk(clk), .en(en), .modulos(modulos), .mp(mp), 
        .indata(indata), .multiplicand(answer), 
        .endflag(slave_endflag), 
        .answer(outdata), .pow_bit(pow_bit)
    );

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            STATE <= S0;
            en <= 0;
            answer <= 256'h212ba4f27ffffff5a2c62effffffffcdb939ffffffffff8a15ffffffffffff8e; 
            pow_bit <= pow[31]; 
            flag <= 0;
        end else if (STATE == S32) begin
            en <= 1; 
            if (slave_endflag) begin 
                answer <= outdata;
                flag <= 1;
            end else begin
                ;
            end
        end else if (slave_endflag) begin
            en <= 0;
            STATE <= STATE + 1;
        end else begin 
            ;
        end
    end

    always @(STATE) begin
        en <= 1;
        if (slave_endflag) begin 
            answer <= outdata;
            pow_bit <= pow[index];
        end else begin
            ;
        end
    end
endmodule // RSA

module MM(
    input clk, input en, input[255:0] modulos, input[31:0] mp,
    input[255:0] indata, input pow_bit, input[255:0] multiplicand,
    output endflag, output[255:0] answer 
);
    reg[4:0] STATE;
    reg endflag1;
    reg[255:0] answer1;
    reg[31:0] multiplier_part;
    reg[255:0] multiplicand1;
    // combinational logic 
    wire[287:0] temp1 = multiplicand1 * multiplier_part;
    wire[31:0] temp2 = answer1 + temp1;
    wire[31:0] temp3 = temp2[31:0];
    wire[31:0] temp4 = temp3 * mp;
    wire[287:0] temp5 = temp4 * modulos;
    wire[287:0] temp6 = temp5 + answer + temp1;
    wire[255:0] answer_next = temp6[287:32];

    reg[22:0] index;
    wire[7:0] index1 = index[7:0] - 1;
    wire[7:0] index2 = index[15:8] - 1;
    
    assign endflag = endflag1;
    assign answer = answer1;

    always @(posedge clk) begin
        index <= 5'd32 << STATE;
        if (!en) begin
            STATE <= 5'd0;
            endflag1 <= 0;
            answer1 <= 256'b0;
            multiplicand1 <= multiplicand;
            multiplier_part <= multiplicand[31:0];
        end else begin
            case (STATE)
                5'd7: begin
                    if (pow_bit == 1) begin
                        STATE <= STATE + 1;
                        answer1 <= answer_next;
                    end else begin
                        STATE <= 5'd17;
                        answer1 <= answer_next;
                    end
                end
                5'd8: begin
                    multiplicand1 <= answer1;
                    answer1 <= 256'b0;
                    multiplier_part <= indata[31:0];
                    STATE <= STATE + 1;
                end
                5'd16: begin
                    answer1 <= answer_next;
                    STATE <= STATE + 1;
                end
                5'd17: begin
                    endflag1 <= 1;
                    STATE <= STATE + 1;
                end
                5'd18: begin
                    endflag1 <= 0;
                end
                default: begin
                    if (STATE <= 5'd6) begin
                        multiplier_part <= multiplicand[index1-:31];
                        answer1 <= answer_next;
                        STATE <= STATE + 1;
                    end else if (STATE <= 5'd15) begin
                        multiplier_part <= indata[index2-:31];
                        answer1 <= answer_next;
                        STATE <= STATE + 1;
                    end else begin
                        ;
                    end
                end
            endcase
        end
    end
endmodule // MM