// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.10
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
`timescale 1ns/1ps
module ADCCountsToFloat8_control_s_axi
#(parameter
    C_S_AXI_ADDR_WIDTH = 10,
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
    output wire [31:0]                   reset,
    output wire [31:0]                   pointOffset,
    input  wire [2:0]                    iCurrentRange_address0,
    input  wire                          iCurrentRange_ce0,
    output wire [31:0]                   iCurrentRange_q0,
    input  wire [2:0]                    iOverloadCount_address0,
    input  wire                          iOverloadCount_ce0,
    input  wire                          iOverloadCount_we0,
    input  wire [31:0]                   iOverloadCount_d0,
    input  wire [2:0]                    OLValid_address0,
    input  wire                          OLValid_ce0,
    input  wire                          OLValid_we0,
    input  wire [31:0]                   OLValid_d0,
    input  wire [2:0]                    gainChanged_address0,
    input  wire                          gainChanged_ce0,
    input  wire                          gainChanged_we0,
    input  wire [31:0]                   gainChanged_d0,
    input  wire [2:0]                    status_address0,
    input  wire                          status_ce0,
    input  wire                          status_we0,
    input  wire [31:0]                   status_d0,
    input  wire [5:0]                    cal_step_address0,
    input  wire                          cal_step_ce0,
    output wire [31:0]                   cal_step_q0,
    input  wire [5:0]                    cal_offset_address0,
    input  wire                          cal_offset_ce0,
    output wire [31:0]                   cal_offset_q0
);
//------------------------Address Info-------------------
// Protocol Used: ap_ctrl_none
//
// 0x000 : reserved
// 0x004 : reserved
// 0x008 : reserved
// 0x00c : reserved
// 0x010 : Data signal of reset
//         bit 31~0 - reset[31:0] (Read/Write)
// 0x014 : reserved
// 0x018 : Data signal of pointOffset
//         bit 31~0 - pointOffset[31:0] (Read/Write)
// 0x01c : reserved
// 0x020 ~
// 0x03f : Memory 'iCurrentRange' (8 * 32b)
//         Word n : bit [31:0] - iCurrentRange[n]
// 0x040 ~
// 0x05f : Memory 'iOverloadCount' (8 * 32b)
//         Word n : bit [31:0] - iOverloadCount[n]
// 0x060 ~
// 0x07f : Memory 'OLValid' (8 * 32b)
//         Word n : bit [31:0] - OLValid[n]
// 0x080 ~
// 0x09f : Memory 'gainChanged' (8 * 32b)
//         Word n : bit [31:0] - gainChanged[n]
// 0x0a0 ~
// 0x0bf : Memory 'status' (8 * 32b)
//         Word n : bit [31:0] - status[n]
// 0x100 ~
// 0x1ff : Memory 'cal_step' (64 * 32b)
//         Word n : bit [31:0] - cal_step[n]
// 0x200 ~
// 0x2ff : Memory 'cal_offset' (64 * 32b)
//         Word n : bit [31:0] - cal_offset[n]
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

//------------------------Parameter----------------------
localparam
    ADDR_RESET_DATA_0        = 10'h010,
    ADDR_RESET_CTRL          = 10'h014,
    ADDR_POINTOFFSET_DATA_0  = 10'h018,
    ADDR_POINTOFFSET_CTRL    = 10'h01c,
    ADDR_ICURRENTRANGE_BASE  = 10'h020,
    ADDR_ICURRENTRANGE_HIGH  = 10'h03f,
    ADDR_IOVERLOADCOUNT_BASE = 10'h040,
    ADDR_IOVERLOADCOUNT_HIGH = 10'h05f,
    ADDR_OLVALID_BASE        = 10'h060,
    ADDR_OLVALID_HIGH        = 10'h07f,
    ADDR_GAINCHANGED_BASE    = 10'h080,
    ADDR_GAINCHANGED_HIGH    = 10'h09f,
    ADDR_STATUS_BASE         = 10'h0a0,
    ADDR_STATUS_HIGH         = 10'h0bf,
    ADDR_CAL_STEP_BASE       = 10'h100,
    ADDR_CAL_STEP_HIGH       = 10'h1ff,
    ADDR_CAL_OFFSET_BASE     = 10'h200,
    ADDR_CAL_OFFSET_HIGH     = 10'h2ff,
    WRIDLE                   = 2'd0,
    WRDATA                   = 2'd1,
    WRRESP                   = 2'd2,
    WRRESET                  = 2'd3,
    RDIDLE                   = 2'd0,
    RDDATA                   = 2'd1,
    RDRESET                  = 2'd2,
    ADDR_BITS                = 10;

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
    reg  [31:0]                   int_reset = 'b0;
    reg  [31:0]                   int_pointOffset = 'b0;
    // memory signals
    wire [2:0]                    int_iCurrentRange_address0;
    wire                          int_iCurrentRange_ce0;
    wire [31:0]                   int_iCurrentRange_q0;
    wire [2:0]                    int_iCurrentRange_address1;
    wire                          int_iCurrentRange_ce1;
    wire                          int_iCurrentRange_we1;
    wire [3:0]                    int_iCurrentRange_be1;
    wire [31:0]                   int_iCurrentRange_d1;
    wire [31:0]                   int_iCurrentRange_q1;
    reg                           int_iCurrentRange_read;
    reg                           int_iCurrentRange_write;
    wire [2:0]                    int_iOverloadCount_address0;
    wire                          int_iOverloadCount_ce0;
    wire [3:0]                    int_iOverloadCount_be0;
    wire [31:0]                   int_iOverloadCount_d0;
    wire [2:0]                    int_iOverloadCount_address1;
    wire                          int_iOverloadCount_ce1;
    wire [31:0]                   int_iOverloadCount_q1;
    reg                           int_iOverloadCount_read;
    reg                           int_iOverloadCount_write;
    wire [2:0]                    int_OLValid_address0;
    wire                          int_OLValid_ce0;
    wire [3:0]                    int_OLValid_be0;
    wire [31:0]                   int_OLValid_d0;
    wire [2:0]                    int_OLValid_address1;
    wire                          int_OLValid_ce1;
    wire [31:0]                   int_OLValid_q1;
    reg                           int_OLValid_read;
    reg                           int_OLValid_write;
    wire [2:0]                    int_gainChanged_address0;
    wire                          int_gainChanged_ce0;
    wire [3:0]                    int_gainChanged_be0;
    wire [31:0]                   int_gainChanged_d0;
    wire [2:0]                    int_gainChanged_address1;
    wire                          int_gainChanged_ce1;
    wire [31:0]                   int_gainChanged_q1;
    reg                           int_gainChanged_read;
    reg                           int_gainChanged_write;
    wire [2:0]                    int_status_address0;
    wire                          int_status_ce0;
    wire [3:0]                    int_status_be0;
    wire [31:0]                   int_status_d0;
    wire [2:0]                    int_status_address1;
    wire                          int_status_ce1;
    wire [31:0]                   int_status_q1;
    reg                           int_status_read;
    reg                           int_status_write;
    wire [5:0]                    int_cal_step_address0;
    wire                          int_cal_step_ce0;
    wire [31:0]                   int_cal_step_q0;
    wire [5:0]                    int_cal_step_address1;
    wire                          int_cal_step_ce1;
    wire                          int_cal_step_we1;
    wire [3:0]                    int_cal_step_be1;
    wire [31:0]                   int_cal_step_d1;
    wire [31:0]                   int_cal_step_q1;
    reg                           int_cal_step_read;
    reg                           int_cal_step_write;
    wire [5:0]                    int_cal_offset_address0;
    wire                          int_cal_offset_ce0;
    wire [31:0]                   int_cal_offset_q0;
    wire [5:0]                    int_cal_offset_address1;
    wire                          int_cal_offset_ce1;
    wire                          int_cal_offset_we1;
    wire [3:0]                    int_cal_offset_be1;
    wire [31:0]                   int_cal_offset_d1;
    wire [31:0]                   int_cal_offset_q1;
    reg                           int_cal_offset_read;
    reg                           int_cal_offset_write;

//------------------------Instantiation------------------
// int_iCurrentRange
ADCCountsToFloat8_control_s_axi_ram #(
    .MEM_STYLE ( "auto" ),
    .MEM_TYPE  ( "2P" ),
    .BYTES     ( 4 ),
    .DEPTH     ( 8 )
) int_iCurrentRange (
    .clk0      ( ACLK ),
    .address0  ( int_iCurrentRange_address0 ),
    .ce0       ( int_iCurrentRange_ce0 ),
    .we0       ( {4{1'b0}} ),
    .d0        ( {32{1'b0}} ),
    .q0        ( int_iCurrentRange_q0 ),
    .clk1      ( ACLK ),
    .address1  ( int_iCurrentRange_address1 ),
    .ce1       ( int_iCurrentRange_ce1 ),
    .we1       ( int_iCurrentRange_be1 ),
    .d1        ( int_iCurrentRange_d1 ),
    .q1        ( int_iCurrentRange_q1 )
);
// int_iOverloadCount
ADCCountsToFloat8_control_s_axi_ram #(
    .MEM_STYLE ( "auto" ),
    .MEM_TYPE  ( "S2P" ),
    .BYTES     ( 4 ),
    .DEPTH     ( 8 )
) int_iOverloadCount (
    .clk0      ( ACLK ),
    .address0  ( int_iOverloadCount_address0 ),
    .ce0       ( int_iOverloadCount_ce0 ),
    .we0       ( int_iOverloadCount_be0 ),
    .d0        ( int_iOverloadCount_d0 ),
    .q0        (  ),
    .clk1      ( ACLK ),
    .address1  ( int_iOverloadCount_address1 ),
    .ce1       ( int_iOverloadCount_ce1 ),
    .we1       ( {4{1'b0}} ),
    .d1        ( {32{1'b0}} ),
    .q1        ( int_iOverloadCount_q1 )
);
// int_OLValid
ADCCountsToFloat8_control_s_axi_ram #(
    .MEM_STYLE ( "auto" ),
    .MEM_TYPE  ( "S2P" ),
    .BYTES     ( 4 ),
    .DEPTH     ( 8 )
) int_OLValid (
    .clk0      ( ACLK ),
    .address0  ( int_OLValid_address0 ),
    .ce0       ( int_OLValid_ce0 ),
    .we0       ( int_OLValid_be0 ),
    .d0        ( int_OLValid_d0 ),
    .q0        (  ),
    .clk1      ( ACLK ),
    .address1  ( int_OLValid_address1 ),
    .ce1       ( int_OLValid_ce1 ),
    .we1       ( {4{1'b0}} ),
    .d1        ( {32{1'b0}} ),
    .q1        ( int_OLValid_q1 )
);
// int_gainChanged
ADCCountsToFloat8_control_s_axi_ram #(
    .MEM_STYLE ( "auto" ),
    .MEM_TYPE  ( "S2P" ),
    .BYTES     ( 4 ),
    .DEPTH     ( 8 )
) int_gainChanged (
    .clk0      ( ACLK ),
    .address0  ( int_gainChanged_address0 ),
    .ce0       ( int_gainChanged_ce0 ),
    .we0       ( int_gainChanged_be0 ),
    .d0        ( int_gainChanged_d0 ),
    .q0        (  ),
    .clk1      ( ACLK ),
    .address1  ( int_gainChanged_address1 ),
    .ce1       ( int_gainChanged_ce1 ),
    .we1       ( {4{1'b0}} ),
    .d1        ( {32{1'b0}} ),
    .q1        ( int_gainChanged_q1 )
);
// int_status
ADCCountsToFloat8_control_s_axi_ram #(
    .MEM_STYLE ( "auto" ),
    .MEM_TYPE  ( "S2P" ),
    .BYTES     ( 4 ),
    .DEPTH     ( 8 )
) int_status (
    .clk0      ( ACLK ),
    .address0  ( int_status_address0 ),
    .ce0       ( int_status_ce0 ),
    .we0       ( int_status_be0 ),
    .d0        ( int_status_d0 ),
    .q0        (  ),
    .clk1      ( ACLK ),
    .address1  ( int_status_address1 ),
    .ce1       ( int_status_ce1 ),
    .we1       ( {4{1'b0}} ),
    .d1        ( {32{1'b0}} ),
    .q1        ( int_status_q1 )
);
// int_cal_step
ADCCountsToFloat8_control_s_axi_ram #(
    .MEM_STYLE ( "auto" ),
    .MEM_TYPE  ( "2P" ),
    .BYTES     ( 4 ),
    .DEPTH     ( 64 )
) int_cal_step (
    .clk0      ( ACLK ),
    .address0  ( int_cal_step_address0 ),
    .ce0       ( int_cal_step_ce0 ),
    .we0       ( {4{1'b0}} ),
    .d0        ( {32{1'b0}} ),
    .q0        ( int_cal_step_q0 ),
    .clk1      ( ACLK ),
    .address1  ( int_cal_step_address1 ),
    .ce1       ( int_cal_step_ce1 ),
    .we1       ( int_cal_step_be1 ),
    .d1        ( int_cal_step_d1 ),
    .q1        ( int_cal_step_q1 )
);
// int_cal_offset
ADCCountsToFloat8_control_s_axi_ram #(
    .MEM_STYLE ( "auto" ),
    .MEM_TYPE  ( "2P" ),
    .BYTES     ( 4 ),
    .DEPTH     ( 64 )
) int_cal_offset (
    .clk0      ( ACLK ),
    .address0  ( int_cal_offset_address0 ),
    .ce0       ( int_cal_offset_ce0 ),
    .we0       ( {4{1'b0}} ),
    .d0        ( {32{1'b0}} ),
    .q0        ( int_cal_offset_q0 ),
    .clk1      ( ACLK ),
    .address1  ( int_cal_offset_address1 ),
    .ce1       ( int_cal_offset_ce1 ),
    .we1       ( int_cal_offset_be1 ),
    .d1        ( int_cal_offset_d1 ),
    .q1        ( int_cal_offset_q1 )
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
assign RVALID  = (rstate == RDDATA) & !int_iCurrentRange_read & !int_iOverloadCount_read & !int_OLValid_read & !int_gainChanged_read & !int_status_read & !int_cal_step_read & !int_cal_offset_read;
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
                ADDR_RESET_DATA_0: begin
                    rdata <= int_reset[31:0];
                end
                ADDR_POINTOFFSET_DATA_0: begin
                    rdata <= int_pointOffset[31:0];
                end
            endcase
        end
        else if (int_iCurrentRange_read) begin
            rdata <= int_iCurrentRange_q1;
        end
        else if (int_iOverloadCount_read) begin
            rdata <= int_iOverloadCount_q1;
        end
        else if (int_OLValid_read) begin
            rdata <= int_OLValid_q1;
        end
        else if (int_gainChanged_read) begin
            rdata <= int_gainChanged_q1;
        end
        else if (int_status_read) begin
            rdata <= int_status_q1;
        end
        else if (int_cal_step_read) begin
            rdata <= int_cal_step_q1;
        end
        else if (int_cal_offset_read) begin
            rdata <= int_cal_offset_q1;
        end
    end
end


//------------------------Register logic-----------------
assign reset       = int_reset;
assign pointOffset = int_pointOffset;
// int_reset[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_reset[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_RESET_DATA_0)
            int_reset[31:0] <= (WDATA[31:0] & wmask) | (int_reset[31:0] & ~wmask);
    end
end

// int_pointOffset[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_pointOffset[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_POINTOFFSET_DATA_0)
            int_pointOffset[31:0] <= (WDATA[31:0] & wmask) | (int_pointOffset[31:0] & ~wmask);
    end
end


//------------------------Memory logic-------------------
// iCurrentRange
assign int_iCurrentRange_address0  = iCurrentRange_address0;
assign int_iCurrentRange_ce0       = iCurrentRange_ce0;
assign iCurrentRange_q0            = int_iCurrentRange_q0;
assign int_iCurrentRange_address1  = ar_hs? raddr[4:2] : waddr[4:2];
assign int_iCurrentRange_ce1       = ar_hs | (int_iCurrentRange_write & WVALID);
assign int_iCurrentRange_we1       = int_iCurrentRange_write & w_hs;
assign int_iCurrentRange_be1       = int_iCurrentRange_we1 ? WSTRB : 'b0;
assign int_iCurrentRange_d1        = WDATA;
// iOverloadCount
assign int_iOverloadCount_address0 = iOverloadCount_address0;
assign int_iOverloadCount_ce0      = iOverloadCount_ce0;
assign int_iOverloadCount_be0      = {4{iOverloadCount_we0}};
assign int_iOverloadCount_d0       = iOverloadCount_d0;
assign int_iOverloadCount_address1 = ar_hs? raddr[4:2] : waddr[4:2];
assign int_iOverloadCount_ce1      = ar_hs | (int_iOverloadCount_write & WVALID);
// OLValid
assign int_OLValid_address0        = OLValid_address0;
assign int_OLValid_ce0             = OLValid_ce0;
assign int_OLValid_be0             = {4{OLValid_we0}};
assign int_OLValid_d0              = OLValid_d0;
assign int_OLValid_address1        = ar_hs? raddr[4:2] : waddr[4:2];
assign int_OLValid_ce1             = ar_hs | (int_OLValid_write & WVALID);
// gainChanged
assign int_gainChanged_address0    = gainChanged_address0;
assign int_gainChanged_ce0         = gainChanged_ce0;
assign int_gainChanged_be0         = {4{gainChanged_we0}};
assign int_gainChanged_d0          = gainChanged_d0;
assign int_gainChanged_address1    = ar_hs? raddr[4:2] : waddr[4:2];
assign int_gainChanged_ce1         = ar_hs | (int_gainChanged_write & WVALID);
// status
assign int_status_address0         = status_address0;
assign int_status_ce0              = status_ce0;
assign int_status_be0              = {4{status_we0}};
assign int_status_d0               = status_d0;
assign int_status_address1         = ar_hs? raddr[4:2] : waddr[4:2];
assign int_status_ce1              = ar_hs | (int_status_write & WVALID);
// cal_step
assign int_cal_step_address0       = cal_step_address0;
assign int_cal_step_ce0            = cal_step_ce0;
assign cal_step_q0                 = int_cal_step_q0;
assign int_cal_step_address1       = ar_hs? raddr[7:2] : waddr[7:2];
assign int_cal_step_ce1            = ar_hs | (int_cal_step_write & WVALID);
assign int_cal_step_we1            = int_cal_step_write & w_hs;
assign int_cal_step_be1            = int_cal_step_we1 ? WSTRB : 'b0;
assign int_cal_step_d1             = WDATA;
// cal_offset
assign int_cal_offset_address0     = cal_offset_address0;
assign int_cal_offset_ce0          = cal_offset_ce0;
assign cal_offset_q0               = int_cal_offset_q0;
assign int_cal_offset_address1     = ar_hs? raddr[7:2] : waddr[7:2];
assign int_cal_offset_ce1          = ar_hs | (int_cal_offset_write & WVALID);
assign int_cal_offset_we1          = int_cal_offset_write & w_hs;
assign int_cal_offset_be1          = int_cal_offset_we1 ? WSTRB : 'b0;
assign int_cal_offset_d1           = WDATA;
// int_iCurrentRange_read
always @(posedge ACLK) begin
    if (ARESET)
        int_iCurrentRange_read <= 1'b0;
    else if (ACLK_EN) begin
        if (ar_hs && raddr >= ADDR_ICURRENTRANGE_BASE && raddr <= ADDR_ICURRENTRANGE_HIGH)
            int_iCurrentRange_read <= 1'b1;
        else
            int_iCurrentRange_read <= 1'b0;
    end
end

// int_iCurrentRange_write
always @(posedge ACLK) begin
    if (ARESET)
        int_iCurrentRange_write <= 1'b0;
    else if (ACLK_EN) begin
        if (aw_hs && AWADDR[ADDR_BITS-1:0] >= ADDR_ICURRENTRANGE_BASE && AWADDR[ADDR_BITS-1:0] <= ADDR_ICURRENTRANGE_HIGH)
            int_iCurrentRange_write <= 1'b1;
        else if (w_hs)
            int_iCurrentRange_write <= 1'b0;
    end
end

// int_iOverloadCount_read
always @(posedge ACLK) begin
    if (ARESET)
        int_iOverloadCount_read <= 1'b0;
    else if (ACLK_EN) begin
        if (ar_hs && raddr >= ADDR_IOVERLOADCOUNT_BASE && raddr <= ADDR_IOVERLOADCOUNT_HIGH)
            int_iOverloadCount_read <= 1'b1;
        else
            int_iOverloadCount_read <= 1'b0;
    end
end

// int_OLValid_read
always @(posedge ACLK) begin
    if (ARESET)
        int_OLValid_read <= 1'b0;
    else if (ACLK_EN) begin
        if (ar_hs && raddr >= ADDR_OLVALID_BASE && raddr <= ADDR_OLVALID_HIGH)
            int_OLValid_read <= 1'b1;
        else
            int_OLValid_read <= 1'b0;
    end
end

// int_gainChanged_read
always @(posedge ACLK) begin
    if (ARESET)
        int_gainChanged_read <= 1'b0;
    else if (ACLK_EN) begin
        if (ar_hs && raddr >= ADDR_GAINCHANGED_BASE && raddr <= ADDR_GAINCHANGED_HIGH)
            int_gainChanged_read <= 1'b1;
        else
            int_gainChanged_read <= 1'b0;
    end
end

// int_status_read
always @(posedge ACLK) begin
    if (ARESET)
        int_status_read <= 1'b0;
    else if (ACLK_EN) begin
        if (ar_hs && raddr >= ADDR_STATUS_BASE && raddr <= ADDR_STATUS_HIGH)
            int_status_read <= 1'b1;
        else
            int_status_read <= 1'b0;
    end
end

// int_cal_step_read
always @(posedge ACLK) begin
    if (ARESET)
        int_cal_step_read <= 1'b0;
    else if (ACLK_EN) begin
        if (ar_hs && raddr >= ADDR_CAL_STEP_BASE && raddr <= ADDR_CAL_STEP_HIGH)
            int_cal_step_read <= 1'b1;
        else
            int_cal_step_read <= 1'b0;
    end
end

// int_cal_step_write
always @(posedge ACLK) begin
    if (ARESET)
        int_cal_step_write <= 1'b0;
    else if (ACLK_EN) begin
        if (aw_hs && AWADDR[ADDR_BITS-1:0] >= ADDR_CAL_STEP_BASE && AWADDR[ADDR_BITS-1:0] <= ADDR_CAL_STEP_HIGH)
            int_cal_step_write <= 1'b1;
        else if (w_hs)
            int_cal_step_write <= 1'b0;
    end
end

// int_cal_offset_read
always @(posedge ACLK) begin
    if (ARESET)
        int_cal_offset_read <= 1'b0;
    else if (ACLK_EN) begin
        if (ar_hs && raddr >= ADDR_CAL_OFFSET_BASE && raddr <= ADDR_CAL_OFFSET_HIGH)
            int_cal_offset_read <= 1'b1;
        else
            int_cal_offset_read <= 1'b0;
    end
end

// int_cal_offset_write
always @(posedge ACLK) begin
    if (ARESET)
        int_cal_offset_write <= 1'b0;
    else if (ACLK_EN) begin
        if (aw_hs && AWADDR[ADDR_BITS-1:0] >= ADDR_CAL_OFFSET_BASE && AWADDR[ADDR_BITS-1:0] <= ADDR_CAL_OFFSET_HIGH)
            int_cal_offset_write <= 1'b1;
        else if (w_hs)
            int_cal_offset_write <= 1'b0;
    end
end


endmodule


`timescale 1ns/1ps

module ADCCountsToFloat8_control_s_axi_ram
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

