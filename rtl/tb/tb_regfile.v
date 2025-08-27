`timescale 1ns / 1ns

module tb_regfile;
    reg clk;
    reg rst; 
    reg writeReg;
    reg [1:0] writeEn;
    reg writeFlag;

    reg [3:0] rdReg1;
    reg [3:0] rdReg2;
    reg [3:0] wrReg;
    reg [15:0] wrData;


    wire [7:0] rdData1;
    wire [7:0] rdData1Lo;

    wire [7:0] rdData2;
    wire [7:0] rdData2Lo;

    reg [7:0] flagData;
    wire [7:0] rdFlag;

    always #1 clk = ~clk;
    integer values[21:0];

    regfile r0 (
        .clk(clk),
        .rst(rst), 
        .writeReg(writeReg),
        .writeEn(writeEn),
        .writeFlag(writeFlag),

        .rdReg1(rdReg1),
        .rdData1(rdData1),
        .rdData1Lo(rdData1Lo),

        .rdReg2(rdReg2),
        .rdData2(rdData2),
        .rdData2Lo(rdData2Lo),

        .flagData(flagData),
        .rdFlag(rdFlag),
        
        .wrReg(wrReg),
        .wrData(wrData)
    );

    function void init();
        clk <= 0;
        rst <= 1;
        writeReg <= 0;
        writeEn <= 0;
        writeFlag <= 0;
        rdReg1 <= 0;
        rdReg2 <= 0;
        wrReg <= 0;
        wrData <= 0;
        flagData <= 0;
    endfunction

    task reset_release();
        #10 rst = 0;
    endtask

    task write_and_read();
        for (int i=0; i<11; i=i+1) begin
            #2 wrReg <= i;
            writeEn <= 1;
            wrData <= i;
        end
        
        #2 wrReg <= 0;
        writeEn <= 0;
        wrData <= 0;

        for (int i=0; i<9; i=i+2) begin
            rdReg1 <= i;
            #2 values[i] <= rdData1;
            values[i+1] <= rdData1Lo;
        end
        rdReg1 <= 10;
        #2 values[10] <= rdData1;

        for (int i=0; i<9; i=i+2) begin
            rdReg2 <= i;
            #2 values[i+11] <= rdData2;
            values[i+12] <= rdData2Lo;
        end
        rdReg2 <= 10;
        #2 values[21] <= rdData2;
        
        for (int j=0; j<2; j=j+1) begin
            for (int i=0; i<11; i=i+1) begin
                $display("[%0d] reg%0d : %0d", j, i, values[j*11+i]);
            end 
        end
    endtask

    task flags();
        writeFlag <= 1;
        flagData <= 7'b1111000;
        #2 writeFlag <= 0;
        $display("Flag Expected: %0d | Flag Value: %0d", 7'b1111000, rdFlag);
        #2 writeFlag <= 1;
        flagData <= 7'b0000000;
        #2 writeFlag <= 0;
        $display("Flag Expected: %0d | Flag Value: %0d", 0, rdFlag);
    endtask

    initial begin
        init();
        reset_release();
        write_and_read();
        flags();
        $finish;
    end 

endmodule
