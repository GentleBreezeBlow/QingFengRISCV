//-----------------------------------------------------------------------------
// Author       : © ylu
// Filename     : data memory
// Date         : 2022/07/24 20:42:44
// 
// Revision     : 1.0
// Purpose      : 
// Reference    : 
//-----------------------------------------------------------------------------

module dtcm #(
    parameter AW = 4,
    parameter DW = 32
) (
    input WCLK,
    input [AW - 1:0] WADDR,
    input [DW - 1:0] WDATA,
    input WEN,

    input [2:0] RW_type,

    input RCLK,
    input [AW - 1:0] RADDR,
    output [DW - 1:0] RDATA,
    input REN
);
    
    // mem
    reg [7 : 0] mem_0 [0 : (1<<AW) - 1];
    reg [7 : 0] mem_1 [0 : (1<<AW) - 1];
    reg [7 : 0] mem_2 [0 : (1<<AW) - 1];
    reg [7 : 0] mem_3 [0 : (1<<AW) - 1];

    //debug
    reg [7:0] mem_deb;
    assign mem_deb = mem_0[0];

    wire [3:0] byte_wen;
    assign byte_wen = (RW_type == 3'b000) ? 4'b0001 :
                      (RW_type == 3'b001) ? 4'b0011 :
                      (RW_type == 3'b010) ? 4'b1111 :
                      4'b0000;

    // write
    always @(posedge WCLK) begin
        if (WEN && byte_wen[0])
            mem_0[WADDR] <= WDATA[7:0];
    end

    always @(posedge WCLK) begin
        if (WEN && byte_wen[1])
            mem_1[WADDR] <= WDATA[15:8];
    end

    always @(posedge WCLK) begin
        if (WEN && byte_wen[2])
            mem_2[WADDR] <= WDATA[23:16];
    end

    always @(posedge WCLK) begin
        if (WEN && byte_wen[3])
            mem_3[WADDR] <= WDATA[31:24];
    end

    // read
    assign RDATA = (REN) ? {mem_3[RADDR], mem_2[RADDR], mem_1[RADDR], mem_0[RADDR]} : 32'bz;

endmodule
