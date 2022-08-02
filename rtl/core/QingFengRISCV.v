//-----------------------------------------------------------------------------
// Author       : © ylu
// Filename     : QingFengRISCV Core Top
// Date         : 2022/08/01 22:15:04
// 
// Revision     : 1.0
// Purpose      : 
// Reference    : 
//-----------------------------------------------------------------------------

module QingFengRISCV (
    input               clk,
    input               rst_n,

	output [31:0]		itcm_addr,
	input  [31:0]		itcm_datain,

    output				dtcm_mem_write,
	output [31:0]		dtcm_addr,
	output [31:0]		dtcm_dataout,
	input  [31:0]		dtcm_datain,
	output 				dtcm_mem_read
);

    /*AUTOWIRE*/
    // Beginning of automatic wires (for undeclared instantiated-module outputs)
    wire [31:0]		ex_alu_result;		// From u_instr_execute of instr_execute.v
    wire [1:0]		ex_ctrl_ALUOp;		// From u_id_ex of id_ex.v
    wire		ex_ctrl_alusrc;		// From u_id_ex of id_ex.v
    wire		ex_ctrl_branch;		// From u_id_ex of id_ex.v
    wire		ex_ctrl_mem_read;	// From u_id_ex of id_ex.v
    wire		ex_ctrl_mem_to_regs;	// From u_id_ex of id_ex.v
    wire		ex_ctrl_mem_write;	// From u_id_ex of id_ex.v
    wire		ex_ctrl_regs_write;	// From u_id_ex of id_ex.v
    wire [2:0]		ex_funct3;		// From u_id_ex of id_ex.v
    wire		ex_funct7_5;		// From u_id_ex of id_ex.v
    wire [31:0]		ex_imme;		// From u_id_ex of id_ex.v
    wire [31:0]		ex_pc;			// From u_id_ex of id_ex.v
    wire		ex_pc_jump;		// From u_instr_execute of instr_execute.v
    wire [31:0]		ex_pc_jump_addr;	// From u_instr_execute of instr_execute.v
    wire [4:0]		ex_regs_rd;		// From u_id_ex of id_ex.v
    wire [31:0]		ex_regs_rdata1;		// From u_id_ex of id_ex.v
    wire [31:0]		ex_regs_rdata2;		// From u_id_ex of id_ex.v
    wire [1:0]		id_ctrl_ALUOp;		// From u_ctrl of ctrl.v
    wire		id_ctrl_alusrc;		// From u_ctrl of ctrl.v
    wire		id_ctrl_branch;		// From u_ctrl of ctrl.v
    wire		id_ctrl_mem_read;	// From u_ctrl of ctrl.v
    wire		id_ctrl_mem_to_regs;	// From u_ctrl of ctrl.v
    wire		id_ctrl_mem_write;	// From u_ctrl of ctrl.v
    wire		id_ctrl_regs_write;	// From u_ctrl of ctrl.v
    wire [2:0]		id_funct3;		// From u_instr_decode of instr_decode.v
    wire [6:0]		id_funct7;		// From u_instr_decode of instr_decode.v
    wire [31:0]		id_imme;		// From u_instr_decode of instr_decode.v
    wire [31:0]		id_instr;		// From u_if_id of if_id.v
    wire [6:0]		id_opcode;		// From u_instr_decode of instr_decode.v
    wire [31:0]		id_pc;			// From u_if_id of if_id.v
    wire [4:0]		id_regs_rd;		// From u_instr_decode of instr_decode.v
    wire [31:0]		id_regs_rdata1;		// From u_regfiles of regfiles.v
    wire [31:0]		id_regs_rdata2;		// From u_regfiles of regfiles.v
    wire [4:0]		id_regs_rs1;		// From u_instr_decode of instr_decode.v
    wire [4:0]		id_regs_rs2;		// From u_instr_decode of instr_decode.v
    // End of automatics

    //-------------------------------------
    // instruction fetch
    //-------------------------------------
	wire [31:0] if_pc;
	wire pc_jump;
	wire [31:0] pc_jump_addr;
	assign itcm_addr = if_pc;
	assign pc_jump = ex_pc_jump;
	assign pc_jump_addr = ex_pc_jump_addr;

	/* instr_fetch AUTO_TEMPLATE (.\(.*\) (if_\1[]),); */
    instr_fetch 	u_instr_fetch (
		        	.clk            (clk),
                	.rst_n          (rst_n),
				    // Outputs
				    .pc				(if_pc[31:0]),
				    // Inputs
				    .pc_jump		(pc_jump),
				    .pc_jump_addr	(pc_jump_addr[31:0]));

    //-------------------------------------
    // if to id regs
    //-------------------------------------
	wire [31:0]	if_instr;
	assign if_instr = itcm_datain;

	/* if_id AUTO_TEMPLATE (.\(.*\)_i (if_\1[]), 
							.\(.*\)_o (id_\1[]),); */
    if_id 	u_if_id (
                	.clk            (clk),
                	.rst_n          (rst_n),
					/*AUTOINST*/
					// Outputs
					.instr_o		(id_instr[31:0]), // Templated
					.pc_o			(id_pc[31:0]),	 // Templated
					// Inputs
					.instr_i		(if_instr[31:0]), // Templated
					.pc_i			(if_pc[31:0]));	 // Templated

    //-------------------------------------
    // instruction decode
    //-------------------------------------
	/* instr_decode AUTO_TEMPLATE (.\(.*\) (id_\1[]),); */
    instr_decode 	u_instr_decode (
					.clk(clk),
					.rst_n(rst_n),
					/*AUTOINST*/
					// Outputs
					.regs_rs1	(id_regs_rs1[4:0]), // Templated
					.regs_rs2	(id_regs_rs2[4:0]), // Templated
					.regs_rd	(id_regs_rd[4:0]), // Templated
					.opcode		(id_opcode[6:0]), // Templated
					.funct3		(id_funct3[2:0]), // Templated
					.funct7		(id_funct7[6:0]), // Templated
					.imme		(id_imme[31:0]), // Templated
					// Inputs
					.instr		(id_instr[31:0])); // Templated

	wire [31:0] regs_wdata;
	assign regs_wdata = (ex_ctrl_mem_to_regs == 1'b1) ? dtcm_datain : ex_alu_result;
	/* regfiles AUTO_TEMPLATE (.\(.*\) (id_\1[]),); */
	regfiles 	u_regfiles(
					.clk(clk),
					.rst_n(rst_n),
					.regs_rd(ex_regs_rd[4:0]),
					.regs_wen(ex_ctrl_regs_write),
					.regs_wdata(regs_wdata[31:0]),
					/*AUTOINST*/
					// Outputs
					.regs_rdata1		(id_regs_rdata1[31:0]), // Templated
					.regs_rdata2		(id_regs_rdata2[31:0]), // Templated
					// Inputs
					.regs_rs1		(id_regs_rs1[4:0]), // Templated
					.regs_rs2		(id_regs_rs2[4:0])); // Templated

	/* ctrl AUTO_TEMPLATE (.\(.*\) (id_\1[]),); */
	ctrl 	u_ctrl (/*AUTOINST*/
					// Outputs
					.ctrl_ALUOp	(id_ctrl_ALUOp[1:0]),	 // Templated
					.ctrl_branch	(id_ctrl_branch),	 // Templated
					.ctrl_mem_to_regs(id_ctrl_mem_to_regs),	 // Templated
					.ctrl_mem_read	(id_ctrl_mem_read),	 // Templated
					.ctrl_mem_write	(id_ctrl_mem_write),	 // Templated
					.ctrl_alusrc	(id_ctrl_alusrc),	 // Templated
					.ctrl_regs_write(id_ctrl_regs_write),	 // Templated
					// Inputs
					.opcode		(id_opcode[6:0]));	 // Templated

    //-------------------------------------
    // id to ex regs
    //-------------------------------------
	assign id_funct7_5 = id_funct7[5];		// instr[30]

	/* id_ex AUTO_TEMPLATE (.\(.*\)_i (id_\1[]), 
							.\(.*\)_o (ex_\1[]),); */
    id_ex 	u_id_ex (
					/*AUTOINST*/
					// Outputs
					.pc_o			(ex_pc[31:0]),	 // Templated
					.ctrl_ALUOp_o		(ex_ctrl_ALUOp[1:0]), // Templated
					.ctrl_branch_o		(ex_ctrl_branch), // Templated
					.ctrl_mem_to_regs_o	(ex_ctrl_mem_to_regs), // Templated
					.ctrl_mem_read_o	(ex_ctrl_mem_read), // Templated
					.ctrl_mem_write_o	(ex_ctrl_mem_write), // Templated
					.ctrl_alusrc_o		(ex_ctrl_alusrc), // Templated
					.ctrl_regs_write_o	(ex_ctrl_regs_write), // Templated
					.imme_o		(ex_imme[31:0]), // Templated
					.funct3_o		(ex_funct3[2:0]), // Templated
					.funct7_5_o		(ex_funct7_5),	 // Templated
					.regs_rdata1_o		(ex_regs_rdata1[31:0]), // Templated
					.regs_rdata2_o		(ex_regs_rdata2[31:0]), // Templated
					.regs_rd_o		(ex_regs_rd[4:0]), // Templated
					// Inputs
					.clk			(clk),
					.rst_n			(rst_n),
					.pc_i			(id_pc[31:0]),	 // Templated
					.ctrl_ALUOp_i		(id_ctrl_ALUOp[1:0]), // Templated
					.ctrl_branch_i		(id_ctrl_branch), // Templated
					.ctrl_mem_to_regs_i	(id_ctrl_mem_to_regs), // Templated
					.ctrl_mem_read_i	(id_ctrl_mem_read), // Templated
					.ctrl_mem_write_i	(id_ctrl_mem_write), // Templated
					.ctrl_alusrc_i		(id_ctrl_alusrc), // Templated
					.ctrl_regs_write_i	(id_ctrl_regs_write), // Templated
					.imme_i		(id_imme[31:0]), // Templated
					.funct3_i		(id_funct3[2:0]), // Templated
					.funct7_5_i		(id_funct7_5),	 // Templated
					.regs_rdata1_i		(id_regs_rdata1[31:0]), // Templated
					.regs_rdata2_i		(id_regs_rdata2[31:0]), // Templated
					.regs_rd_i		(id_regs_rd[4:0])); // Templated

    //-------------------------------------
    // instruction execute
    //-------------------------------------
	/* instr_execute AUTO_TEMPLATE (.\(.*\) (ex_\1[]),); */
    instr_execute 	u_instr_execute (
					.clk(clk),
					.rst_n(rst_n),
					/*AUTOINST*/
					// Outputs
					.pc_jump		(ex_pc_jump),	 // Templated
					.pc_jump_addr		(ex_pc_jump_addr[31:0]), // Templated
					.alu_result		(ex_alu_result[31:0]), // Templated
					// Inputs
					.ctrl_ALUOp		(ex_ctrl_ALUOp[1:0]), // Templated
					.ctrl_branch		(ex_ctrl_branch), // Templated
					.ctrl_alusrc		(ex_ctrl_alusrc), // Templated
					.imme			(ex_imme[31:0]), // Templated
					.funct3		(ex_funct3[2:0]), // Templated
					.funct7_5		(ex_funct7_5),	 // Templated
					.regs_rdata1		(ex_regs_rdata1[31:0]), // Templated
					.regs_rdata2		(ex_regs_rdata2[31:0]), // Templated
					.pc			(ex_pc[31:0]));	 // Templated

	// output to DTCM
	assign dtcm_mem_write = ex_ctrl_mem_write;
	assign dtcm_mem_read  = ex_ctrl_mem_read;
	assign dtcm_addr      = ex_alu_result;
	assign dtcm_dataout	  = ex_regs_rdata2;
    
endmodule //QingFengRISCV
// Local Variables:
// verilog-library-directories: (".")
// End:
