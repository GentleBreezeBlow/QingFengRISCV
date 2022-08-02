//-----------------------------------------------------------------------------
// Author       : © ylu
// Filename     : control
// Date         : 2022/08/01 19:37:21
// 
// Revision     : 1.0
// Purpose      : 
// Reference    : 
//-----------------------------------------------------------------------------

`include "core_defines.v"
module ctrl (
    input  [6:0]        opcode,                 // Operation code

    output [1:0]        ctrl_ALUOp,             // ALU Operation Code
    output              ctrl_branch,
    output              ctrl_mem_to_regs,
    output              ctrl_mem_read,
    output              ctrl_mem_write,
    output              ctrl_alusrc,
    output              ctrl_regs_write
);
    
    //-------------------------------------
    // control signal generation
    //-------------------------------------
    // Choose whether to jump
    // 1: Jump, 0: No/ PC=PC+4
    assign ctrl_branch      = ((opcode == `J_type_jal) ||
                               (opcode == `J_type_jalr) ||
                               (opcode == `B_type)) ? 1'b1 : 1'b0;

    // Select whether the data written to the regfiles is from DTCM or ALU result.
    // 1: From DTCM, 0: From ALU.
    // lb, lbu, lh, lhu, lw
    assign ctrl_mem_to_regs = (opcode == `I_type_load) ? 1'b1 : 1'b0;

    // Choose whether to read data from DTCM
    // 1: DTCM read enable, 0: DTCM read disable
    assign ctrl_mem_read    = (opcode == `I_type_load) ? 1'b1 : 1'b0;

    // Choose whether to write data from DTCM
    // 1: DTCM write enable, 0: DTCM write disable
    assign ctrl_mem_write   = (opcode == `S_type) ? 1'b1 : 1'b0;

    // Select whether the second ALU input comes from the regfiles or immediate
    // 1: From immediate, 0: From regfiles
    assign ctrl_alusrc      = ((opcode == `U_type_lui) ||
                               (opcode == `U_type_auipc) ||
                               (opcode == `I_type_imme) ||
                               (opcode == `I_type_load) ||
                               (opcode == `S_type)) ? 1'b1 : 1'b0;

    // Select whether the regfiles input write data comes from ALU or DTCM
    // 1: From DTCM, 0: From ALU
    assign ctrl_regs_write  = ((opcode == `B_type) || 
                               (opcode == `S_type)) ? 1'b0 : 1'b1;

endmodule //ctrl
