//-----------------------------------------------------------------------------
// Author       : © ylu
// Filename     : id_ex reg
// Date         : 2022/08/01 19:41:45
// 
// Revision     : 1.0
// Purpose      : 
// Reference    : 
//-----------------------------------------------------------------------------

module id_ex (
    input               clk,
    input               rst_n,

    // pc
    input  [31:0]       pc_i,
    output reg [31:0]   pc_o,

    // ctrl signal
    input  [1:0]        ctrl_ALUOp_i,
    input               ctrl_branch_i,
    input               ctrl_mem_to_regs_i,
    input               ctrl_mem_read_i,
    input               ctrl_mem_write_i,
    input               ctrl_alusrc_i,
    input               ctrl_regs_write_i,
    output reg [1:0]    ctrl_ALUOp_o,
    output reg          ctrl_branch_o,
    output reg          ctrl_mem_to_regs_o,
    output reg          ctrl_mem_read_o,
    output reg          ctrl_mem_write_o,
    output reg          ctrl_alusrc_o,
    output reg          ctrl_regs_write_o,

    // immediate
    input  [31:0]       imme_i,
    output reg [31:0]   imme_o,

    // for alu ctrl
    input  [2:0]        funct3_i,
    input               funct7_5_i,
    output reg [2:0]    funct3_o,
    output reg          funct7_5_o,

    // regs
    input  [31:0]       regs_rdata1_i,
    input  [31:0]       regs_rdata2_i,
    output reg [31:0]   regs_rdata1_o,
    output reg [31:0]   regs_rdata2_o,

    // rd
    input  [4:0]        regs_rd_i,
    output reg [4:0]    regs_rd_o
);
    // pc
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            pc_o <= 'b0;
        end
        else begin
            pc_o <= pc_i;
        end
    end

    // ctrl signal
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            ctrl_ALUOp_o <= 'b0;
            ctrl_branch_o <= 'b0;
            ctrl_mem_to_regs_o <= 'b0;
            ctrl_mem_read_o <= 'b0;
            ctrl_mem_write_o <= 'b0;
            ctrl_alusrc_o <= 'b0;
            ctrl_regs_write_o <= 'b0;
        end
        else begin
            ctrl_ALUOp_o        <= ctrl_ALUOp_i      ;
            ctrl_branch_o       <= ctrl_branch_i     ;
            ctrl_mem_to_regs_o  <= ctrl_mem_to_regs_i;
            ctrl_mem_read_o     <= ctrl_mem_read_i   ;
            ctrl_mem_write_o    <= ctrl_mem_write_i  ;
            ctrl_alusrc_o       <= ctrl_alusrc_i     ;
            ctrl_regs_write_o   <= ctrl_regs_write_i ;
        end
    end

    // imme
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            imme_o <= 'b0;
        end
        else begin
            imme_o <= imme_i;
        end
    end

    // alu ctrl
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            funct3_o <= 'b0;
            funct7_5_o <= 'b0;
        end
        else begin
            funct3_o <= funct3_i;
            funct7_5_o <= funct7_5_i;
        end
    end

    // regs
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            regs_rdata1_o <= 'b0;
            regs_rdata2_o <= 'b0;
        end
        else begin
            regs_rdata1_o <= regs_rdata1_i;
            regs_rdata2_o <= regs_rdata2_i;
        end
    end

    // rd instr[11:7]
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            regs_rd_o <= 'b0;
        end
        else begin
            regs_rd_o <= regs_rd_i;
        end
    end
    
endmodule //id_ex
