`timescale 1ns/1ps

module simCounter4bit();
    reg reset, cin, clk;
    wire [3:0]q;
    wire cout;

    counter uut(.q(q), 
                .cout(cout),
                .reset(reset),
                .cin(cin),
                .clk(clk));
    initial 
        begin
            reset = 0;
            cin = 0;
            clk = 0;
            #100 reset=1; #100 cin=1;
            #100 reset=0;
            #(100*20) cin=0;
            #100 cin=1;
            #(100*5) $stop;
        end
    always #50 clk=~clk;
endmodule // 