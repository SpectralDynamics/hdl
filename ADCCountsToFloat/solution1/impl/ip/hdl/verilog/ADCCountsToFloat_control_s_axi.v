// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.10
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
`timescale 1ns/1ps
module ADCCountsToFloat_control_s_axi
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
    output wire [31:0]                   iCurrentRange,
    output wire [31:0]                   reset,
    input  wire [2:0]                    cal_step_address0,
    input  wire                          cal_step_ce0,
    output wire [31:0]                   cal_step_q0,
    input  wire [2:0]                    cal_offset_address0,
    input  wire                          cal_offset_ce0,
    output wire [31:0]                   cal_offset_q0,
    input  wire [31:0]                   iOverloadCount,
    input  wire                          iOverloadCount_ap_vld,
    input  wire [31:0]                   OLValid,
    input  wire                          OLValid_ap_vld,
    output wire [31:0]                   pointOffset,
    input  wire [31:0]                   gainChanged,
    input  wire                          gainChanged_ap_vld,
    input  wire [31:0]                   status,
    input  wire                          status_ap_vld
);
//------------------------Address Info-------------------
// Protocol Used: ap_ctrl_none
//
// 0x00 : reserved
// 0x04 : reserved
// 0x08 : reserved
// 0x0c : reserved
// 0x10 : Data signal of iCurrentRange
//        bit 31~0 - iCurrentRange[31:0] (Read/Write)
// 0x14 : reserved
// 0x18 : Data signal of reset
//        bit 31~0 - reset[31:0] (Read/Write)
// 0x1c : reserved
// 0x60 : Data signal of iOverloadCount
//        bit 31~0 - iOverloadCount[31:0] (Read)
// 0x64 : Control signal of iOverloadCount
//        bit 0  - iOverloadCount_ap_vld (Read/COR)
//        others - reserved
// 0x70 : Data signal of OLValid
//        bit 31~0 - OLValid[31:0] (Read)
// 0x74 : Control signal of OLValid
//        bit 0  - OLValid_ap_vld (Read/COR)
//        others - reserved
// 0x80 : Data signal of pointOffset
//        bit 31~0 - pointOffset[31:0] (Read/Write)
// 0x84 : reserved
// 0x88 : Data signal of gainChanged
//        bit 31~0 - gainChanged[31:0] (Read)
// 0x8c : Control signal of gainChanged
//        bit 0  - gainChanged_ap_vld (Read/COR)
//        others - reserved
// 0x98 : Data signal of status
//        bit 31~0 - status[31:0] (Read)
// 0x9c : Control signal of status
//        bit 0  - status_ap_vld (Read/COR)
//        others - reserved
// 0x20 ~
// 0x3f : Memory 'cal_step' (8 * 32b)
//        Word n : bit [31:0] - cal_step[n]
// 0x40 ~
// 0x5f : Memory 'cal_offset' (8 * 32b)
//        Word n : bit [31:0] - cal_offset[n]
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

//------------------------Parameter----------------------
localparam
    ADDR_ICURRENTRANGE_DATA_0  = 8'h10,
    ADDR_ICURRENTRANGE_CTRL    = 8'h14,
    ADDR_RESET_DATA_0          = 8'h18,
    ADDR_RESET_CTRL            = 8'h1c,
    ADDR_IOVERLOADCOUNT_DATA_0 = 8'h60,
    ADDR_IOVERLOADCOUNT_CTRL   = 8'h64,
    ADDR_OLVALID_DATA_0        = 8'h70,
    ADDR_OLVALID_CTRL          = 8'h74,
    ADDR_POINTOFFSET_DATA_0    = 8'h80,
    ADDR_POINTOFFSET_CTRL      = 8'h84,
    ADDR_GAINCHANGED_DATA_0    = 8'h88,
    ADDR_GAINCHANGED_CTRL      = 8'h8c,
    ADDR_STATUS_DATA_0         = 8'h98,
    ADDR_STATUS_CTRL           = 8'h9c,
    ADDR_CAL_STEP_BASE         = 8'h20,
    ADDR_CAL_STEP_HIGH         = 8'h3f,
    ADDR_CAL_OFFSET_BASE       = 8'h40,
    ADDR_CAL_OFFSET_HIGH       = 8'h5f,
    WRIDLE                     = 2'd0,
    WRDATA                     = 2'd1,
    WRRESP                     = 2'd2,
    WRRESET                    = 2'd3,
    RDIDLE                     = 2'd0,
    RDDATA                     = 2'd1,
    RDRESET                    = 2'd2,
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
    reg  [31:0]                   int_iCurrentRange = 'b0;
    reg  [31:0]                   int_reset = 'b0;
    reg                           int_iOverloadCount_ap_vld;
    reg  [31:0]                   int_iOverloadCount = 'b0;
    reg                           int_OLValid_ap_vld;
    reg  [31:0]                   int_OLValid = 'b0;
    reg  [31:0]                   int_pointOffset = 'b0;
    reg                           int_gainChanged_ap_vld;
    reg  [31:0]                   int_gainChanged = 'b0;
    reg                           int_status_ap_vld;
    reg  [31:0]                   int_status = 'b0;
    // memory signals
    wire [2:0]                    int_cal_step_address0;
    wire                          int_cal_step_ce0;
    wire [31:0]                   int_cal_step_q0;
    wire [2:0]                    int_cal_step_address1;
    wire                          int_cal_step_ce1;
    wire                          int_cal_step_we1;
    wire [3:0]                    int_cal_step_be1;
    wire [31:0]                   int_cal_step_d1;
    wire [31:0]                   int_cal_step_q1;
    reg                           int_cal_step_read;
    reg                           int_cal_step_write;
    wire [2:0]                    int_cal_offset_address0;
    wire                          int_cal_offset_ce0;
    wire [31:0]                   int_cal_offset_q0;
    wire [2:0]                    int_cal_offset_address1;
    wire                          int_cal_offset_ce1;
    wire                          int_cal_offset_we1;
    wire [3:0]                    int_cal_offset_be1;
    wire [31:0]                   int_cal_offset_d1;
    wire [31:0]                   int_cal_offset_q1;
    reg                           int_cal_offset_read;
    reg                           int_cal_offset_write;

//------------------------Instantiation------------------
// int_cal_step
ADCCountsToFloat_control_s_axi_ram #(
    .MEM_STYLE ( "auto" ),
    .MEM_TYPE  ( "2P" ),
    .BYTES     ( 4 ),
    .DEPTH     ( 8 )
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
ADCCountsToFloat_control_s_axi_ram #(
    .MEM_STYLE ( "auto" ),
    .MEM_TYPE  ( "2P" ),
    .BYTES     ( 4 ),
    .DEPTH     ( 8 )
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
assign RVALID  = (rstate == RDDATA) & !int_cal_step_read & !int_cal_offset_read;
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
                ADDR_ICURRENTRANGE_DATA_0: begin
                    rdata <= int_iCurrentRange[31:0];
                end
                ADDR_RESET_DATA_0: begin
                    rdata <= int_reset[31:0];
                end
                ADDR_IOVERLOADCOUNT_DATA_0: begin
                    rdata <= int_iOverloadCount[31:0];
                end
                ADDR_IOVERLOADCOUNT_CTRL: begin
                    rdata[0] <= int_iOverloadCount_ap_vld;
                end
                ADDR_OLVALID_DATA_0: begin
                    rdata <= int_OLValid[31:0];
                end
                ADDR_OLVALID_CTRL: begin
                    rdata[0] <= int_OLValid_ap_vld;
                end
                ADDR_POINTOFFSET_DATA_0: begin
                    rdata <= int_pointOffset[31:0];
                end
                ADDR_GAINCHANGED_DATA_0: begin
                    rdata <= int_gainChanged[31:0];
                end
                ADDR_GAINCHANGED_CTRL: begin
                    rdata[0] <= int_gainChanged_ap_vld;
                end
                ADDR_STATUS_DATA_0: begin
                    rdata <= int_status[31:0];
                end
                ADDR_STATUS_CTRL: begin
                    rdata[0] <= int_status_ap_vld;
                end
            endcase
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
assign iCurrentRange = int_iCurrentRange;
assign reset         = int_reset;
assign pointOffset   = int_pointOffset;
// int_iCurrentRange[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_iCurrentRange[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_ICURRENTRANGE_DATA_0)
            int_iCurrentRange[31:0] <= (WDATA[31:0] & wmask) | (int_iCurrentRange[31:0] & ~wmask);
    end
end

// int_reset[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_reset[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_RESET_DATA_0)
            int_reset[31:0] <= (WDATA[31:0] & wmask) | (int_reset[31:0] & ~wmask);
    end
end

// int_iOverloadCount
always @(posedge ACLK) begin
    if (ARESET)
        int_iOverloadCount <= 0;
    else if (ACLK_EN) begin
        if (iOverloadCount_ap_vld)
            int_iOverloadCount <= iOverloadCount;
    end
end

// int_iOverloadCount_ap_vld
always @(posedge ACLK) begin
    if (ARESET)
        int_iOverloadCount_ap_vld <= 1'b0;
    else if (ACLK_EN) begin
        if (iOverloadCount_ap_vld)
            int_iOverloadCount_ap_vld <= 1'b1;
        else if (ar_hs && raddr == ADDR_IOVERLOADCOUNT_CTRL)
            int_iOverloadCount_ap_vld <= 1'b0; // clear on read
    end
end

// int_OLValid
always @(posedge ACLK) begin
    if (ARESET)
        int_OLValid <= 0;
    else if (ACLK_EN) begin
        if (OLValid_ap_vld)
            int_OLValid <= OLValid;
    end
end

// int_OLValid_ap_vld
always @(posedge ACLK) begin
    if (ARESET)
        int_OLValid_ap_vld <= 1'b0;
    else if (ACLK_EN) begin
        if (OLValid_ap_vld)
            int_OLValid_ap_vld <= 1'b1;
        else if (ar_hs && raddr == ADDR_OLVALID_CTRL)
            int_OLValid_ap_vld <= 1'b0; // clear on read
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

// int_gainChanged
always @(posedge ACLK) begin
    if (ARESET)
        int_gainChanged <= 0;
    else if (ACLK_EN) begin
        if (gainChanged_ap_vld)
            int_gainChanged <= gainChanged;
    end
end

// int_gainChanged_ap_vld
always @(posedge ACLK) begin
    if (ARESET)
        int_gainChanged_ap_vld <= 1'b0;
    else if (ACLK_EN) begin
        if (gainChanged_ap_vld)
            int_gainChanged_ap_vld <= 1'b1;
        else if (ar_hs && raddr == ADDR_GAINCHANGED_CTRL)
            int_gainChanged_ap_vld <= 1'b0; // clear on read
    end
end

// int_status
always @(posedge ACLK) begin
    if (ARESET)
        int_status <= 0;
    else if (ACLK_EN) begin
        if (status_ap_vld)
            int_status <= status;
    end
end

// int_status_ap_vld
always @(posedge ACLK) begin
    if (ARESET)
        int_status_ap_vld <= 1'b0;
    else if (ACLK_EN) begin
        if (status_ap_vld)
            int_status_ap_vld <= 1'b1;
        else if (ar_hs && raddr == ADDR_STATUS_CTRL)
            int_status_ap_vld <= 1'b0; // clear on read
    end
end


//------------------------Memory logic-------------------
// cal_step
assign int_cal_step_address0   = cal_step_address0;
assign int_cal_step_ce0        = cal_step_ce0;
assign cal_step_q0             = int_cal_step_q0;
assign int_cal_step_address1   = ar_hs? raddr[4:2] : waddr[4:2];
assign int_cal_step_ce1        = ar_hs | (int_cal_step_write & WVALID);
assign int_cal_step_we1        = int_cal_step_write & w_hs;
assign int_cal_step_be1        = int_cal_step_we1 ? WSTRB : 'b0;
assign int_cal_step_d1         = WDATA;
// cal_offset
assign int_cal_offset_address0 = cal_offset_address0;
assign int_cal_offset_ce0      = cal_offset_ce0;
assign cal_offset_q0           = int_cal_offset_q0;
assign int_cal_offset_address1 = ar_hs? raddr[4:2] : waddr[4:2];
assign int_cal_offset_ce1      = ar_hs | (int_cal_offset_write & WVALID);
assign int_cal_offset_we1      = int_cal_offset_write & w_hs;
assign int_cal_offset_be1      = int_cal_offset_we1 ? WSTRB : 'b0;
assign int_cal_offset_d1       = WDATA;
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

module ADCCountsToFloat_control_s_axi_ram
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

