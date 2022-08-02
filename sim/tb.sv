//-----------------------------------------------------------------------------
// Author       : © ylu
// Filename     : testbench
// Date         : 2022/08/02 17:34:01
// 
// Revision     : 1.0
// Purpose      : 
// Reference    : 
//-----------------------------------------------------------------------------

module tb;

    reg clk,rst_n;

    initial begin
        clk = 0;
        rst_n = 0;
        #40
        rst_n = 1;
    end

    always #10 clk = ~clk;

    initial begin
        #4000
        $finish;
    end

    initial begin
        $fsdbDumpfile("sim.fsdb");
        $fsdbDumpvars(0,tb, "+mda");
    end
    
    // dut
    soc_top dut (
        .clk(clk),
        .rst_n(rst_n)
    );

    // hex
    `define ITCM dut.u_itcm.mem
    reg [31 : 0] mem [0 : (1<<10) - 1];
    initial begin
        `ITCM[0] = 32'h100137b7;
    end


endmodule //tb
