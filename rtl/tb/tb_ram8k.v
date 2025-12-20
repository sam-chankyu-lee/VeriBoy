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
    assign data = !oe ? temp : 8'hz;
    
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
        $display("Initializing memory...");
        cs = 1;
        we = 1;
        for (int i = 0; i < 16; i++) begin
            addr = i;
            temp = i * 8; // Example data value
            #2;
        end
        addr = DEPTH-1;
        temp = 8'b11111111; // Example data value
        #2;

        $display("Verifying memory contents...");
        we = 0;
        oe = 1;
        for (int i = 0; i < 16; i++) begin
            addr = i;
            #2;
            if (data !== i * 8)
                $display("Error: Expected %0d at address %0d, got %0d", i * 8, i, data);
            else
                $display("Data at address %0d: %0d", i, data);
        end
        addr = DEPTH-1;
        #2;
        if (data !== 8'b11111111)
            $display("Error: Expected %0d at address %0d, got %0d", 8'b11111111, DEPTH-1, data);
        else
            $display("Data at address %0d: %0d", DEPTH-1, data); 
        $finish;
    end

    function void init();
        clk = 0;
        cs = 0;
        we = 0;
        oe = 0;
        addr = 0;
    endfunction
endmodule
