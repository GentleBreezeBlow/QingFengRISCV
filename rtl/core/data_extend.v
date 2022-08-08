//-----------------------------------------------------------------------------
// Author       : © ylu
// Filename     : data from DTCM extend
// Date         : 2022/08/08 14:44:55
// 
// Revision     : 1.0
// Purpose      : 
// Reference    : 
//-----------------------------------------------------------------------------

module data_extend (
    input  [31:0]       dtcm_datain,
    input  [2:0]        RW_type,
    input               ctrl_mem_read,
    output [31:0]       dtcm_data_extend
);

    reg [31:0] dtcm_data_extend_r;
    always@(*)begin
        case (RW_type)
            3'b000 : dtcm_data_extend_r = {{24{dtcm_datain[7]}}, dtcm_datain[7:0]};
            3'b001 : dtcm_data_extend_r = {{16{dtcm_datain[15]}}, dtcm_datain[15:0]};
            3'b010 : dtcm_data_extend_r = dtcm_datain;
            3'b100 : dtcm_data_extend_r = {{24{1'b0}}, dtcm_datain[7:0]};
            3'b101 : dtcm_data_extend_r = {{16{1'b0}}, dtcm_datain[15:0]};
            default: dtcm_data_extend_r = 32'b0;
        endcase
    end

    assign dtcm_data_extend = (ctrl_mem_read) ? dtcm_data_extend_r : 32'b0;
    
endmodule //data_extend
