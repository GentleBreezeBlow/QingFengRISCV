//-----------------------------------------------------------------------------
// Author       : © ylu
// Filename     : alu control
// Date         : 2022/07/27 17:41:11
// 
// Revision     : 1.0
// Purpose      : 
// Reference    : 
//-----------------------------------------------------------------------------

`include "../include/core_defines.v"
module alu_ctrl (
    input  [1:0]        ctrl_ALUOp,
    input  [2:0]        funct3,
    input               funct7_5,

    output [3:0]        alu_ctrl
);

    reg [3:0] R_Op;
    always @(*) begin
        case (funct3)
            3'b000 : if (funct7_5 == 1'b0)
                        R_Op = `ADD;
                     else
                        R_Op = `SUB;
            3'b001 : R_Op = `SLL;
            3'b010 : R_Op = `SLT;
            3'b011 : R_Op = `SLTU;
            3'b100 : R_Op = `XOR;
            3'b101 : if (funct7_5 == 1'b0)
                        R_Op = `SRL;
                     else
                        R_Op = `SRA;
            3'b110 : R_Op = `OR;
            3'b111 : R_Op = `AND;
            default: R_Op = `ADD;
        endcase
    end

    reg [3:0] I_Op;
    always @(*) begin
        case (funct3)
            3'b000 : I_Op = `ADD;
            3'b001 : I_Op = `SLL;
            3'b010 : I_Op = `SLT;
            3'b011 : I_Op = `SLTU;
            3'b100 : I_Op = `XOR;
            3'b101 : if (funct7_5 == 1'b0)
                        I_Op = `SRL;
                     else
                        I_Op = `SRA;
            3'b110 : I_Op = `OR;
            3'b111 : I_Op = `AND;
            default: I_Op = `ADD;
        endcase
    end

    wire [3:0] B_Op;
    assign B_Op = (funct3[2] & funct3[1]) ? `SLTU :     // Unsigned number comparison, funct3(111) is 'bgeu', funct3(110) is 'bltu'
                  (funct3[2] ^ funct3[1]) ? `SLT  :     // Signed number comparison, funct3(101) is 'bge', funct3(100) is 'blt'
                  `SUB;                                 // funct3(001) is 'bne', funct3(000) is 'beq'

    reg [3:0] alu_ctrl_r;
    always @(*) begin
        case (ctrl_ALUOp)                       // 00: , 01: I_type, 10: R_type, 11: branch
            2'b00 : alu_ctrl_r = `ADD;
            2'b01 : alu_ctrl_r = I_Op;
            2'b10 : alu_ctrl_r = R_Op;
            2'b11 : alu_ctrl_r = B_Op;
            default : alu_ctrl_r = `ADD; 
        endcase
    end

    assign alu_ctrl = alu_ctrl_r;
    
endmodule //alu_ctrl
