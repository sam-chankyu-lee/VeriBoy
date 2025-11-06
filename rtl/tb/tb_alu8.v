`timescale 1ns / 1ns

module tb_alu8;
    reg clk;
    reg [7:0] regA, regB;
    reg [4:0] opcode;
    reg [7:0] flagsIn;

    wire [7:0] res;
    wire [7:0] flagsOut;

    localparam OP_ADD  = 5'b00000;
    localparam OP_ADC  = 5'b00001;
    localparam OP_SUB  = 5'b00010;
    localparam OP_SBC  = 5'b00011;
    localparam OP_CP   = 5'b00100;
    localparam OP_AND  = 5'b00101;
    localparam OP_OR   = 5'b00110;
    localparam OP_XOR  = 5'b00111;
    localparam OP_RL   = 5'b01000;
    localparam OP_RR   = 5'b01001;
    localparam OP_RLA  = 5'b01010;
    localparam OP_RRA  = 5'b01011;
    localparam OP_RLC  = 5'b01100;
    localparam OP_RRC  = 5'b01101;
    localparam OP_RLCA = 5'b01110;
    localparam OP_RRCA = 5'b01111;
    localparam OP_SLA  = 5'b10000;
    localparam OP_SRA  = 5'b10001;
    localparam OP_SRL  = 5'b10010;
    localparam OP_SWAP = 5'b10011;
    localparam OP_BIT  = 5'b10100;
    localparam OP_RES  = 5'b10101;
    localparam OP_SET  = 5'b10110;

    always #1 clk = ~clk;
    reg [7:0] temp;

    alu8 dut(
        .regA(regA), 
        .regB(regB),
        .opcode(opcode),
        .flagsIn(flagsIn),

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
        $display("\nAND");
        for (int i=0; i<100; i=i+1) begin
            testAnd();
        end
        $display("\nOR");
        for (int i=0; i<100; i=i+1) begin
            testOr();
        end
        $display("\nXOR");
        for (int i=0; i<100; i=i+1) begin
            testXor();
        end
        $display("\nRL");
        for (int i=0; i<100; i=i+1) begin
            testRL();
        end
        $display("\nRR");
        for (int i=0; i<100; i=i+1) begin
            testRR();
        end
        $display("\nRLC");
        for (int i=0; i<100; i=i+1) begin
            testRLC();
        end
        $display("\nRRC");
        for (int i=0; i<100; i=i+1) begin
            testRRC();
        end
        $display("\nSLA");
        for (int i=0; i<100; i=i+1) begin
            testSLA();
        end
        $display("\nSRA");
        for (int i=0; i<100; i=i+1) begin
            testSRA();
        end
        $display("\nSRL");
        for (int i=0; i<100; i=i+1) begin
            testSRL();
        end
        $display("\nSWAP");
        for (int i=0; i<100; i=i+1) begin
            testSwap();
        end
        $display("\nBIT");
        for (int i=0; i<100; i=i+1) begin
            testBit();
        end
        $display("\nRES");
        for (int i=0; i<100; i=i+1) begin
            testRes();
        end
        $display("\nSET");
        for (int i=0; i<100; i=i+1) begin
            testSet();
        end
        $finish;
    end
    // sdfglhjsdfkjhgf

    function void init();
        clk <= 0;
        regA <= 0;
        regB <= 0;
        opcode <= 0;
        flagsIn <= 0;
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
        flagsIn[4] <= 1;
        #2
        
        temp <= regA+regB+1;
        if (res != temp) begin 
            $display("Reg A: %0d | Reg B: %0d | A+B: %0d | Hardware Result: %0d", regA, regB, temp, res);
            $display("addition value is incorrect");
        end

        regA <= 0;
        regB <= 0;
        opcode <= 0;
        flagsIn <= 0;
        #2;
    endfunction

    function void testSubtraction();
        regA <= rng()[7:0];
        regB <= rng()[7:0];
        opcode <= OP_SBC;
        flagsIn[4] <= 1;
        #2;

        temp <= regA-regB-1;
        if (res != temp) begin
            $display("Reg A: %0d | Reg B: %0d | A-B: %0d | Hardware Result: %0d", regA, regB, temp, res);
            $display("subtraction value is incorrect");
        end

        regA <= 0;
        regB <= 0;
        opcode <= 0;
        flagsIn <= 0;
        #2;
    endfunction

    function void testAnd();
        regA <= rng()[7:0];
        regB <= rng()[7:0];
        opcode <= OP_AND;
        #2;

        temp <= regA & regB;
        if (res != temp) begin
            $display("Reg A: %0d | Reg B: %0d | A-B: %0d | Hardware Result: %0d", regA, regB, temp, res);
            $display("AND value is incorrect");
        end

        regA <= 0;
        regB <= 0;
        opcode <= 0;
        flagsIn <= 0;
        #2;
    endfunction

    function void testOr();
        regA <= rng()[7:0];
        regB <= rng()[7:0];
        opcode <= OP_OR;
        #2;

        temp <= regA | regB;
        if (res != temp) begin
            $display("Reg A: %0d | Reg B: %0d | A-B: %0d | Hardware Result: %0d", regA, regB, temp, res);
            $display("OR value is incorrect");
        end

        regA <= 0;
        regB <= 0;
        opcode <= 0;
        flagsIn <= 0;
        #2;
    endfunction

    function void testXor();
        regA <= rng()[7:0];
        regB <= rng()[7:0];
        opcode <= OP_XOR;
        #2;

        temp <= regA ^ regB;
        if (res != temp) begin
            $display("Reg A: %0d | Reg B: %0d | A-B: %0d | Hardware Result: %0d", regA, regB, temp, res);
            $display("XOR value is incorrect");
        end

        regA <= 0;
        regB <= 0;
        opcode <= 0;
        flagsIn <= 0;
        #2;
    endfunction

    function void testRL();
        regA <= rng()[7:0];
        flagsIn[4] <= rng()[0];
        opcode <= OP_RL;
        #2;

        temp <= {regA[6:0], flagsIn[4]};
        if (res != temp) begin
            $display("Reg A: %8b | Carry: %0b | A<<1: %8b | Hardware Result: %8b", regA, flagsIn, temp, res);
            $display("RL value is incorrect");
        end

        regA <= 0;
        opcode <= 0;
        flagsIn <= 0;
        #2;
    endfunction

    function void testRR();
        regA <= rng()[7:0];
        flagsIn[4] <= rng()[0];
        opcode <= OP_RR;
        #2;

        temp <= {flagsIn[4], regA[7:1]};
        if (res != temp) begin
            $display("Reg A: %8b | Carry: %0b | A>>1: %8b | Hardware Result: %8b", regA, flagsIn, temp, res);
            $display("RR value is incorrect");
        end

        regA <= 0;
        opcode <= 0;
        flagsIn <= 0;
        #2;
    endfunction

    function void testRLC();
        regA <= rng()[7:0];
        flagsIn[4] <= rng()[0];
        opcode <= OP_RLC;
        #2;

        temp <= {regA[6:0], regA[7]};
        if (res != temp) begin
            $display("Reg A: %8b | A<<1: %8b | Hardware Result: %8b", regA, temp, res);
            $display("RLC value is incorrect");
        end

        regA <= 0;
        opcode <= 0;
        flagsIn <= 0;
        #2;
    endfunction

    function void testRRC();
        regA <= rng()[7:0];
        flagsIn[4] <= rng()[0];
        opcode <= OP_RRC;
        #2;

        temp <= {regA[0], regA[7:1]};
        if (res != temp) begin
            $display("Reg A: %8b | A>>1: %8b | Hardware Result: %8b", regA, temp, res);
            $display("RRC value is incorrect");
        end

        regA <= 0;
        opcode <= 0;
        flagsIn <= 0;
        #2;
    endfunction

    function void testSLA();
        regA <= rng()[7:0];
        flagsIn[4] <= rng()[0];
        opcode <= OP_SLA;
        #2;

        temp <= {regA[6:0], 1'b0};
        if (res != temp) begin
            $display("Reg A: %8b | A<<1: %8b | Hardware Result: %8b", regA, temp, res);
            $display("SLA value is incorrect");
        end

        regA <= 0;
        opcode <= 0;
        flagsIn <= 0;
        #2;
    endfunction

    function void testSRA();
        regA <= rng()[7:0];
        flagsIn[4] <= rng()[0];
        opcode <= OP_SRA;
        #2;

        temp <= {regA[7], regA[7:1]};
        if (res != temp) begin
            $display("Reg A: %8b | A<<1: %8b | Hardware Result: %8b", regA, temp, res);
            $display("SRA value is incorrect");
        end

        regA <= 0;
        opcode <= 0;
        flagsIn <= 0;
        #2;
    endfunction

    function void testSRL();
        regA <= rng()[7:0];
        flagsIn[4] <= rng()[0];
        opcode <= OP_SRL;
        #2;

        temp <= {1'b0, regA[7:1]};
        if (res != temp) begin
            $display("Reg A: %8b | A<<1: %8b | Hardware Result: %8b", regA, temp, res);
            $display("SRL value is incorrect");
        end

        regA <= 0;
        opcode <= 0;
        flagsIn <= 0;
        #2;
    endfunction

    function void testSwap();
        regA <= rng()[7:0];
        flagsIn[4] <= rng()[0];
        opcode <= OP_SWAP;
        #2;

        temp <= {regA[3:0], regA[7:4]};
        if (res != temp) begin
            $display("Reg A: %8b | A swap: %8b | Hardware Result: %8b", regA, temp, res);
            $display("Swap value is incorrect");
        end

        regA <= 0;
        opcode <= 0;
        flagsIn <= 0;
        #2;
    endfunction

    function void testBit();
        regA <= rng()[7:0];
        regB <= {5'b00000, rng()[2:0]};
        flagsIn[4] <= rng()[0];
        opcode <= OP_BIT;
        #2;

        temp <= {7'b0000000, !regA[regB[2:0]]};
        if (flagsOut[7] != temp[0]) begin
            $display("Reg A: %8b | Bit Value: %d | Bit Zero?: %1b | Hardware Result: %1b", regA, regB, temp[0], flagsOut[7]);
            $display("Bit value is incorrect");
        end

        regA <= 0;
        opcode <= 0;
        flagsIn <= 0;
        #2;
    endfunction

    function void testRes();
        regA <= rng()[7:0];
        regB <= {5'b00000, rng()[2:0]};
        opcode <= OP_RES;
        #2;

        temp = regA;
        temp[regB[2:0]] <= 0;
        if (res != temp) begin
            $display("Reg A: %8b | Bit Value: %d | Expected Value: %8b | Hardware Result: %8b", regA, regB, temp, res);
            $display("Bit value is incorrect");
        end

        regA <= 0;
        opcode <= 0;
        flagsIn <= 0;
        #2;
    endfunction

    function void testSet();
        regA <= rng()[7:0];
        regB <= {5'b00000, rng()[2:0]};
        opcode <= OP_SET;
        #2;

        temp = regA;
        temp[regB[2:0]] <= 1;
        $display("Reg A: %8b | Bit Value: %d | Expected Value: %8b | Hardware Result: %8b", regA, regB, temp, res);
        if (res != temp) begin
            $display("Bit value is incorrect");
        end

        regA <= 0;
        opcode <= 0;
        flagsIn <= 0;
        #2;
    endfunction
endmodule
