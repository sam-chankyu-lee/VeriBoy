`timescale 1ns / 1ns

module alu8(
    input [7:0] regA, regB,
    input [3:0] opcode,
    input carryIn,

    output reg [7:0] res,
    output reg [7:0] flagsOut
);

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
    
    reg [4:0] low, high;
    wire carryInEnable = ((opcode == OP_ADC) || (opcode == OP_SBC)) ? (carryIn) : 1'b0;

    always @* begin
        // Default (safe) values — assigned in all paths
        res       = 8'b0;
        flagsOut  = 8'b0;
        low       = 5'b0;
        high      = 5'b0;

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
            
            OP_RL: begin
                //set res to left shift, also set carry
                {flagsOut[4], res} = {regA, carryIn};

                //set half carry flag
                flagsOut[5] = 0;

                //set zero flag
                if (res == 0) 
                    flagsOut[7] = 1;

                //set subtraction flag
                flagsOut[6] = 0;
            end

            OP_RR: begin 
                //set res to right shift, also set carry
                {res, flagsOut[4]} = {carryIn, regA};

                //set half carry flag
                flagsOut[5] = 0;

                //set zero flag
                if (res == 0) 
                    flagsOut[7] = 1;

                //set subtraction flag
                flagsOut[6] = 0;
            end

            OP_BSL: begin
                
            end
            
            OP_BSR: begin
                
            end
            
            OP_SWAP: begin
                
            end

            default: begin
                
                
            end
        endcase
    end

endmodule
