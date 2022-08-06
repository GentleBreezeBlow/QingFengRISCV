//-----------------------------------------------------------------------------
// Author       : © ylu
// Filename     : instruction fetch
// Date         : 2022/07/24 20:51:39
// 
// Revision     : 1.0
// Purpose      : 
// Reference    : 
//-----------------------------------------------------------------------------

module instr_fetch #(
    parameter AW = 4
) (
    input               clk,
    input               rst_n,

    input               pc_jump,
    input  [31:0]       pc_jump_addr,
    output [31:0]       pc
);

    reg [31:0]          pc_r;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            pc_r <= 'b0;                // pc reset
        end
        else if (pc_jump == 1'b1)        // pc jump
            pc_r <= pc_jump_addr;
        else
            pc_r <= pc_r + 32'd4;
    end

    assign pc = pc_r;

endmodule //instr_fetch
