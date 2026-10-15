//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
//Date        : Sun Oct 15 14:02:54 2023
//Host        : ScottsHP running 64-bit major release  (build 9200)
//Command     : generate_target system_wrapper.bd
//Design      : system_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module system_wrapper
   (clk_in,
 //   clk_out,
    data_in, 
    ddr_addr,
    ddr_ba,
    ddr_cas_n,
    ddr_ck_n,
    ddr_ck_p,
    ddr_cke,
    ddr_cs_n,
    ddr_dm,
    ddr_dq,
    ddr_dqs_n,
    ddr_dqs_p,
    ddr_odt,
    ddr_ras_n,
    ddr_reset_n,
    ddr_we_n,
    fixed_io_ddr_vrn,
    fixed_io_ddr_vrp,
    fixed_io_mio,
    fixed_io_ps_clk,
    fixed_io_ps_porb,
    fixed_io_ps_srstb,
    gpio_i,
    gpio_o,
    gpio_t,
    iic_fmc_scl_io,
    iic_fmc_sda_io,
    IIC_0_scl_io,
    IIC_0_sda_io,
    iic_mux_scl_i,
    iic_mux_scl_o,
    iic_mux_scl_t,
    iic_mux_sda_i,
    iic_mux_sda_o,
    iic_mux_sda_t,
    otg_vbusoc,
    ready_in,
//     ready_out,
 //    single_out,
 //    fifo_sync,
    sync_n,
  //  sync_n_out,
  //  sync_in_n,
    spi0_clk_i,
    spi0_clk_o,
    spi0_csn_0_o,
    spi0_csn_1_o,
    spi0_csn_2_o,
    spi0_csn_i,
    spi0_sdi_i,
    spi0_sdo_i,
    spi0_sdo_o,
    spi1_clk_i,
    spi1_clk_o,
    spi1_csn_0_o,
    spi1_csn_1_o,
    spi1_csn_2_o,
    spi1_csn_i,
    spi1_sdi_i,
    spi1_sdo_i,
    spi1_sdo_o,
    dac_cs,
    dac_sclk,
    dac_sdi,
    dac_sdo,
    cola_cs,
    cola_sclk,    
    cola_sdo,
    usr_gpio_o_0,
    usr_gpio_o_1,
    usr_gpio_o_2,
    usr_gpio_o_3,
    usr_gpio_o_4,
    usr_gpio_o_5,
    usr_gpio_o_6,
    usr_gpio_o_7,
    rx_teds,
    tx_teds,
    i_SPI_MISO_0,
    o_SPI_CS_ADC_n_0,
    o_SPI_CS_MAX_n_0,
    o_SPI_CS_n_0,
    o_SPI_Clk_0,
    o_SPI_MOSI_0,
    trig_neg,
    trig_plus);
  input clk_in;
// output clk_out;
  input [7:0]data_in;
  inout [14:0]ddr_addr;
  inout [2:0]ddr_ba;
  inout ddr_cas_n;
  inout ddr_ck_n;
  inout ddr_ck_p;
  inout ddr_cke;
  inout ddr_cs_n;
  inout [3:0]ddr_dm;
  inout [31:0]ddr_dq;
  inout [3:0]ddr_dqs_n;
  inout [3:0]ddr_dqs_p;
  inout ddr_odt;
  inout ddr_ras_n;
  inout ddr_reset_n;
  inout ddr_we_n;
  inout fixed_io_ddr_vrn;
  inout fixed_io_ddr_vrp;
  inout [53:0]fixed_io_mio;
  inout fixed_io_ps_clk;
  inout fixed_io_ps_porb;
  inout fixed_io_ps_srstb;
  input [63:0]gpio_i;
  output [63:0]gpio_o;
  output [63:0]gpio_t;
  inout iic_fmc_scl_io;
  inout iic_fmc_sda_io;
  inout IIC_0_scl_io;
  inout IIC_0_sda_io;
  input [1:0]iic_mux_scl_i;
  output [1:0]iic_mux_scl_o;
  output iic_mux_scl_t;
  input [1:0]iic_mux_sda_i;
  output [1:0]iic_mux_sda_o;
  output iic_mux_sda_t;
  input otg_vbusoc;
  input ready_in;
//  output ready_out;
 // output single_out;
 // output fifo_sync;
  input sync_n;
//  output sync_n_out;
 // output sync_in_n;
  input spi0_clk_i;
  output spi0_clk_o;
  output spi0_csn_0_o;
  output spi0_csn_1_o;
  output spi0_csn_2_o;
  input spi0_csn_i;
  input spi0_sdi_i;
  input spi0_sdo_i;
  output spi0_sdo_o;
  input spi1_clk_i;
  output spi1_clk_o;
  output spi1_csn_0_o;
  output spi1_csn_1_o;
  output spi1_csn_2_o;
  input spi1_csn_i;
  input spi1_sdi_i;
  input spi1_sdo_i;
  output spi1_sdo_o;
  output [0:0]dac_cs;
  output dac_sclk;
  input [0:0]dac_sdi;
  output dac_sdo;
  output [0:0]cola_cs;
  output cola_sclk;
  output cola_sdo;
  output [0:2]usr_gpio_o_0;
  output [0:2]usr_gpio_o_1;
  output [0:2]usr_gpio_o_2;
  output [0:2]usr_gpio_o_3;
  output [0:2]usr_gpio_o_4;
  output [0:2]usr_gpio_o_5;
  output [0:2]usr_gpio_o_6;
  output [0:2]usr_gpio_o_7;
  output rx_teds;
  input tx_teds;
  input i_SPI_MISO_0;
  output o_SPI_CS_ADC_n_0;
  output o_SPI_CS_MAX_n_0;
  output o_SPI_CS_n_0;
  output o_SPI_Clk_0;
  output o_SPI_MOSI_0;
  input trig_plus;
  input trig_neg;
  
  wire clk_in;
//  wire clk_out;
  wire [7:0]data_in;
  wire [14:0]ddr_addr;
  wire [2:0]ddr_ba;
  wire ddr_cas_n;
  wire ddr_ck_n;
  wire ddr_ck_p;
  wire ddr_cke;
  wire ddr_cs_n;
  wire [3:0]ddr_dm;
  wire [31:0]ddr_dq;
  wire [3:0]ddr_dqs_n;
  wire [3:0]ddr_dqs_p;
  wire ddr_odt;
  wire ddr_ras_n;
  wire ddr_reset_n;
  wire ddr_we_n;
  wire fixed_io_ddr_vrn;
  wire fixed_io_ddr_vrp;
  wire [53:0]fixed_io_mio;
  wire fixed_io_ps_clk;
  wire fixed_io_ps_porb;
  wire fixed_io_ps_srstb;
  wire [63:0]gpio_i;
  wire [63:0]gpio_o;
  wire [63:0]gpio_t;
  wire iic_fmc_scl_i;
  wire iic_fmc_scl_io;
  wire iic_fmc_scl_o;
  wire iic_fmc_scl_t;
  wire iic_fmc_sda_i;
  wire iic_fmc_sda_io;
  wire iic_fmc_sda_o;
  wire iic_fmc_sda_t;
  wire IIC_0_scl_i;
  wire IIC_0_scl_io;
  wire IIC_0_scl_o;
  wire IIC_0_scl_t;
  wire IIC_0_sda_i;
  wire IIC_0_sda_io;
  wire IIC_0_sda_o;
  wire IIC_0_sda_t;
  wire [1:0]iic_mux_scl_i;
  wire [1:0]iic_mux_scl_o;
  wire iic_mux_scl_t;
  wire [1:0]iic_mux_sda_i;
  wire [1:0]iic_mux_sda_o;
  wire iic_mux_sda_t;
  wire otg_vbusoc;
  wire ready_in;
//  wire ready_out;
//  wire fifo_sync;
//  wire single_out;
  wire sync_n;
//  wire sync_n_out;
//  wire sync_in_n;
  wire spi0_clk_i;
  wire spi0_clk_o;
  wire spi0_csn_0_o;
  wire spi0_csn_1_o;
  wire spi0_csn_2_o;
  wire spi0_csn_i;
  wire spi0_sdi_i;
  wire spi0_sdo_i;
  wire spi0_sdo_o;
  wire spi1_clk_i;
  wire spi1_clk_o;
  wire spi1_csn_0_o;
  wire spi1_csn_1_o;
  wire spi1_csn_2_o;
  wire spi1_csn_i;
  wire spi1_sdi_i;
  wire spi1_sdo_i;
  wire spi1_sdo_o;
  wire [0:0]dac_cs;
  wire dac_sclk;
  wire [0:0]dac_sdi;
  wire dac_sdo;
  wire [0:0]cola_cs;
  wire cola_sclk;
  wire cola_sdo;
  wire [0:2]usr_gpio_o_0;
  wire [0:2]usr_gpio_o_1;
  wire [0:2]usr_gpio_o_2; 
  wire [0:2]usr_gpio_o_3;
  wire [0:2]usr_gpio_o_4;
  wire [0:2]usr_gpio_o_5;
  wire [0:2]usr_gpio_o_6; 
  wire [0:2]usr_gpio_o_7;
  wire rx_teds;
  wire tx_teds;
  wire i_SPI_MISO_0;
  wire o_SPI_CS_ADC_n_0;
  wire o_SPI_CS_MAX_n_0;
  wire o_SPI_CS_n_0;
  wire o_SPI_Clk_0;
  wire o_SPI_MOSI_0;
  wire trig_plus;
  wire trig_neg;
  
  IOBUF iic_fmc_scl_iobuf
       (.I(iic_fmc_scl_o),
        .IO(iic_fmc_scl_io),
        .O(iic_fmc_scl_i),
        .T(iic_fmc_scl_t));
  IOBUF iic_fmc_sda_iobuf
       (.I(iic_fmc_sda_o),
        .IO(iic_fmc_sda_io),
        .O(iic_fmc_sda_i),
        .T(iic_fmc_sda_t));
  IOBUF IIC_0_scl_iobuf
       (.I(IIC_0_scl_o),
        .IO(IIC_0_scl_io),
        .O(IIC_0_scl_i),
        .T(IIC_0_scl_t));
  IOBUF IIC_0_sda_iobuf
       (.I(IIC_0_sda_o),
        .IO(IIC_0_sda_io),
        .O(IIC_0_sda_i),
        .T(IIC_0_sda_t));
  system system_i
       (.clk_in(clk_in),
   //     .clk_out(clk_out),
        .data_in(data_in),
        .ddr_addr(ddr_addr),
        .ddr_ba(ddr_ba),
        .ddr_cas_n(ddr_cas_n),
        .ddr_ck_n(ddr_ck_n),
        .ddr_ck_p(ddr_ck_p),
        .ddr_cke(ddr_cke),
        .ddr_cs_n(ddr_cs_n),
        .ddr_dm(ddr_dm),
        .ddr_dq(ddr_dq),
        .ddr_dqs_n(ddr_dqs_n),
        .ddr_dqs_p(ddr_dqs_p),
        .ddr_odt(ddr_odt),
        .ddr_ras_n(ddr_ras_n),
        .ddr_reset_n(ddr_reset_n),
        .ddr_we_n(ddr_we_n),
        .fixed_io_ddr_vrn(fixed_io_ddr_vrn),
        .fixed_io_ddr_vrp(fixed_io_ddr_vrp),
        .fixed_io_mio(fixed_io_mio),
        .fixed_io_ps_clk(fixed_io_ps_clk),
        .fixed_io_ps_porb(fixed_io_ps_porb),
        .fixed_io_ps_srstb(fixed_io_ps_srstb),
        .gpio_i(gpio_i),
        .gpio_o(gpio_o),
        .gpio_t(gpio_t),
        .iic_fmc_scl_i(iic_fmc_scl_i),
        .iic_fmc_scl_o(iic_fmc_scl_o),
        .iic_fmc_scl_t(iic_fmc_scl_t),
        .iic_fmc_sda_i(iic_fmc_sda_i),
        .iic_fmc_sda_o(iic_fmc_sda_o),
        .iic_fmc_sda_t(iic_fmc_sda_t),
        .iic_mux_scl_i(iic_mux_scl_i),
        .iic_mux_scl_o(iic_mux_scl_o),
        .iic_mux_scl_t(iic_mux_scl_t),
        .iic_mux_sda_i(iic_mux_sda_i),
        .iic_mux_sda_o(iic_mux_sda_o),
        .iic_mux_sda_t(iic_mux_sda_t),
        .IIC_0_scl_i(IIC_0_scl_i),
        .IIC_0_scl_o(IIC_0_scl_o),
        .IIC_0_scl_t(IIC_0_scl_t),
        .IIC_0_sda_i(IIC_0_sda_i),
        .IIC_0_sda_o(IIC_0_sda_o),
        .IIC_0_sda_t(IIC_0_sda_t),
        .otg_vbusoc(otg_vbusoc),
        .ready_in(ready_in),
    //    .ready_out(ready_out),
   //     .fifo_sync(fifo_sync),
    //    .single_out(single_out),
        .sync_n(sync_n),
    //    .sync_n_out(sync_n_out),
    //    .sync_in_n(sync_in_n),
        .spi0_clk_i(spi0_clk_i),
        .spi0_clk_o(spi0_clk_o),
        .spi0_csn_0_o(spi0_csn_0_o),
        .spi0_csn_1_o(spi0_csn_1_o),
        .spi0_csn_2_o(spi0_csn_2_o),
        .spi0_csn_i(spi0_csn_i),
        .spi0_sdi_i(spi0_sdi_i),
        .spi0_sdo_i(spi0_sdo_i),
        .spi0_sdo_o(spi0_sdo_o),
        .spi1_clk_i(spi1_clk_i),
        .spi1_clk_o(spi1_clk_o),
        .spi1_csn_0_o(spi1_csn_0_o),
        .spi1_csn_1_o(spi1_csn_1_o),
        .spi1_csn_2_o(spi1_csn_2_o),
        .spi1_csn_i(spi1_csn_i),
        .spi1_sdi_i(spi1_sdi_i),
        .spi1_sdo_i(spi1_sdo_i),
        .spi1_sdo_o(spi1_sdo_o),
        .usr_gpio_o_0(usr_gpio_o_0),
        .usr_gpio_o_1(usr_gpio_o_1),
        .usr_gpio_o_2(usr_gpio_o_2),
        .usr_gpio_o_3(usr_gpio_o_3),
        .usr_gpio_o_4(usr_gpio_o_4),
        .usr_gpio_o_5(usr_gpio_o_5),
        .usr_gpio_o_6(usr_gpio_o_6),
        .usr_gpio_o_7(usr_gpio_o_7),
        .rx_teds(rx_teds),
        .tx_teds(tx_teds),
        .dac_cs(dac_cs),
        .dac_sclk(dac_sclk),
        .dac_sdi(dac_sdi),
        .dac_sdo(dac_sdo),
        .cola_cs(cola_cs),
        .cola_sclk(cola_sclk),
        .cola_sdo(cola_sdo),
        .i_SPI_MISO_0(i_SPI_MISO_0),
        .o_SPI_CS_ADC_n_0(o_SPI_CS_ADC_n_0),
        .o_SPI_CS_MAX_n_0(o_SPI_CS_MAX_n_0),
        .o_SPI_CS_n_0(o_SPI_CS_n_0),
        .o_SPI_Clk_0(o_SPI_Clk_0),
        .o_SPI_MOSI_0(o_SPI_MOSI_0),
        .trig_neg(trig_neg),
        .trig_plus(trig_plus));
endmodule
