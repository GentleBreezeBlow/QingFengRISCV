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

    input RCLK,
    input [AW - 1:0] RADDR,
    output [DW - 1:0] RDATA,
    input REN
);
    
    // mem
    reg [DW - 1 : 0] mem [0 : (1<<AW) - 1];

    // write
    always @(posedge WCLK) begin
        if (WEN)
            mem[WADDR] <= WDATA;
    end

    // read
    // always @(posedge RCLK) begin
    //     if (REN)
    //         RDATA <= mem[RADDR];
    // end
    assign RDATA = (REN) ? mem[RADDR] : 32'bz;

endmodule