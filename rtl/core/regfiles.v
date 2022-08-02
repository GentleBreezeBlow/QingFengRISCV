//-----------------------------------------------------------------------------
// Author       : © ylu
// Filename     : riscv register files
// Date         : 2022/07/24 20:03:16
// 
// Revision     : 1.0
// Purpose      : 
// Reference    : 
//-----------------------------------------------------------------------------

module regfiles (
    input               clk,
    input               rst_n,

    // read registers number0
    input  [4:0]        regs_rs1,
    output [31:0]       regs_rdata1,

    // read registers number1
    input  [4:0]        regs_rs2,
    output [31:0]       regs_rdata2,

    // write registers
    input  [4:0]        regs_rd,
    input               regs_wen,
    input  [31:0]       regs_wdata
    
);
    
    reg [31:0] regs [31:0];

    // write
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            {regs[31], regs[30], regs[29], regs[28], 
            regs[27], regs[26], regs[25], regs[24],
            regs[23], regs[22], regs[21], regs[20],
            regs[19], regs[18], regs[17], regs[16],
            regs[15], regs[14], regs[13], regs[12],
            regs[11], regs[10], regs[9],  regs[8],
            regs[7],  regs[6],  regs[5],  regs[4],
            regs[3],  regs[2],  regs[1],  regs[0]} <= 0;
        end
        else if ((regs_wen == 1'b1) && (regs_rd != 'b0))     // x0 is always zero.
            regs[regs_rd] <= regs_wdata;
    end


    // read
    assign regs_rdata1 = (regs_rs1 == 'd0) ? 'b0 : regs[regs_rs1];
    assign regs_rdata2 = (regs_rs2 == 'd0) ? 'b0 : regs[regs_rs2];

endmodule //regfiles
