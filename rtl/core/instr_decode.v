//-----------------------------------------------------------------------------
// Author       : © ylu
// Filename     : instruction decode
// Date         : 2022/07/24 22:03:14
// 
// Revision     : 1.0
// Purpose      : 
// Reference    : 
//-----------------------------------------------------------------------------

`include "core_defines.v"
module instr_decode (
    input  [31:0]       instr,

    output [4:0]        regs_rs1,
    output [4:0]        regs_rs2,
    output [4:0]        regs_rd,

    output [6:0]        opcode,                 // Operation code
    output [2:0]        funct3,                 // function code
    output [6:0]        funct7,                 // function code

    output [31:0]       imme
);

    // rough definition
    assign opcode   = instr[6:0]  ;
    assign regs_rd  = instr[11:7] ;
    assign funct3   = instr[14:12];
    assign regs_rs1 = instr[19:15];
    assign regs_rs2 = instr[24:20];
    assign funct7   = instr[31:25];

    //-------------------------------------
    // immediate generation
    //-------------------------------------
    reg [31:0]   imme_r;
    assign imme = imme_r;
    always @(*) begin
        case (opcode)
            `R_type       : imme_r = 'b0; 
            `I_type_imme  : if (funct3[1:0] == 2'b01 && instr[25] == 1'b0)       // slli/srli/srai
                                imme_r = {{26{1'b0}},instr[25:20]};
                            else if (funct3[1:0] == 2'b01 && instr[25] == 1'b1)
                                imme_r = {32{1'b0}};
                            else
                                imme_r = {{20{instr[31]}}, instr[31:20]};
            `I_type_load  : imme_r = {{20{instr[31]}}, instr[31:20]};
            `S_type       : imme_r = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            `B_type       : imme_r = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
            `U_type_lui   : imme_r = {instr[31:12], {12{1'b0}}};
            `U_type_auipc : imme_r = {instr[31:12], {12{1'b0}}};
            `J_type_jal   : imme_r = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
            `J_type_jalr  : imme_r = {{20{instr[31]}}, instr[31:20]};
            default: imme_r = 'b0; 
        endcase
    end

endmodule //instr_decode
