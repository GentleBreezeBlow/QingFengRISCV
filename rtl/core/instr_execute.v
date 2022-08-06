//-----------------------------------------------------------------------------
// Author       : © ylu
// Filename     : Instruction execute
// Date         : 2022/07/26 22:09:12
// 
// Revision     : 1.0
// Purpose      : 
// Reference    : 
//-----------------------------------------------------------------------------

module instr_execute (
    input  [1:0]        ctrl_ALUOp,             // ALU Operation Code
    input               ctrl_alusrc,

    input  [31:0]       imme,

    input  [2:0]        funct3,
    input               funct7_5,

    input  [31:0]       rdata1,
    input  [31:0]       rdata2,

    output [31:0]       alu_result
);

    /*AUTOWIRE*/
    // Beginning of automatic wires (for undeclared instantiated-module outputs)
    wire [3:0]		alu_ctrl;		// From u_alu_ctrl of alu_ctrl.v
    wire		alu_zero;		// From u_alu of alu.v
    // End of automatics

    wire [31:0] alu_datain1;
    wire [31:0] alu_datain2;

    //-------------------------------------
    // ALU
    //-------------------------------------
    assign alu_datain1 = rdata1;
    assign alu_datain2 = (ctrl_alusrc == 1'b1) ? imme : rdata2;

    alu u_alu (/*AUTOINST*/
	       // Outputs
	       .alu_result		(alu_result[31:0]),
	       .alu_zero		(alu_zero),
	       // Inputs
	       .alu_ctrl		(alu_ctrl[3:0]),
	       .alu_datain1		(alu_datain1[31:0]),
	       .alu_datain2		(alu_datain2[31:0]));

    alu_ctrl u_alu_ctrl(/*AUTOINST*/
			// Outputs
			.alu_ctrl	(alu_ctrl[3:0]),
			// Inputs
			.ctrl_ALUOp	(ctrl_ALUOp[1:0]),
			.funct3		(funct3[2:0]),
			.funct7_5	(funct7_5));

endmodule //instr_execute
// Local Variables:
// verilog-library-directories: (".")
// End:
