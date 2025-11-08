module tb_ram8k;
    parameter ADDR_WIDTH = 13;
    parameter DATA_WIDTH = 8;
    parameter DEPTH = 8192;

    reg clk;
    reg cs;
    reg we;
    reg oe;
    reg [ADDR_WIDTH-1:0] addr;
    wire [DATA_WIDTH-1:0] data;

    always #1 clk = ~clk;
    reg [DATA_WIDTH-1:0] temp;
    
    ram8k u0( 	
        .clk(clk),
        .addr(addr),
        .data(data),
        .cs(cs),
        .we(we),
        .oe(oe)
    );

    initial begin
        init();
    end

    function void init();
        clk = 0;
        cs = 0;
        we = 0;
        oe = 0;
        addr = 0;
        data = 0;
    endfunction
endmodule