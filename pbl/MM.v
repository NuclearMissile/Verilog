`timescale 1ns/1ps

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
                        STATE <= 5'd0;
                        endflag1 <= 0;
                        result1 <= 256'b0;
                        multiplicand1 <= multiplicand;
                        multiplier_part <= multiplicand[31:0];
                    end
                end
            endcase
        end
    end
endmodule // 