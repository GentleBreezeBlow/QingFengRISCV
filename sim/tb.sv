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
        #50000
        $display("TIMEOUT!!!");
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

    `define ITCM_MEM dut.u_itcm.mem
    integer i;
    reg [7:0] itcm_mem [0:((1<<12)*4) - 1];
    initial begin
        $readmemh("main.verilog",itcm_mem);
        for(i=0;i<(1<<12);i=i+1) begin
            `ITCM_MEM[i][7:0]   = itcm_mem[i*4+0];
            `ITCM_MEM[i][15:8]  = itcm_mem[i*4+1];
            `ITCM_MEM[i][23:16] = itcm_mem[i*4+2];
            `ITCM_MEM[i][31:24] = itcm_mem[i*4+3];
        end
    end

    wire[31:0] x3  = dut.core.u_regfiles.regs[3];
    wire[31:0] x26 = dut.core.u_regfiles.regs[26];
    wire[31:0] x27 = dut.core.u_regfiles.regs[27];
    integer r;
    initial begin
        wait(x26 == 32'b1)   // wait sim end, when x26 == 1
        #100
        if (x27 == 32'b1) begin
            $display("~~~~~~~~~~~~~~~~~~~ TEST_PASS ~~~~~~~~~~~~~~~~~~~");
            $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
            $display("~~~~~~~~~ #####     ##     ####    #### ~~~~~~~~~");
            $display("~~~~~~~~~ #    #   #  #   #       #     ~~~~~~~~~");
            $display("~~~~~~~~~ #    #  #    #   ####    #### ~~~~~~~~~");
            $display("~~~~~~~~~ #####   ######       #       #~~~~~~~~~");
            $display("~~~~~~~~~ #       #    #  #    #  #    #~~~~~~~~~");
            $display("~~~~~~~~~ #       #    #   ####    #### ~~~~~~~~~");
            $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
        end else begin
            $display("~~~~~~~~~~~~~~~~~~~ TEST_FAIL ~~~~~~~~~~~~~~~~~~~~");
            $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
            $display("~~~~~~~~~~######    ##       #    #     ~~~~~~~~~~");
            $display("~~~~~~~~~~#        #  #      #    #     ~~~~~~~~~~");
            $display("~~~~~~~~~~#####   #    #     #    #     ~~~~~~~~~~");
            $display("~~~~~~~~~~#       ######     #    #     ~~~~~~~~~~");
            $display("~~~~~~~~~~#       #    #     #    #     ~~~~~~~~~~");
            $display("~~~~~~~~~~#       #    #     #    ######~~~~~~~~~~");
            $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
            $display("fail testnum = %2d", x3);
            for (r = 0; r < 32; r = r + 1)
                $display("x%2d = 0x%x", r, dut.core.u_regfiles.regs[r]);
        end
        $finish;
    end

    // hex
    // `define ITCM_MEM dut.u_itcm.mem
    // reg [31 : 0] mem [0 : (1<<10) - 1];
    // initial begin
    //     // test sb
    //     `ITCM_MEM[0]    = 32'h00500113;          	// li	sp,5
    //     `ITCM_MEM[1]    = 32'h00200023;          	// sb	sp,0(zero)

    //     // test add
    //     // `ITCM_MEM[0]    = 32'h03200093;          	// li	ra,50
    //     // `ITCM_MEM[1]    = 32'h03700113;          	// li	sp,55
    //     // `ITCM_MEM[2]    = 32'h001101b3;          	// add	gp,sp,ra
    //     // `ITCM_MEM[3]    = 32'h40110233;          	// sub	tp,sp,ra

    //     // test jump
    //     // `ITCM_MEM[0]    = 32'b0000_0000_0001_0000_0000_0000_1001_0011;  // li	ra,1
    //     // `ITCM_MEM[1]    = 32'b0000_0000_0001_0000_0000_0001_0001_0011;  // li	sp,1
    //     // `ITCM_MEM[2]    = 32'b0000_0001_0000_0000_0000_0001_1001_0011;  // li	gp,16
    //     // `ITCM_MEM[3]    = 32'h04208c63;  // beq	ra,sp,20400064 <branch_to_here>
    //     // `ITCM_MEM[4]    = 32'h100137b7;  // lui	a5,0x10013
    //     // `ITCM_MEM[25]   = 32'h00878793;  // addi	a5,a5,8 # 10013008

    //     // test forwarding unit
    //     // `ITCM_MEM[0]    = 32'h00000103;  // lb	sp,0(zero)
    //     // `ITCM_MEM[1]    = 32'h00110213;  // addi	tp,sp,1

    //     // `ITCM_MEM[0]  = 32'h100137b7;    // lui	a5,0x10013
    //     // `ITCM_MEM[1]  = 32'h00878793;    // addi	a5,a5,8 # 10013008
    //     // `ITCM_MEM[2]  = 32'h00100713;    // li	a4,1
    //     // `ITCM_MEM[3]  = 32'h00e7a023;    // sw	a4,0(a5)
    //     // `ITCM_MEM[4]  = 32'h100137b7;    // lui	a5,0x10013
    //     // `ITCM_MEM[5]  = 32'h04100713;    // li	a4,65
    //     // `ITCM_MEM[6]  = 32'h00e7a023;    // sw	a4,0(a5) # 10013000 <_start-0x103ed000>
    //     // `ITCM_MEM[7]  = 32'h06500713;    // li	a4,101
    //     // `ITCM_MEM[8]  = 32'h00e7a023;    // sw	a4,0(a5)
    //     // `ITCM_MEM[9]  = 32'h06c00713;    // li	a4,108
    //     // `ITCM_MEM[10] = 32'h00e7a023;    // sw	a4,0(a5)
    //     // `ITCM_MEM[11] = 32'h00e7a023;    // sw	a4,0(a5)
    //     // `ITCM_MEM[12] = 32'h06f00713;    // li	a4,111
    //     // `ITCM_MEM[13] = 32'h00e7a023;    // sw	a4,0(a5)
    //     // `ITCM_MEM[14] = 32'h02100713;    // li	a4,33
    //     // `ITCM_MEM[15] = 32'h00e7a023;    // sw	a4,0(a5)
    //     // `ITCM_MEM[16] = 32'h00a00713;    // li	a4,10
    //     // `ITCM_MEM[17] = 32'h00e7a023;    // sw	a4,0(a5)
    //     // `ITCM_MEM[18] = 32'h000107b7;    // lui	a5,0x10
    //     // `ITCM_MEM[19] = 32'h04a78793;    // addi	a5,a5,74 # 1004a <_start-0x203effb6>
    //     // `ITCM_MEM[20] = 32'h00078067;    // jr	a5
    // end

    // data
    // `define DTCM_MEM dut.u_dtcm.mem
    // initial begin
    //     `DTCM_MEM[0] = 32'h5;
    // end


endmodule //tb
