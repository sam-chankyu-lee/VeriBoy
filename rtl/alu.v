module alu(
    input [15:0] regA, regB,
    input [3:0] opcode,
    input carryIn,

    output [15:0] res,
    output [7:0] flagsOut
);

    localparam OP_ADD = 4'b0000;
    localparam OP_ADC = 4'b0001;
    localparam OP_SUB = 4'b0010;
    localparam OP_SBC = 4'b0011;
    localparam OP_CP = 4'b0100;
    localparam OP_AND = 4'b0101;
    localparam OP_OR = 4'b0110;
    localparam OP_XOR = 4'b0111;
    localparam OP_BSL = 4'b1000;
    localparam OP_BSR = 4'b1001;
    localparam OP_SWAP = 4'b1010;
    
    always @(posedge clk) begin
        case (opcode)
            4'b0000:
                res <= regA + regB;
            4'b0000:
            
            4'b0001:
            
            4'b0010:
            
            4'b0011:
            
            4'b0100:
            
            4'b0101:
            
            4'b0110:
            
            4'b0111:
            
            4'b1000:
            
            4'b1001:
            
            4'b1010:

            default:
            
        endcase
    end

endmodule