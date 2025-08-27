`timescale 1ns / 1ns

module regfile(
    input clk,
    input rst, 
    input writeReg,
    input [1:0] writeFlag,

    input [3:0] rdReg1,
    output [7:0] rdData1,
    output [7:0] rdData1Lo,

    input [3:0] rdReg2,
    output [7:0] rdData2,
    output [7:0] rdData2Lo,
    
    input [3:0] wrReg,
    input [15:0] wrData
);

    reg [7:0] regs [10:0];
    reg [7:0] flags;

    assign rdData1 = regs[rdReg1];
    assign rdData1Lo = regs[rdReg1+1];

    assign rdData2 = regs[rdReg2];
    assign rdData2Lo = regs[rdReg2+1];

    always @(posedge clk) begin
        if (rst) begin
            for (int i = 0; i < 11; i=i+1) begin
                regs[i] <= 0;
            end
        end else begin
            case(writeFlag)
                1: regs[wrReg] <= wrData[7:0];
                2: begin
                    regs[wrReg] <= wrData[15:8];
                    regs[wrReg+1] <= wrData[7:0];
                end
                default: begin end
            endcase //case writeFlag
        end
    end

endmodule
