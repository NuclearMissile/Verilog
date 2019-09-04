`timescale 1ns / 1ps

module RSA(
    input clk, input rst, input[255:0] indata, input[31:0] pow,
    input[255:0] modulos, input[31:0] mp,
    output[255:0] outdata, output endflag
);
    reg[5:0] STATE;
    reg en;
    reg[255:0] result;
    reg flag;
    reg pow_bit;
    assign endflag = flag;

    wire slave_endflag;
    wire index = 31 - STATE;

    MM Slave(
        .clk(clk), .enable(en), .modulos(modulos), .mp(mp), .indata(indata),
        .multiplicand(result), .endflag(slave_endflag), 
        .result(outdata), .pow_bit(pow_bit)
    );

    always @(posedge clk) begin
        if (rst == 0) begin
            STATE <= 6'd0;
            en <= 0;
            result <= 256'h212ba4f27ffffff5a2c62effffffffcdb939ffffffffff8a15ffffffffffff8e; //�����l�ԈႦ��
            pow_bit <= pow[31]; 
            flag <= 0;
        end else begin
            case (STATE) begin
                6'd0: begin
                    STATE <= STATE + 1;
                    en <= 1;
                end
                6'd32: begin
                    en <= 1;
                    if (slave_endflag == 1) begin 
                        result <= outdata;
                        flag <= 1;
                    end else begin
                        ;
                    end
                end
                default: begin
                    en <= 1;
                    if (slave_endflag == 1) begin 
                        result <= outdata;
                        en <= 0;
                        pow_bit <= pow[index];
                        STATE <= STATE + 1;
                    end else begin
                        ;
                    end
                end
            end
        end
    end

endmodule // RSA

module MM(
    input clk, input enable, input[255:0] modulos, input[31:0] mp,
    input[255:0] indata, input pow_bit, input[255:0] multiplicand,
    output endflag, output[255:0] result 
);
    reg[4:0] STATE;
    reg endflag1;
    reg[255:0] result1;
    reg[31:0] multiplier_part;
    reg[255:0] multiplicand1;
    // combinational logic 
    wire[287:0] temp1 = multiplicand1 * multiplier_part;
    wire[31:0] temp2 = result1 + temp1;
    wire[31:0] temp3 = temp2[31:0];
    wire[31:0] temp4 = temp3 * mp;
    wire[287:0] temp5 = temp4 * modulos;
    wire[287:0] temp6 = temp5 + result + temp1;
    wire[255:0] result_next = temp6[287:32];

    reg[22:0] index;
    wire[7:0] index1 = index[7:0] - 1;
    wire[7:0] index2 = index[15:8] - 1;
    
    assign endflag = endflag1;
    assign result = result1;

    always @(posedge clk or posedge enable) begin
        index <= 5'd32 << STATE;
        if (enable == 0) begin
            STATE <= 5'd0;
            endflag1 <= 0;
            result1 <= 256'b0;
            multiplicand1 <= multiplicand;
            multiplier_part <= multiplicand[31:0];
        end else begin
            case (STATE)
                5'd7: begin
                    if (pow_bit == 1) begin
                        STATE <= STATE + 1;
                        result1 <= result_next;
                    end else begin
                        STATE <= 5'd17;
                        result1 <= result_next;
                    end
                end
                5'd8: begin
                    multiplicand1 <= result1;
                    result1 <= 256'b0;
                    multiplier_part <= indata[31:0];
                    STATE <= STATE + 1;
                end
                5'd16: begin
                    result1 <= result_next;
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
                        result1 <= result_next;
                        STATE <= STATE + 1;
                    end else if (STATE <= 5'd15) begin
                        multiplier_part <= indata[index2-:31];
                        result1 <= result_next;
                        STATE <= STATE + 1;
                    end else begin
                        ;
                    end
                end
            endcase
        end
    end
endmodule // MM