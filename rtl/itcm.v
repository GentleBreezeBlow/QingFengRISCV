//-----------------------------------------------------------------------------
// Author       : © ylu
// Filename     : instruction memory, Tightly Coupled Memory
// Date         : 2022/07/24 19:56:20
// 
// Revision     : 1.0
// Purpose      : 
// Reference    : 
//-----------------------------------------------------------------------------

module itcm #(
    parameter           AW = 4,
    parameter           DW = 32
) (
    input               WCLK,
    input  [AW - 1:0]   WADDR,
    input  [DW - 1:0]   WDATA,
    input               WEN,

    input  [AW - 1:0]   RADDR,
    output [DW - 1:0]   RDATA
);
    
    // mem
    reg [DW - 1 : 0] mem [0 : (1<<AW) - 1];

    // write
    always @(posedge WCLK) begin
        if (WEN)
            mem[WADDR] <= WDATA;
    end

    // read
    assign RDATA = mem[RADDR];

endmodule