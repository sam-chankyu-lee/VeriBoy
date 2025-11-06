`timescale 1ns / 1ns

module alu8(
    input [7:0] regA, regB,
    input [4:0] opcode,
    input [7:0] flagsIn,

    output reg [7:0] res,
    output reg [7:0] flagsOut
);

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
    localparam OP_CCF  = 5'b10111;
    localparam OP_SCF  = 5'b11000;
    localparam OP_DAA  = 5'b11001;
    localparam OP_CPL  = 5'b11010;

    reg [4:0] low, high;
    reg [7:0] offsetDAA;
    wire carryInEnable = ((opcode == OP_ADC) || (opcode == OP_SBC)) ? (flagsIn[4]) : 1'b0;

    always @* begin
        // Default (safe) values — assigned in all paths
        res       = 8'b0;
        flagsOut  = 8'b0;
        low       = 5'b0;
        high      = 5'b0;
        offsetDAA = 8'b0;

        case (opcode)
            OP_ADD, OP_ADC: begin
                //set low and high of addition
                low = {1'b0, regA[3:0]} + {1'b0, regB[3:0]} + {4'b0000, carryInEnable};
                high = {1'b0, regA[7:4]} + {1'b0, regB[7:4]} + {4'b0000, low[4]};

                //set addition and carry flag
                {flagsOut[4], res} = {high, low[3:0]}; //this should work

                //set half carry flag
                flagsOut[5] = low[4];

                //set zero flag
                if (res == 0) 
                    flagsOut[7] = 1;

                //set subtraction flag
                flagsOut[6] = 0;
            end

            OP_SUB, OP_SBC: begin
                //set low and high of subtraction
                low = {1'b0, regA[3:0]} - {1'b0, regB[3:0]} - {4'b0000, carryInEnable};
                high = {1'b0, regA[7:4]} - {1'b0, regB[7:4]} - {4'b0000, low[4]};

                //set subtraction and carry flag
                {flagsOut[4], res} = {high, low[3:0]}; //this should work

                //set half carry flag
                flagsOut[5] = low[4];

                //set zero flag
                if (res == 0) 
                    flagsOut[7] = 1;

                //set subtraction flag
                flagsOut[6] = 1;
            end
            
            OP_CP: begin
                //set low and high of subtraction
                low = {1'b0, regA[3:0]} - {1'b0, regB[3:0]} - {4'b0000, carryInEnable};
                high = {1'b0, regA[7:4]} - {1'b0, regB[7:4]} - {4'b0000, low[4]};

                //set carry flag
                flagsOut[4] = high[4];

                //set half carry flag
                flagsOut[5] = low[4];

                //set zero flag
                if ({high[3:0], low[3:0]} == 0)
                    flagsOut[7] = 1;

                //set subtraction flag
                flagsOut[6] = 1;
            end
            
            OP_AND: begin
                //set res AND
                res = regA & regB;

                //set carry flag
                flagsOut[4] = 0;
                
                //set half carry flag
                flagsOut[5] = 1;

                //set zero flag
                if (res == 0) 
                    flagsOut[7] = 1;

                //set subtraction flag
                flagsOut[6] = 0;
            end
            
            OP_OR: begin
                //set res OR
                res = regA | regB;

                //set carry flag
                flagsOut[4] = 0;
                
                //set half carry flag
                flagsOut[5] = 0;

                //set zero flag
                if (res == 0) 
                    flagsOut[7] = 1;

                //set subtraction flag
                flagsOut[6] = 0;
            end
            
            OP_XOR: begin
                //set res XOR
                res = regA ^ regB;

                //set carry flag
                flagsOut[4] = 0;
                
                //set half carry flag
                flagsOut[5] = 0;

                //set zero flag
                if (res == 0) 
                    flagsOut[7] = 1;

                //set subtraction flag
                flagsOut[6] = 0;
            end
            
            OP_RL, OP_RLA: begin
                //set res to left shift, also set carry
                {flagsOut[4], res} = {regA, flagsIn[4]};

                //set half carry flag
                flagsOut[5] = 0;

                //set zero flag
                flagsOut[7] = (res == 0 && opcode == OP_RL) ? 1'b1 : 1'b0;

                //set subtraction flag
                flagsOut[6] = 0;
            end

            OP_RR, OP_RRA: begin 
                //set res to right shift, also set carry
                {res, flagsOut[4]} = {flagsIn[4], regA};

                //set half carry flag
                flagsOut[5] = 0;

                //set zero flag
                flagsOut[7] = (res == 0 && opcode == OP_RR) ? 1'b1 : 1'b0;

                //set subtraction flag
                flagsOut[6] = 0;
            end

            OP_RLC, OP_RLCA: begin
                //set res to left shift, also set carry
                {flagsOut[4], res} = {regA, regA[7]};

                //set half carry flag
                flagsOut[5] = 0;

                //set zero flag
                flagsOut[7] = (res == 0 && opcode == OP_RLC) ? 1'b1 : 1'b0;

                //set subtraction flag
                flagsOut[6] = 0;
            end

            OP_RRC, OP_RRCA: begin 
                //set res to right shift, also set carry
                {res, flagsOut[4]} = {regA[0], regA};

                //set half carry flag
                flagsOut[5] = 0;

                //set zero flag
                flagsOut[7] = (res == 0 && opcode == OP_RRC) ? 1'b1 : 1'b0;

                //set subtraction flag
                flagsOut[6] = 0;
            end

            OP_SLA: begin
                //set res to left shift, also set carry
                {flagsOut[4], res} = regA << 1;

                //set half carry flag
                flagsOut[5] = 0;

                //set zero flag
                flagsOut[7] = (res == 0) ? 1'b1 : 1'b0;

                //set subtraction flag
                flagsOut[6] = 0;
            end

            OP_SRA, OP_SRL: begin
                //set res to right shift, also set carry
                {res, flagsOut[4]} = (opcode == OP_SRA) ? {regA[7], regA} : {1'b0, regA};

                //set half carry flag
                flagsOut[5] = 0;

                //set zero flag
                flagsOut[7] = (res == 0) ? 1'b1 : 1'b0;

                //set subtraction flag
                flagsOut[6] = 0;
            end

            OP_SWAP: begin
                //set res to swapped value
                res = {regA[3:0], regA[7:4]};

                //hc flag
                flagsOut[5] = 0;

                //set zero flag
                flagsOut[7] = (res == 0) ? 1'b1 : 1'b0;

                //sub flag
                flagsOut[6] = 0;
            end

            OP_BIT: begin
                //hc flag 
                flagsOut[5] = 0;

                //sub flag
                flagsOut[6] = 0;
                
                //zero flag
                flagsOut[7] = !(regA[regB[2:0]]);
            end

            OP_RES: begin
                //set res
                res = regA;
                res[regB[2:0]] = 0;
            end

            OP_SET: begin
                //set res
                res = regA;
                res[regB[2:0]] = 1;
            end

            OP_CCF: begin
                //set carry bit
                flagsOut[4] = !flagsIn[4];

                //hc flag
                flagsOut[5] = 0;

                //sub flag
                flagsOut[6] = 0;
            end

            OP_SCF: begin
                //set carry bit
                flagsOut[4] = 1;

                //hc flag
                flagsOut[5] = 0;

                //sub flag
                flagsOut[6] = 0;
            end

            OP_DAA: begin
                //flagsOut[4] = 0; unnecessary, commented for readability

                //do we need to add 0x60, 0x06, or even 0x66
                if (((flagsIn[6] == 0) && (regA & 8'hF) > 8'h09) || (flagsIn[5] == 1)) begin
                    offsetDAA = offsetDAA | 8'h06;
                end
                if (((flagsIn[6] == 0) && (regA & 8'hF) > 8'h99) || (flagsIn[4] == 1)) begin
                    offsetDAA = offsetDAA | 8'h60;
                end

                //if we are subtracting vs if we are not
                if (flagsIn[6] == 0) begin
                    res = regA + offsetDAA;
                end else begin
                    res = regA - offsetDAA;
                    flagsOut[4] = 1;
                end

                //hc flag
                flagsOut[5] = 0;

                //sub flag
                flagsOut[6] = flagsIn[6];

                //zero flag
                flagsOut[7] = !(regA[regB[2:0]]);
            end

            OP_CPL: begin
                //set result 
                res = ~regA;

                //hc flag
                flagsOut[5] = 1;

                //sub flag
                flagsOut[6] = 1;
            end

            default: begin
            end
        endcase
    end

endmodule
