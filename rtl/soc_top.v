//-----------------------------------------------------------------------------
// Author       : © ylu
// Filename     : soc top
// Date         : 2022/08/02 17:00:14
// 
// Revision     : 1.0
// Purpose      : 
// Reference    : 
//-----------------------------------------------------------------------------

module soc_top (
    input               clk,
    input               rst_n
);

    parameter AW = 4;
    parameter DW = 32;

    /*AUTOWIRE*/
    // Beginning of automatic wires (for undeclared instantiated-module outputs)
    wire [DW-1:0]	dtcm_RDATA;		// From u_dtcm of dtcm.v
    wire [31:0]		dtcm_addr;		// From core of QingFengRISCV.v
    wire [31:0]		dtcm_dataout;		// From core of QingFengRISCV.v
    wire		dtcm_mem_read;		// From core of QingFengRISCV.v
    wire		dtcm_mem_write;		// From core of QingFengRISCV.v
    wire [DW-1:0]	itcm_RDATA;		// From u_itcm of itcm.v
    wire [31:0]		itcm_addr;		// From core of QingFengRISCV.v
    // End of automatics

    //-------------------------------------
    // QingFengRISCV Core
    //-------------------------------------
    wire [31:0] itcm_datain;
    wire [31:0] dtcm_datain;
    QingFengRISCV core (/*AUTOINST*/
			// Outputs
			.itcm_addr	(itcm_addr[31:0]),
			.dtcm_mem_write	(dtcm_mem_write),
			.dtcm_addr	(dtcm_addr[31:0]),
			.dtcm_dataout	(dtcm_dataout[31:0]),
			.dtcm_mem_read	(dtcm_mem_read),
			// Inputs
			.clk		(clk),
			.rst_n		(rst_n),
			.itcm_datain	(itcm_datain[31:0]),
			.dtcm_datain	(dtcm_datain[31:0]));


    //-------------------------------------
    // ITCM
    //-------------------------------------
    wire itcm_WCLK;
    wire [AW-1:0] itcm_WADDR;
    wire [DW-1:0] itcm_WDATA;
    wire itcm_WEN;
    wire [AW-1:0] itcm_RADDR;
    assign itcm_WCLK = clk;
    assign itcm_WADDR = 0;
    assign itcm_WDATA = 0;
    assign itcm_WEN = 0;
    assign itcm_RADDR = itcm_addr[AW-1:0];
    assign itcm_datain = itcm_RDATA;
    /* itcm AUTO_TEMPLATE (.\(.*\) (itcm_\1[]),); */
    itcm u_itcm (/*AUTOINST*/
		 // Outputs
		 .RDATA			(itcm_RDATA[DW-1:0]),	 // Templated
		 // Inputs
		 .WCLK			(itcm_WCLK),		 // Templated
		 .WADDR			(itcm_WADDR[AW-1:0]),	 // Templated
		 .WDATA			(itcm_WDATA[DW-1:0]),	 // Templated
		 .WEN			(itcm_WEN),		 // Templated
		 .RADDR			(itcm_RADDR[AW-1:0]));	 // Templated

    //-------------------------------------
    // DTCM
    //-------------------------------------
    wire dtcm_WCLK;
    wire [AW-1:0] dtcm_WADDR;
    wire [DW-1:0] dtcm_WDATA;
    wire dtcm_WEN;
    wire dtcm_RCLK;
    wire [AW-1:0] dtcm_RADDR;
    wire dtcm_REN;
    
    assign dtcm_WCLK  = clk;
    assign dtcm_WADDR = dtcm_addr[AW-1:0];
    assign dtcm_WDATA = dtcm_dataout;
    assign dtcm_WEN   = dtcm_mem_write;
    assign dtcm_RCLK  = clk;
    assign dtcm_RADDR = dtcm_addr[AW-1:0];
    assign dtcm_REN   = dtcm_mem_read;

    /* dtcm AUTO_TEMPLATE (.\(.*\) (dtcm_\1[]),); */
    dtcm u_dtcm (/*AUTOINST*/
		 // Outputs
		 .RDATA			(dtcm_RDATA[DW-1:0]),	 // Templated
		 // Inputs
		 .WCLK			(dtcm_WCLK),		 // Templated
		 .WADDR			(dtcm_WADDR[AW-1:0]),	 // Templated
		 .WDATA			(dtcm_WDATA[DW-1:0]),	 // Templated
		 .WEN			(dtcm_WEN),		 // Templated
		 .RCLK			(dtcm_RCLK),		 // Templated
		 .RADDR			(dtcm_RADDR[AW-1:0]),	 // Templated
		 .REN			(dtcm_REN));		 // Templated

endmodule //soc_top
// Local Variables:
// verilog-library-directories: ("." "./core")
// End:
