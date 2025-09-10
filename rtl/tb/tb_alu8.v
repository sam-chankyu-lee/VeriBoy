`timescale 1ns / 1ns

module tb_alu8;
    reg clk;
    reg [7:0] regA, regB;
    reg [3:0] opcode;
    reg carryIn;

    wire [7:0] res;
    wire [7:0] flagsOut;

    localparam OP_ADD = 4'b0000;
    localparam OP_ADC = 4'b0001;
    localparam OP_SUB = 4'b0010;
    localparam OP_SBC = 4'b0011;
    localparam OP_CP = 4'b0100;
    localparam OP_AND = 4'b0101;
    localparam OP_OR = 4'b0110;
    localparam OP_XOR = 4'b0111;
    localparam OP_RL = 4'b1000;
    localparam OP_RR = 4'b1001;
    localparam OP_BSL = 4'b1010;
    localparam OP_BSR = 4'b1011;
    localparam OP_SWAP = 4'b1100;

    always #1 clk = ~clk;
    reg [7:0] temp;

    alu8 dut(
        .regA(regA), 
        .regB(regB),
        .opcode(opcode),
        .carryIn(carryIn),

        .res(res),
        .flagsOut(flagsOut)
    );

    // sdlfgjl;sfdg
    initial begin
        init();
        $display("addition");
        for (int i=0; i<100; i=i+1) begin
            testAddition();
        end
        $display("\nsubtraction");
        for (int i=0; i<100; i=i+1) begin
            testSubtraction();
        end
        $finish;
    end
    // sdfglhjsdfkjhgf

    function void init();
        clk <= 0;
        regA <= 0;
        regB <= 0;
        opcode <= 0;
        carryIn <= 0;
        #6;
    endfunction

    function integer rng();
        return $urandom() % 256;
    endfunction

    //addition and subtraction with and without carry functional
    function void testAddition();
        regA <= rng()[7:0];
        regB <= rng()[7:0];
        opcode <= OP_ADC;
        carryIn <= 1;
        #2
        
        temp <= regA+regB+1;
        if (res != temp) begin 
            $display("Reg A: %0d | Reg B: %0d | A+B: %0d | Hardware Result: %0d", regA, regB, temp, res);
            $display("addition value is incorrect");
        end

        regA <= 0;
        regB <= 0;
        opcode <= 0;
        carryIn <= 0;
        #2;
    endfunction

    function void testSubtraction();
        regA <= rng()[7:0];
        regB <= rng()[7:0];
        opcode <= OP_SBC;
        carryIn <= 1;
        #2

        temp <= regA-regB-1;
        if (res != temp) begin
            $display("Reg A: %0d | Reg B: %0d | A-B: %0d | Hardware Result: %0d", regA, regB, temp, res);
            $display("subtraction value is incorrect");
        end

        regA <= 0;
        regB <= 0;
        opcode <= 0;
        carryIn <= 0;
        #2;
    endfunction

endmodule
