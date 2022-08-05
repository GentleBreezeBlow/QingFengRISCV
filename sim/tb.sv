//-----------------------------------------------------------------------------
// Author       : © ylu
// Filename     : testbench
// Date         : 2022/08/02 17:34:01
// 
// Revision     : 1.0
// Purpose      : 
// Reference    : 
//-----------------------------------------------------------------------------
`timescale 1ns/1ns
module tb;

    reg clk,rst_n;

    initial begin
        clk = 0;
        rst_n = 0;
        #2
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
        `ITCM[0]  = 32'h100137b7;    // lui	a5,0x10013
        `ITCM[1]  = 32'h00878793;    // addi	a5,a5,8 # 10013008
        `ITCM[2]  = 32'h00100713;    // li	a4,1
        `ITCM[3]  = 32'h00e7a023;    // sw	a4,0(a5)
        `ITCM[4]  = 32'h100137b7;    // lui	a5,0x10013
        `ITCM[5]  = 32'h04100713;    // li	a4,65
        `ITCM[6]  = 32'h00e7a023;    // sw	a4,0(a5) # 10013000 <_start-0x103ed000>
        `ITCM[7]  = 32'h06500713;    // li	a4,101
        `ITCM[8]  = 32'h00e7a023;    // sw	a4,0(a5)
        `ITCM[9]  = 32'h06c00713;    // li	a4,108
        `ITCM[10] = 32'h00e7a023;    // sw	a4,0(a5)
        `ITCM[11] = 32'h00e7a023;    // sw	a4,0(a5)
        `ITCM[12] = 32'h06f00713;    // li	a4,111
        `ITCM[13] = 32'h00e7a023;    // sw	a4,0(a5)
        `ITCM[14] = 32'h02100713;    // li	a4,33
        `ITCM[15] = 32'h00e7a023;    // sw	a4,0(a5)
        `ITCM[16] = 32'h00a00713;    // li	a4,10
        `ITCM[17] = 32'h00e7a023;    // sw	a4,0(a5)
        `ITCM[18] = 32'h000107b7;    // lui	a5,0x10
        `ITCM[19] = 32'h04a78793;    // addi	a5,a5,74 # 1004a <_start-0x203effb6>
        `ITCM[20] = 32'h00078067;    // jr	a5
    end


endmodule //tb
