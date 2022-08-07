//-----------------------------------------------------------------------------
// Author       : © ylu
// Filename     : jump detection unit
// Date         : 2022/08/06 21:06:08
// 
// Revision     : 1.0
// Purpose      : 
// Reference    : 
//-----------------------------------------------------------------------------

module jump_detect (
    input  [2:0]        funct3,
    input               ctrl_branch,
    input  [3:2]        opcode_j,
    input  [2:0]        comp_result,        // 0bit: equal or NOT equal, 1bit: (signed) less than or NOT less than, 2bit: (unsigned) less than or NOT less than
    
    output              flush,
    output              stall,

    input  [31:0]       pc,
    input  [31:0]       imme,
    output              pc_jump,
    output [31:0]       pc_jump_addr
);

    //-------------------------------------
    // PC jump
    //-------------------------------------
    reg pc_jump_r;

    always @(*) begin
        pc_jump_r = 1'b0;
        if (opcode_j[2] == 1'b1)        // jal jalr
            pc_jump_r = 1'b1;
        else if (opcode_j == 2'b00)     // B_type
            case (funct3)
                3'b000: if (comp_result[0] == 1'b1)     // beq
                            pc_jump_r = 1'b1;
                        else
                            pc_jump_r = 1'b0;
                3'b001: if (comp_result[0] == 1'b0)     // bne
                            pc_jump_r = 1'b1;
                        else
                            pc_jump_r = 1'b0;
                3'b100: if (comp_result[1] == 1'b1)     // blt
                            pc_jump_r = 1'b1;
                        else
                            pc_jump_r = 1'b0;
                3'b101: if (comp_result[1] == 1'b0)     // bge
                            pc_jump_r = 1'b1;
                        else
                            pc_jump_r = 1'b0;
                3'b110: if (comp_result[2] == 1'b1)     // bltu
                            pc_jump_r = 1'b1;
                        else
                            pc_jump_r = 1'b0;
                3'b111: if (comp_result[2] == 1'b0)     // bgeu
                            pc_jump_r = 1'b1;
                        else
                            pc_jump_r = 1'b0;
                default: pc_jump_r = 1'b0; 
            endcase
        else
            pc_jump_r = 1'b0;
    end

    assign pc_jump = (ctrl_branch == 1'b1) ? pc_jump_r : 1'b0;
    assign pc_jump_addr = pc + imme;

    //-------------------------------------
    // flush
    //-------------------------------------
    assign flush = (pc_jump == 1'b1) ? 1'b1 : 1'b0;

endmodule //jump_detect
