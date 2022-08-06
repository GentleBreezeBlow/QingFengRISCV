//-----------------------------------------------------------------------------
// Author       : © ylu
// Filename     : if_id reg
// Date         : 2022/07/28 23:28:17
// 
// Revision     : 1.0
// Purpose      : 
// Reference    : 
//-----------------------------------------------------------------------------

module if_id (
    input               clk,
    input               rst_n,

    input               flush,

    // instr
    input  [31:0]       instr_i,
    output reg [31:0]   instr_o,
    // pc
    input  [31:0]       pc_i,
    output reg [31:0]   pc_o
);

    // instr    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            instr_o <= 'b0;
        end
        else if (flush) begin
            instr_o <= 'b0;
        end
        else begin
            instr_o <= instr_i;
        end
    end

    // pc
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            pc_o <= 'b0;
        end
        else if(flush) begin
            pc_o <= 'b0;
        end
        else begin
            pc_o <= pc_i;
        end
    end

endmodule //if_id

