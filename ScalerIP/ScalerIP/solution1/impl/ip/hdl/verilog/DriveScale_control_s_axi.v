// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.10
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
`timescale 1ns/1ps
module DriveScale_control_s_axi
#(parameter
    C_S_AXI_ADDR_WIDTH = 8,
    C_S_AXI_DATA_WIDTH = 32
)(
    input  wire                          ACLK,
    input  wire                          ARESET,
    input  wire                          ACLK_EN,
    input  wire [C_S_AXI_ADDR_WIDTH-1:0] AWADDR,
    input  wire                          AWVALID,
    output wire                          AWREADY,
    input  wire [C_S_AXI_DATA_WIDTH-1:0] WDATA,
    input  wire [C_S_AXI_DATA_WIDTH/8-1:0] WSTRB,
    input  wire                          WVALID,
    output wire                          WREADY,
    output wire [1:0]                    BRESP,
    output wire                          BVALID,
    input  wire                          BREADY,
    input  wire [C_S_AXI_ADDR_WIDTH-1:0] ARADDR,
    input  wire                          ARVALID,
    output wire                          ARREADY,
    output wire [C_S_AXI_DATA_WIDTH-1:0] RDATA,
    output wire [1:0]                    RRESP,
    output wire                          RVALID,
    input  wire                          RREADY,
    output wire [31:0]                   ScaleValue,
    output wire [31:0]                   ZeroCross,
    input  wire [1:0]                    calibratedStep_address0,
    input  wire                          calibratedStep_ce0,
    output wire [31:0]                   calibratedStep_q0,
    input  wire [1:0]                    calibratedOffset_address0,
    input  wire                          calibratedOffset_ce0,
    output wire [31:0]                   calibratedOffset_q0,
    input  wire [1:0]                    OffsetCounts_address0,
    input  wire                          OffsetCounts_ce0,
    input  wire                          OffsetCounts_we0,
    input  wire [31:0]                   OffsetCounts_d0,
    output wire [31:0]                   samp_index,
    output wire [31:0]                   iCurrentFilter,
    output wire [31:0]                   fClipValue,
    output wire [31:0]                   sync_reset,
    input  wire [31:0]                   alignOffset,
    input  wire                          alignOffset_ap_vld,
    output wire [31:0]                   colaEnable,
    output wire [31:0]                   group_delay,
    input  wire [1:0]                    calibratedStepRecip_address0,
    input  wire                          calibratedStepRecip_ce0,
    output wire [31:0]                   calibratedStepRecip_q0,
    output wire [31:0]                   loop_delay,
    input  wire [31:0]                   dbg_ready,
    input  wire                          dbg_ready_ap_vld
);
//------------------------Address Info-------------------
// Protocol Used: ap_ctrl_none
//
// 0x00 : reserved
// 0x04 : reserved
// 0x08 : reserved
// 0x0c : reserved
// 0x10 : Data signal of ScaleValue
//        bit 31~0 - ScaleValue[31:0] (Read/Write)
// 0x14 : reserved
// 0x18 : Data signal of ZeroCross
//        bit 31~0 - ZeroCross[31:0] (Read/Write)
// 0x1c : reserved
// 0x50 : Data signal of samp_index
//        bit 31~0 - samp_index[31:0] (Read/Write)
// 0x54 : reserved
// 0x58 : Data signal of iCurrentFilter
//        bit 31~0 - iCurrentFilter[31:0] (Read/Write)
// 0x5c : reserved
// 0x60 : Data signal of fClipValue
//        bit 31~0 - fClipValue[31:0] (Read/Write)
// 0x64 : reserved
// 0x68 : Data signal of sync_reset
//        bit 31~0 - sync_reset[31:0] (Read/Write)
// 0x6c : reserved
// 0x70 : Data signal of alignOffset
//        bit 31~0 - alignOffset[31:0] (Read)
// 0x74 : Control signal of alignOffset
//        bit 0  - alignOffset_ap_vld (Read/COR)
//        others - reserved
// 0x80 : Data signal of colaEnable
//        bit 31~0 - colaEnable[31:0] (Read/Write)
// 0x84 : reserved
// 0x88 : Data signal of group_delay
//        bit 31~0 - group_delay[31:0] (Read/Write)
// 0x8c : reserved
// 0xa0 : Data signal of loop_delay
//        bit 31~0 - loop_delay[31:0] (Read/Write)
// 0xa4 : reserved
// 0xa8 : Data signal of dbg_ready
//        bit 31~0 - dbg_ready[31:0] (Read)
// 0xac : Control signal of dbg_ready
//        bit 0  - dbg_ready_ap_vld (Read/COR)
//        others - reserved
// 0x20 ~
// 0x2f : Memory 'calibratedStep' (4 * 32b)
//        Word n : bit [31:0] - calibratedStep[n]
// 0x30 ~
// 0x3f : Memory 'calibratedOffset' (4 * 32b)
//        Word n : bit [31:0] - calibratedOffset[n]
// 0x40 ~
// 0x4f : Memory 'OffsetCounts' (4 * 32b)
//        Word n : bit [31:0] - OffsetCounts[n]
// 0x90 ~
// 0x9f : Memory 'calibratedStepRecip' (4 * 32b)
//        Word n : bit [31:0] - calibratedStepRecip[n]
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

//------------------------Parameter----------------------
localparam
    ADDR_SCALEVALUE_DATA_0        = 8'h10,
    ADDR_SCALEVALUE_CTRL          = 8'h14,
    ADDR_ZEROCROSS_DATA_0         = 8'h18,
    ADDR_ZEROCROSS_CTRL           = 8'h1c,
    ADDR_SAMP_INDEX_DATA_0        = 8'h50,
    ADDR_SAMP_INDEX_CTRL          = 8'h54,
    ADDR_ICURRENTFILTER_DATA_0    = 8'h58,
    ADDR_ICURRENTFILTER_CTRL      = 8'h5c,
    ADDR_FCLIPVALUE_DATA_0        = 8'h60,
    ADDR_FCLIPVALUE_CTRL          = 8'h64,
    ADDR_SYNC_RESET_DATA_0        = 8'h68,
    ADDR_SYNC_RESET_CTRL          = 8'h6c,
    ADDR_ALIGNOFFSET_DATA_0       = 8'h70,
    ADDR_ALIGNOFFSET_CTRL         = 8'h74,
    ADDR_COLAENABLE_DATA_0        = 8'h80,
    ADDR_COLAENABLE_CTRL          = 8'h84,
    ADDR_GROUP_DELAY_DATA_0       = 8'h88,
    ADDR_GROUP_DELAY_CTRL         = 8'h8c,
    ADDR_LOOP_DELAY_DATA_0        = 8'ha0,
    ADDR_LOOP_DELAY_CTRL          = 8'ha4,
    ADDR_DBG_READY_DATA_0         = 8'ha8,
    ADDR_DBG_READY_CTRL           = 8'hac,
    ADDR_CALIBRATEDSTEP_BASE      = 8'h20,
    ADDR_CALIBRATEDSTEP_HIGH      = 8'h2f,
    ADDR_CALIBRATEDOFFSET_BASE    = 8'h30,
    ADDR_CALIBRATEDOFFSET_HIGH    = 8'h3f,
    ADDR_OFFSETCOUNTS_BASE        = 8'h40,
    ADDR_OFFSETCOUNTS_HIGH        = 8'h4f,
    ADDR_CALIBRATEDSTEPRECIP_BASE = 8'h90,
    ADDR_CALIBRATEDSTEPRECIP_HIGH = 8'h9f,
    WRIDLE                        = 2'd0,
    WRDATA                        = 2'd1,
    WRRESP                        = 2'd2,
    WRRESET                       = 2'd3,
    RDIDLE                        = 2'd0,
    RDDATA                        = 2'd1,
    RDRESET                       = 2'd2,
    ADDR_BITS                = 8;

//------------------------Local signal-------------------
    reg  [1:0]                    wstate = WRRESET;
    reg  [1:0]                    wnext;
    reg  [ADDR_BITS-1:0]          waddr;
    wire [C_S_AXI_DATA_WIDTH-1:0] wmask;
    wire                          aw_hs;
    wire                          w_hs;
    reg  [1:0]                    rstate = RDRESET;
    reg  [1:0]                    rnext;
    reg  [C_S_AXI_DATA_WIDTH-1:0] rdata;
    wire                          ar_hs;
    wire [ADDR_BITS-1:0]          raddr;
    // internal registers
    reg  [31:0]                   int_ScaleValue = 'b0;
    reg  [31:0]                   int_ZeroCross = 'b0;
    reg  [31:0]                   int_samp_index = 'b0;
    reg  [31:0]                   int_iCurrentFilter = 'b0;
    reg  [31:0]                   int_fClipValue = 'b0;
    reg  [31:0]                   int_sync_reset = 'b0;
    reg                           int_alignOffset_ap_vld;
    reg  [31:0]                   int_alignOffset = 'b0;
    reg  [31:0]                   int_colaEnable = 'b0;
    reg  [31:0]                   int_group_delay = 'b0;
    reg  [31:0]                   int_loop_delay = 'b0;
    reg                           int_dbg_ready_ap_vld;
    reg  [31:0]                   int_dbg_ready = 'b0;
    // memory signals
    wire [1:0]                    int_calibratedStep_address0;
    wire                          int_calibratedStep_ce0;
    wire [31:0]                   int_calibratedStep_q0;
    wire [1:0]                    int_calibratedStep_address1;
    wire                          int_calibratedStep_ce1;
    wire                          int_calibratedStep_we1;
    wire [3:0]                    int_calibratedStep_be1;
    wire [31:0]                   int_calibratedStep_d1;
    wire [31:0]                   int_calibratedStep_q1;
    reg                           int_calibratedStep_read;
    reg                           int_calibratedStep_write;
    wire [1:0]                    int_calibratedOffset_address0;
    wire                          int_calibratedOffset_ce0;
    wire [31:0]                   int_calibratedOffset_q0;
    wire [1:0]                    int_calibratedOffset_address1;
    wire                          int_calibratedOffset_ce1;
    wire                          int_calibratedOffset_we1;
    wire [3:0]                    int_calibratedOffset_be1;
    wire [31:0]                   int_calibratedOffset_d1;
    wire [31:0]                   int_calibratedOffset_q1;
    reg                           int_calibratedOffset_read;
    reg                           int_calibratedOffset_write;
    wire [1:0]                    int_OffsetCounts_address0;
    wire                          int_OffsetCounts_ce0;
    wire [3:0]                    int_OffsetCounts_be0;
    wire [31:0]                   int_OffsetCounts_d0;
    wire [31:0]                   int_OffsetCounts_q0;
    wire [1:0]                    int_OffsetCounts_address1;
    wire                          int_OffsetCounts_ce1;
    wire                          int_OffsetCounts_we1;
    wire [3:0]                    int_OffsetCounts_be1;
    wire [31:0]                   int_OffsetCounts_d1;
    wire [31:0]                   int_OffsetCounts_q1;
    reg                           int_OffsetCounts_read;
    reg                           int_OffsetCounts_write;
    wire [1:0]                    int_calibratedStepRecip_address0;
    wire                          int_calibratedStepRecip_ce0;
    wire [31:0]                   int_calibratedStepRecip_q0;
    wire [1:0]                    int_calibratedStepRecip_address1;
    wire                          int_calibratedStepRecip_ce1;
    wire                          int_calibratedStepRecip_we1;
    wire [3:0]                    int_calibratedStepRecip_be1;
    wire [31:0]                   int_calibratedStepRecip_d1;
    wire [31:0]                   int_calibratedStepRecip_q1;
    reg                           int_calibratedStepRecip_read;
    reg                           int_calibratedStepRecip_write;

//------------------------Instantiation------------------
// int_calibratedStep
DriveScale_control_s_axi_ram #(
    .MEM_STYLE ( "auto" ),
    .MEM_TYPE  ( "2P" ),
    .BYTES     ( 4 ),
    .DEPTH     ( 4 )
) int_calibratedStep (
    .clk0      ( ACLK ),
    .address0  ( int_calibratedStep_address0 ),
    .ce0       ( int_calibratedStep_ce0 ),
    .we0       ( {4{1'b0}} ),
    .d0        ( {32{1'b0}} ),
    .q0        ( int_calibratedStep_q0 ),
    .clk1      ( ACLK ),
    .address1  ( int_calibratedStep_address1 ),
    .ce1       ( int_calibratedStep_ce1 ),
    .we1       ( int_calibratedStep_be1 ),
    .d1        ( int_calibratedStep_d1 ),
    .q1        ( int_calibratedStep_q1 )
);
// int_calibratedOffset
DriveScale_control_s_axi_ram #(
    .MEM_STYLE ( "auto" ),
    .MEM_TYPE  ( "2P" ),
    .BYTES     ( 4 ),
    .DEPTH     ( 4 )
) int_calibratedOffset (
    .clk0      ( ACLK ),
    .address0  ( int_calibratedOffset_address0 ),
    .ce0       ( int_calibratedOffset_ce0 ),
    .we0       ( {4{1'b0}} ),
    .d0        ( {32{1'b0}} ),
    .q0        ( int_calibratedOffset_q0 ),
    .clk1      ( ACLK ),
    .address1  ( int_calibratedOffset_address1 ),
    .ce1       ( int_calibratedOffset_ce1 ),
    .we1       ( int_calibratedOffset_be1 ),
    .d1        ( int_calibratedOffset_d1 ),
    .q1        ( int_calibratedOffset_q1 )
);
// int_OffsetCounts
DriveScale_control_s_axi_ram #(
    .MEM_STYLE ( "auto" ),
    .MEM_TYPE  ( "T2P" ),
    .BYTES     ( 4 ),
    .DEPTH     ( 4 )
) int_OffsetCounts (
    .clk0      ( ACLK ),
    .address0  ( int_OffsetCounts_address0 ),
    .ce0       ( int_OffsetCounts_ce0 ),
    .we0       ( int_OffsetCounts_be0 ),
    .d0        ( int_OffsetCounts_d0 ),
    .q0        ( int_OffsetCounts_q0 ),
    .clk1      ( ACLK ),
    .address1  ( int_OffsetCounts_address1 ),
    .ce1       ( int_OffsetCounts_ce1 ),
    .we1       ( int_OffsetCounts_be1 ),
    .d1        ( int_OffsetCounts_d1 ),
    .q1        ( int_OffsetCounts_q1 )
);
// int_calibratedStepRecip
DriveScale_control_s_axi_ram #(
    .MEM_STYLE ( "auto" ),
    .MEM_TYPE  ( "2P" ),
    .BYTES     ( 4 ),
    .DEPTH     ( 4 )
) int_calibratedStepRecip (
    .clk0      ( ACLK ),
    .address0  ( int_calibratedStepRecip_address0 ),
    .ce0       ( int_calibratedStepRecip_ce0 ),
    .we0       ( {4{1'b0}} ),
    .d0        ( {32{1'b0}} ),
    .q0        ( int_calibratedStepRecip_q0 ),
    .clk1      ( ACLK ),
    .address1  ( int_calibratedStepRecip_address1 ),
    .ce1       ( int_calibratedStepRecip_ce1 ),
    .we1       ( int_calibratedStepRecip_be1 ),
    .d1        ( int_calibratedStepRecip_d1 ),
    .q1        ( int_calibratedStepRecip_q1 )
);


//------------------------AXI write fsm------------------
assign AWREADY = (wstate == WRIDLE);
assign WREADY  = (wstate == WRDATA) && (!ar_hs);
assign BRESP   = 2'b00;  // OKAY
assign BVALID  = (wstate == WRRESP);
assign wmask   = { {8{WSTRB[3]}}, {8{WSTRB[2]}}, {8{WSTRB[1]}}, {8{WSTRB[0]}} };
assign aw_hs   = AWVALID & AWREADY;
assign w_hs    = WVALID & WREADY;

// wstate
always @(posedge ACLK) begin
    if (ARESET)
        wstate <= WRRESET;
    else if (ACLK_EN)
        wstate <= wnext;
end

// wnext
always @(*) begin
    case (wstate)
        WRIDLE:
            if (AWVALID)
                wnext = WRDATA;
            else
                wnext = WRIDLE;
        WRDATA:
            if (w_hs)
                wnext = WRRESP;
            else
                wnext = WRDATA;
        WRRESP:
            if (BREADY)
                wnext = WRIDLE;
            else
                wnext = WRRESP;
        default:
            wnext = WRIDLE;
    endcase
end

// waddr
always @(posedge ACLK) begin
    if (ACLK_EN) begin
        if (aw_hs)
            waddr <= AWADDR[ADDR_BITS-1:0];
    end
end

//------------------------AXI read fsm-------------------
assign ARREADY = (rstate == RDIDLE);
assign RDATA   = rdata;
assign RRESP   = 2'b00;  // OKAY
assign RVALID  = (rstate == RDDATA) & !int_calibratedStep_read & !int_calibratedOffset_read & !int_OffsetCounts_read & !int_calibratedStepRecip_read;
assign ar_hs   = ARVALID & ARREADY;
assign raddr   = ARADDR[ADDR_BITS-1:0];

// rstate
always @(posedge ACLK) begin
    if (ARESET)
        rstate <= RDRESET;
    else if (ACLK_EN)
        rstate <= rnext;
end

// rnext
always @(*) begin
    case (rstate)
        RDIDLE:
            if (ARVALID)
                rnext = RDDATA;
            else
                rnext = RDIDLE;
        RDDATA:
            if (RREADY & RVALID)
                rnext = RDIDLE;
            else
                rnext = RDDATA;
        default:
            rnext = RDIDLE;
    endcase
end

// rdata
always @(posedge ACLK) begin
    if (ACLK_EN) begin
        if (ar_hs) begin
            rdata <= 'b0;
            case (raddr)
                ADDR_SCALEVALUE_DATA_0: begin
                    rdata <= int_ScaleValue[31:0];
                end
                ADDR_ZEROCROSS_DATA_0: begin
                    rdata <= int_ZeroCross[31:0];
                end
                ADDR_SAMP_INDEX_DATA_0: begin
                    rdata <= int_samp_index[31:0];
                end
                ADDR_ICURRENTFILTER_DATA_0: begin
                    rdata <= int_iCurrentFilter[31:0];
                end
                ADDR_FCLIPVALUE_DATA_0: begin
                    rdata <= int_fClipValue[31:0];
                end
                ADDR_SYNC_RESET_DATA_0: begin
                    rdata <= int_sync_reset[31:0];
                end
                ADDR_ALIGNOFFSET_DATA_0: begin
                    rdata <= int_alignOffset[31:0];
                end
                ADDR_ALIGNOFFSET_CTRL: begin
                    rdata[0] <= int_alignOffset_ap_vld;
                end
                ADDR_COLAENABLE_DATA_0: begin
                    rdata <= int_colaEnable[31:0];
                end
                ADDR_GROUP_DELAY_DATA_0: begin
                    rdata <= int_group_delay[31:0];
                end
                ADDR_LOOP_DELAY_DATA_0: begin
                    rdata <= int_loop_delay[31:0];
                end
                ADDR_DBG_READY_DATA_0: begin
                    rdata <= int_dbg_ready[31:0];
                end
                ADDR_DBG_READY_CTRL: begin
                    rdata[0] <= int_dbg_ready_ap_vld;
                end
            endcase
        end
        else if (int_calibratedStep_read) begin
            rdata <= int_calibratedStep_q1;
        end
        else if (int_calibratedOffset_read) begin
            rdata <= int_calibratedOffset_q1;
        end
        else if (int_OffsetCounts_read) begin
            rdata <= int_OffsetCounts_q1;
        end
        else if (int_calibratedStepRecip_read) begin
            rdata <= int_calibratedStepRecip_q1;
        end
    end
end


//------------------------Register logic-----------------
assign ScaleValue     = int_ScaleValue;
assign ZeroCross      = int_ZeroCross;
assign samp_index     = int_samp_index;
assign iCurrentFilter = int_iCurrentFilter;
assign fClipValue     = int_fClipValue;
assign sync_reset     = int_sync_reset;
assign colaEnable     = int_colaEnable;
assign group_delay    = int_group_delay;
assign loop_delay     = int_loop_delay;
// int_ScaleValue[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_ScaleValue[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_SCALEVALUE_DATA_0)
            int_ScaleValue[31:0] <= (WDATA[31:0] & wmask) | (int_ScaleValue[31:0] & ~wmask);
    end
end

// int_ZeroCross[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_ZeroCross[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_ZEROCROSS_DATA_0)
            int_ZeroCross[31:0] <= (WDATA[31:0] & wmask) | (int_ZeroCross[31:0] & ~wmask);
    end
end

// int_samp_index[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_samp_index[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_SAMP_INDEX_DATA_0)
            int_samp_index[31:0] <= (WDATA[31:0] & wmask) | (int_samp_index[31:0] & ~wmask);
    end
end

// int_iCurrentFilter[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_iCurrentFilter[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_ICURRENTFILTER_DATA_0)
            int_iCurrentFilter[31:0] <= (WDATA[31:0] & wmask) | (int_iCurrentFilter[31:0] & ~wmask);
    end
end

// int_fClipValue[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_fClipValue[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_FCLIPVALUE_DATA_0)
            int_fClipValue[31:0] <= (WDATA[31:0] & wmask) | (int_fClipValue[31:0] & ~wmask);
    end
end

// int_sync_reset[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_sync_reset[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_SYNC_RESET_DATA_0)
            int_sync_reset[31:0] <= (WDATA[31:0] & wmask) | (int_sync_reset[31:0] & ~wmask);
    end
end

// int_alignOffset
always @(posedge ACLK) begin
    if (ARESET)
        int_alignOffset <= 0;
    else if (ACLK_EN) begin
        if (alignOffset_ap_vld)
            int_alignOffset <= alignOffset;
    end
end

// int_alignOffset_ap_vld
always @(posedge ACLK) begin
    if (ARESET)
        int_alignOffset_ap_vld <= 1'b0;
    else if (ACLK_EN) begin
        if (alignOffset_ap_vld)
            int_alignOffset_ap_vld <= 1'b1;
        else if (ar_hs && raddr == ADDR_ALIGNOFFSET_CTRL)
            int_alignOffset_ap_vld <= 1'b0; // clear on read
    end
end

// int_colaEnable[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_colaEnable[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_COLAENABLE_DATA_0)
            int_colaEnable[31:0] <= (WDATA[31:0] & wmask) | (int_colaEnable[31:0] & ~wmask);
    end
end

// int_group_delay[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_group_delay[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_GROUP_DELAY_DATA_0)
            int_group_delay[31:0] <= (WDATA[31:0] & wmask) | (int_group_delay[31:0] & ~wmask);
    end
end

// int_loop_delay[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_loop_delay[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_LOOP_DELAY_DATA_0)
            int_loop_delay[31:0] <= (WDATA[31:0] & wmask) | (int_loop_delay[31:0] & ~wmask);
    end
end

// int_dbg_ready
always @(posedge ACLK) begin
    if (ARESET)
        int_dbg_ready <= 0;
    else if (ACLK_EN) begin
        if (dbg_ready_ap_vld)
            int_dbg_ready <= dbg_ready;
    end
end

// int_dbg_ready_ap_vld
always @(posedge ACLK) begin
    if (ARESET)
        int_dbg_ready_ap_vld <= 1'b0;
    else if (ACLK_EN) begin
        if (dbg_ready_ap_vld)
            int_dbg_ready_ap_vld <= 1'b1;
        else if (ar_hs && raddr == ADDR_DBG_READY_CTRL)
            int_dbg_ready_ap_vld <= 1'b0; // clear on read
    end
end


//------------------------Memory logic-------------------
// calibratedStep
assign int_calibratedStep_address0      = calibratedStep_address0;
assign int_calibratedStep_ce0           = calibratedStep_ce0;
assign calibratedStep_q0                = int_calibratedStep_q0;
assign int_calibratedStep_address1      = ar_hs? raddr[3:2] : waddr[3:2];
assign int_calibratedStep_ce1           = ar_hs | (int_calibratedStep_write & WVALID);
assign int_calibratedStep_we1           = int_calibratedStep_write & w_hs;
assign int_calibratedStep_be1           = int_calibratedStep_we1 ? WSTRB : 'b0;
assign int_calibratedStep_d1            = WDATA;
// calibratedOffset
assign int_calibratedOffset_address0    = calibratedOffset_address0;
assign int_calibratedOffset_ce0         = calibratedOffset_ce0;
assign calibratedOffset_q0              = int_calibratedOffset_q0;
assign int_calibratedOffset_address1    = ar_hs? raddr[3:2] : waddr[3:2];
assign int_calibratedOffset_ce1         = ar_hs | (int_calibratedOffset_write & WVALID);
assign int_calibratedOffset_we1         = int_calibratedOffset_write & w_hs;
assign int_calibratedOffset_be1         = int_calibratedOffset_we1 ? WSTRB : 'b0;
assign int_calibratedOffset_d1          = WDATA;
// OffsetCounts
assign int_OffsetCounts_address0        = OffsetCounts_address0;
assign int_OffsetCounts_ce0             = OffsetCounts_ce0;
assign int_OffsetCounts_address1        = ar_hs? raddr[3:2] : waddr[3:2];
assign int_OffsetCounts_ce1             = ar_hs | (int_OffsetCounts_write & WVALID);
assign int_OffsetCounts_we1             = int_OffsetCounts_write & w_hs;
assign int_OffsetCounts_be1             = int_OffsetCounts_we1 ? WSTRB : 'b0;
assign int_OffsetCounts_d1              = WDATA;
// calibratedStepRecip
assign int_calibratedStepRecip_address0 = calibratedStepRecip_address0;
assign int_calibratedStepRecip_ce0      = calibratedStepRecip_ce0;
assign calibratedStepRecip_q0           = int_calibratedStepRecip_q0;
assign int_calibratedStepRecip_address1 = ar_hs? raddr[3:2] : waddr[3:2];
assign int_calibratedStepRecip_ce1      = ar_hs | (int_calibratedStepRecip_write & WVALID);
assign int_calibratedStepRecip_we1      = int_calibratedStepRecip_write & w_hs;
assign int_calibratedStepRecip_be1      = int_calibratedStepRecip_we1 ? WSTRB : 'b0;
assign int_calibratedStepRecip_d1       = WDATA;
// int_calibratedStep_read
always @(posedge ACLK) begin
    if (ARESET)
        int_calibratedStep_read <= 1'b0;
    else if (ACLK_EN) begin
        if (ar_hs && raddr >= ADDR_CALIBRATEDSTEP_BASE && raddr <= ADDR_CALIBRATEDSTEP_HIGH)
            int_calibratedStep_read <= 1'b1;
        else
            int_calibratedStep_read <= 1'b0;
    end
end

// int_calibratedStep_write
always @(posedge ACLK) begin
    if (ARESET)
        int_calibratedStep_write <= 1'b0;
    else if (ACLK_EN) begin
        if (aw_hs && AWADDR[ADDR_BITS-1:0] >= ADDR_CALIBRATEDSTEP_BASE && AWADDR[ADDR_BITS-1:0] <= ADDR_CALIBRATEDSTEP_HIGH)
            int_calibratedStep_write <= 1'b1;
        else if (w_hs)
            int_calibratedStep_write <= 1'b0;
    end
end

// int_calibratedOffset_read
always @(posedge ACLK) begin
    if (ARESET)
        int_calibratedOffset_read <= 1'b0;
    else if (ACLK_EN) begin
        if (ar_hs && raddr >= ADDR_CALIBRATEDOFFSET_BASE && raddr <= ADDR_CALIBRATEDOFFSET_HIGH)
            int_calibratedOffset_read <= 1'b1;
        else
            int_calibratedOffset_read <= 1'b0;
    end
end

// int_calibratedOffset_write
always @(posedge ACLK) begin
    if (ARESET)
        int_calibratedOffset_write <= 1'b0;
    else if (ACLK_EN) begin
        if (aw_hs && AWADDR[ADDR_BITS-1:0] >= ADDR_CALIBRATEDOFFSET_BASE && AWADDR[ADDR_BITS-1:0] <= ADDR_CALIBRATEDOFFSET_HIGH)
            int_calibratedOffset_write <= 1'b1;
        else if (w_hs)
            int_calibratedOffset_write <= 1'b0;
    end
end

// int_OffsetCounts_read
always @(posedge ACLK) begin
    if (ARESET)
        int_OffsetCounts_read <= 1'b0;
    else if (ACLK_EN) begin
        if (ar_hs && raddr >= ADDR_OFFSETCOUNTS_BASE && raddr <= ADDR_OFFSETCOUNTS_HIGH)
            int_OffsetCounts_read <= 1'b1;
        else
            int_OffsetCounts_read <= 1'b0;
    end
end

// int_OffsetCounts_write
always @(posedge ACLK) begin
    if (ARESET)
        int_OffsetCounts_write <= 1'b0;
    else if (ACLK_EN) begin
        if (aw_hs && AWADDR[ADDR_BITS-1:0] >= ADDR_OFFSETCOUNTS_BASE && AWADDR[ADDR_BITS-1:0] <= ADDR_OFFSETCOUNTS_HIGH)
            int_OffsetCounts_write <= 1'b1;
        else if (w_hs)
            int_OffsetCounts_write <= 1'b0;
    end
end

// int_calibratedStepRecip_read
always @(posedge ACLK) begin
    if (ARESET)
        int_calibratedStepRecip_read <= 1'b0;
    else if (ACLK_EN) begin
        if (ar_hs && raddr >= ADDR_CALIBRATEDSTEPRECIP_BASE && raddr <= ADDR_CALIBRATEDSTEPRECIP_HIGH)
            int_calibratedStepRecip_read <= 1'b1;
        else
            int_calibratedStepRecip_read <= 1'b0;
    end
end

// int_calibratedStepRecip_write
always @(posedge ACLK) begin
    if (ARESET)
        int_calibratedStepRecip_write <= 1'b0;
    else if (ACLK_EN) begin
        if (aw_hs && AWADDR[ADDR_BITS-1:0] >= ADDR_CALIBRATEDSTEPRECIP_BASE && AWADDR[ADDR_BITS-1:0] <= ADDR_CALIBRATEDSTEPRECIP_HIGH)
            int_calibratedStepRecip_write <= 1'b1;
        else if (w_hs)
            int_calibratedStepRecip_write <= 1'b0;
    end
end


endmodule


`timescale 1ns/1ps

module DriveScale_control_s_axi_ram
#(parameter
    MEM_STYLE = "auto",
    MEM_TYPE  = "S2P",
    BYTES  = 4,
    DEPTH  = 256,
    AWIDTH = log2(DEPTH)
) (
    input  wire               clk0,
    input  wire [AWIDTH-1:0]  address0,
    input  wire               ce0,
    input  wire [BYTES-1:0]   we0,
    input  wire [BYTES*8-1:0] d0,
    output reg  [BYTES*8-1:0] q0,
    input  wire               clk1,
    input  wire [AWIDTH-1:0]  address1,
    input  wire               ce1,
    input  wire [BYTES-1:0]   we1,
    input  wire [BYTES*8-1:0] d1,
    output reg  [BYTES*8-1:0] q1
);
//------------------------ Parameters -------------------
localparam
    BYTE_WIDTH = 8,
    PORT0 = (MEM_TYPE == "S2P") ? "WO" : ((MEM_TYPE == "2P") ? "RO" : "RW"),
    PORT1 = (MEM_TYPE == "S2P") ? "RO" : "RW";
//------------------------Local signal-------------------
(* ram_style = MEM_STYLE*)
reg  [BYTES*8-1:0] mem[0:DEPTH-1];
wire re0, re1;
//------------------------Task and function--------------
function integer log2;
    input integer x;
    integer n, m;
begin
    n = 1;
    m = 2;
    while (m < x) begin
        n = n + 1;
        m = m * 2;
    end
    log2 = n;
end
endfunction
//------------------------Body---------------------------
generate
    if (MEM_STYLE == "hls_ultra" && PORT0 == "RW") begin
        assign re0 = ce0 & ~|we0;
    end else begin
        assign re0 = ce0;
    end
endgenerate

generate
    if (MEM_STYLE == "hls_ultra" && PORT1 == "RW") begin
        assign re1 = ce1 & ~|we1;
    end else begin
        assign re1 = ce1;
    end
endgenerate

// read port 0
generate if (PORT0 != "WO") begin
    always @(posedge clk0) begin
        if (re0) q0 <= mem[address0];
    end
end
endgenerate

// read port 1
generate if (PORT1 != "WO") begin
    always @(posedge clk1) begin
        if (re1) q1 <= mem[address1];
    end
end
endgenerate

integer i;
// write port 0
generate if (PORT0 != "RO") begin
    always @(posedge clk0) begin
        if (ce0)
        for (i = 0; i < BYTES; i = i + 1)
            if (we0[i])
                mem[address0][i*BYTE_WIDTH +: BYTE_WIDTH] <= d0[i*BYTE_WIDTH +: BYTE_WIDTH];
    end
end
endgenerate

// write port 1
generate if (PORT1 != "RO") begin
    always @(posedge clk1) begin
        if (ce1)
        for (i = 0; i < BYTES; i = i + 1)
            if (we1[i])
                mem[address1][i*BYTE_WIDTH +: BYTE_WIDTH] <= d1[i*BYTE_WIDTH +: BYTE_WIDTH];
    end
end
endgenerate

endmodule

