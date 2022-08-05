//-----------------------------------------------------------------------------
// Author       : © ylu
// Filename     : Forwaring unit
// Date         : 2022/08/05 21:27:26
// 
// Revision     : 1.0
// Purpose      : 
// Reference    : 
//-----------------------------------------------------------------------------

module forward_unit (
    input               clk,
    input               rst_n,

    input  [4:0]        id_regs_rs1,
    input  [4:0]        id_regs_rs2,
    input  [4:0]        ex_regs_rd,
    input               ex_ctrl_regs_write,

    output              forward_rs1,
    output              forward_rs2
);
    // Data Hazard

    // The rd number of the previous instruction is the same as the rs1 number of the next instruction
    assign forward_rs1 =   ((ex_ctrl_regs_write == 1'b1) &&
                            (ex_regs_rd != 'b0) &&
                            (id_regs_rs1 == ex_regs_rd)) ? 1'b1 : 1'b0;
    // The rd number of the previous instruction is the same as the rs2 number of the next instruction
    assign forward_rs2 =   ((ex_ctrl_regs_write == 1'b1) &&
                            (ex_regs_rd != 'b0) &&
                            (id_regs_rs2 == ex_regs_rd)) ? 1'b1 : 1'b0;
    
endmodule //forward_unit
