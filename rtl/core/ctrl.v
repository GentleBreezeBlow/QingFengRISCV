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
    output              ctrl_regs_write,
    output              ctrl_u_type,
    output              ctrl_u_type_auipc
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
    assign ctrl_alusrc      = ((opcode == `J_type_jalr) ||
                               (opcode == `I_type_imme) ||
                               (opcode == `I_type_load) ||
                               (opcode == `S_type)) ? 1'b1 : 1'b0;

    // regfiles write enable
    // 1: Enable, 0: disable
    assign ctrl_regs_write  = ((opcode == `J_type_jal)   || 
                               (opcode == `J_type_jalr)  ||
                               (opcode == `U_type_auipc) ||
                               (opcode == `U_type_lui)   ||
                               (opcode == `I_type_load)  ||
                               (opcode == `I_type_imme)  ||
                               (opcode == `R_type)       ||
                               (opcode == 7'b1110011)) ? 1'b1 : 1'b0;

    // alu_ctrl sub module control signal
    // 00: ADD, 01: I_type_imme, 10: R_type, 11: B_type/branch
    assign ctrl_ALUOp[1]    = ((opcode == `R_type) || (opcode == `B_type)) ? 1'b1 : 1'b0;
    assign ctrl_ALUOp[0]    = ((opcode == `I_type_imme) || (opcode == `B_type)) ? 1'b1 : 1'b0;

    // Select whether instruction is U_type
    assign ctrl_u_type      = ((opcode == `U_type_auipc) || (opcode == `U_type_lui)) ? 1'b1 : 1'b0;

    assign ctrl_u_type_auipc = (opcode == `U_type_auipc) ? 1'b1 : 1'b0;

endmodule //ctrl
