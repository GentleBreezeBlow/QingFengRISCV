//-----------------------------------------------------------------------------
// Author       : © ylu
// Filename     : alu
// Date         : 2022/07/27 17:34:01
// 
// Revision     : 1.0
// Purpose      : 
// Reference    : 
//-----------------------------------------------------------------------------

`include "core_defines.v"
module alu (
    
    input  [3:0]        alu_ctrl,
    input  [31:0]       alu_datain1,
    input  [31:0]       alu_datain2,

    output [31:0]       alu_result,
    output              alu_zero
);
    
    //-------------------------------------------
    // 
    //
    wire signed [31:0]  alu_datain1_s;
    wire signed [31:0]  alu_datain2_s;

    assign alu_datain1_s = alu_datain1;
    assign alu_datain2_s = alu_datain2;

    wire [4:0] shift;
    wire [5:0] shift_n;
    assign shift = alu_datain2[4:0];
    assign shift_n = 6'd32 - shift;

    reg [31:0] alu_result_r;

    always @(*) begin
        case (alu_ctrl)
            `ADD : alu_result_r = alu_datain1 + alu_datain2;
            `SUB : alu_result_r = alu_datain1 - alu_datain2;
            `SLL : alu_result_r = alu_datain1 << shift;
            `SLT : alu_result_r = (alu_datain1_s < alu_datain2_s) ? 32'b1 : 32'b0;
            `SLTU: alu_result_r = (alu_datain1 < alu_datain2) ? 32'b1 : 32'b0;
            `XOR : alu_result_r = alu_datain1 ^ alu_datain2;
            `SRL : alu_result_r = alu_datain1 >> shift;
            `SRA : alu_result_r = ({32{alu_datain1[31]}} << shift_n) | (alu_datain1 >> shift);
            `OR  : alu_result_r = alu_datain1 | alu_datain2;
            `AND : alu_result_r = alu_datain1 & alu_datain2;
            default: alu_result_r = 'b0;
        endcase
    end

    assign alu_result = alu_result_r;

    assign alu_zero = (alu_result == 32'b0) ? 1'b1 : 1'b0;

endmodule //alu
