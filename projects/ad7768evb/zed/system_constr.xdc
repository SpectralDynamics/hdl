###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS25} [get_ports clk_in]
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS25} [get_ports ready_in]
#set_property -dict {PACKAGE_PIN AB6 IOSTANDARD LVCMOS33} [get_ports ready_out] pmod jc
#set_property -dict {PACKAGE_PIN AB7 IOSTANDARD LVCMOS33} [get_ports sync_n_out] pmod jc
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS25} [get_ports {data_in[0]}]
set_property -dict {PACKAGE_PIN L22 IOSTANDARD LVCMOS25} [get_ports {data_in[1]}]
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS25} [get_ports {data_in[2]}]
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS25} [get_ports {data_in[3]}]
set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVCMOS25} [get_ports {data_in[4]}]
set_property -dict {PACKAGE_PIN J22 IOSTANDARD LVCMOS25} [get_ports {data_in[5]}]
set_property -dict {PACKAGE_PIN R20 IOSTANDARD LVCMOS25} [get_ports {data_in[6]}]
set_property -dict {PACKAGE_PIN R21 IOSTANDARD LVCMOS25} [get_ports {data_in[7]}]
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS25} [get_ports spi_csn]
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS25} [get_ports spi_clk]
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVCMOS25} [get_ports spi_mosi]
set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS25} [get_ports spi_miso]
set_property -dict {PACKAGE_PIN T19 IOSTANDARD LVCMOS25} [get_ports gpio_0_mode_0]
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS25} [get_ports gpio_1_mode_1]
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS25} [get_ports gpio_2_mode_2]
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS25} [get_ports gpio_3_mode_3]
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS25} [get_ports gpio_4_filter]
set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVCMOS25} [get_ports reset_n]
set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVCMOS25} [get_ports start_n]
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS25} [get_ports sync_n] 
## set_property PULLUP true [get_ports {start_n}]
#set_property -dict {PACKAGE_PIN Y4 IOSTANDARD LVCMOS33} [get_ports sync_n_out]
## set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS25} [get_ports sync_in_n]
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS25} [get_ports mclk]
#set_property -dict {PACKAGE_PIN AB7 IOSTANDARD LVCMOS33} [get_ports clk_out]
##set_property -dict {PACKAGE_PIN AB6 IOSTANDARD LVCMOS33} [get_ports start_n_out]
##set_property -dict {PACKAGE_PIN AA4 IOSTANDARD LVCMOS33} [get_ports ready_out]
#set_property -dict {PACKAGE_PIN AB6 IOSTANDARD LVCMOS33} [get_ports fifo_sync]
#set_property -dict {PACKAGE_PIN AA4 IOSTANDARD LVCMOS33} [get_ports single_out]

## SD Gains and Overload detect GPIO's M21 K18
set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS33} [get_ports {ch0_range[0]}]
set_property -dict {PACKAGE_PIN D22 IOSTANDARD LVCMOS33} [get_ports {ch0_range[1]}]
set_property -dict {PACKAGE_PIN C22 IOSTANDARD LVCMOS33} [get_ports {ch0_range[2]}]
set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVCMOS33} [get_ports {ch1_range[0]}]
set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVCMOS33} [get_ports {ch1_range[1]}]
set_property -dict {PACKAGE_PIN C18 IOSTANDARD LVCMOS33} [get_ports {ch1_range[2]}]
set_property -dict {PACKAGE_PIN A17 IOSTANDARD LVCMOS33} [get_ports {ch2_range[0]}]
set_property -dict {PACKAGE_PIN B16 IOSTANDARD LVCMOS33} [get_ports {ch2_range[1]}]
set_property -dict {PACKAGE_PIN B17 IOSTANDARD LVCMOS33} [get_ports {ch2_range[2]}]
set_property -dict {PACKAGE_PIN B15 IOSTANDARD LVCMOS33} [get_ports {ch3_range[0]}]
set_property -dict {PACKAGE_PIN B21 IOSTANDARD LVCMOS33} [get_ports {ch3_range[1]}]
set_property -dict {PACKAGE_PIN B22 IOSTANDARD LVCMOS33} [get_ports {ch3_range[2]}]
set_property -dict {PACKAGE_PIN E20 IOSTANDARD LVCMOS33} [get_ports {ch4_range[0]}]
set_property -dict {PACKAGE_PIN F18 IOSTANDARD LVCMOS33} [get_ports {ch4_range[1]}]
set_property -dict {PACKAGE_PIN E21 IOSTANDARD LVCMOS33} [get_ports {ch4_range[2]}]
set_property -dict {PACKAGE_PIN D15 IOSTANDARD LVCMOS33} [get_ports {ch5_range[0]}]
set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVCMOS33} [get_ports {ch5_range[1]}]
set_property -dict {PACKAGE_PIN F19 IOSTANDARD LVCMOS33} [get_ports {ch5_range[2]}]
set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS33} [get_ports {ch6_range[0]}]
set_property -dict {PACKAGE_PIN C20 IOSTANDARD LVCMOS33} [get_ports {ch6_range[1]}]
set_property -dict {PACKAGE_PIN E15 IOSTANDARD LVCMOS33} [get_ports {ch6_range[2]}]
set_property -dict {PACKAGE_PIN B20 IOSTANDARD LVCMOS33} [get_ports {ch7_range[0]}]
set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVCMOS33} [get_ports {ch7_range[1]}]
set_property -dict {PACKAGE_PIN G21 IOSTANDARD LVCMOS33} [get_ports {ch7_range[2]}]
set_property -dict {PACKAGE_PIN A21 IOSTANDARD LVCMOS33} [get_ports teds_tx]
set_property -dict {PACKAGE_PIN A22 IOSTANDARD LVCMOS33} [get_ports teds_rx]
#set_property -dict {PACKAGE_PIN T22 IOSTANDARD LVCMOS33} [get_ports {led_gpio[0]}]
#set_property -dict {PACKAGE_PIN T21 IOSTANDARD LVCMOS33} [get_ports {led_gpio[1]}]
#set_property -dict {PACKAGE_PIN U22 IOSTANDARD LVCMOS33} [get_ports {led_gpio[2]}]
#set_property -dict {PACKAGE_PIN U21 IOSTANDARD LVCMOS33} [get_ports {led_gpio[3]}]
#set_property -dict {PACKAGE_PIN V22 IOSTANDARD LVCMOS33} [get_ports {led_gpio[4]}]
#set_property -dict {PACKAGE_PIN W22 IOSTANDARD LVCMOS33} [get_ports {led_gpio[5]}]
#set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVCMOS33} [get_ports {led_gpio[6]}]
#set_property -dict {PACKAGE_PIN U14 IOSTANDARD LVCMOS33} [get_ports {led_gpio[7]}]

## coupling IIC
set_property -dict {PACKAGE_PIN K19 IOSTANDARD LVCMOS25} [get_ports coupling_iic_sda] ; ##K19
set_property -dict {PACKAGE_PIN K20 IOSTANDARD LVCMOS25} [get_ports coupling_iic_scl] ; ##K20

## PMOD DAC AD5791 on JA
set_property -dict {PACKAGE_PIN AA11 IOSTANDARD LVCMOS33} [get_ports dac_sdo]
set_property -dict {PACKAGE_PIN Y10 IOSTANDARD LVCMOS33} [get_ports dac_sdi]
set_property -dict {PACKAGE_PIN AA9 IOSTANDARD LVCMOS33} [get_ports dac_sclk]
set_property -dict {PACKAGE_PIN Y11 IOSTANDARD LVCMOS33} [get_ports dac_cs]

## PMOD DAC AD5791 on JD (for now)
#set_property -dict {PACKAGE_PIN W7 IOSTANDARD LVCMOS33} [get_ports dac_sdo]
#set_property -dict {PACKAGE_PIN V5 IOSTANDARD LVCMOS33} [get_ports dac_sdi]
#set_property -dict {PACKAGE_PIN V4 IOSTANDARD LVCMOS33} [get_ports dac_sclk]
#set_property -dict {PACKAGE_PIN V7 IOSTANDARD LVCMOS33} [get_ports dac_cs]

## PMOD Tacho on JA
#set_property -dict {PACKAGE_PIN Y11 IOSTANDARD LVCMOS33} [get_ports o_SPI_CS_n_0]
#set_property -dict {PACKAGE_PIN AA11 IOSTANDARD LVCMOS33} [get_ports o_SPI_MOSI_0]
#set_property -dict {PACKAGE_PIN Y10 IOSTANDARD LVCMOS33} [get_ports i_SPI_MISO_0]
#set_property -dict {PACKAGE_PIN AA9 IOSTANDARD LVCMOS33} [get_ports o_SPI_Clk_0]
#set_property -dict {PACKAGE_PIN AB10 IOSTANDARD LVCMOS33} [get_ports o_SPI_CS_MAX_n_0]
#set_property -dict {PACKAGE_PIN AB11 IOSTANDARD LVCMOS33} [get_ports o_SPI_CS_ADC_n_0]
#set_property -dict {PACKAGE_PIN AB9 IOSTANDARD LVCMOS33} [get_ports trig_plus]
#set_property -dict {PACKAGE_PIN AA8 IOSTANDARD LVCMOS33} [get_ports trig_neg]

## PMOD Tacho on JD (for now)
set_property -dict {PACKAGE_PIN V7 IOSTANDARD LVCMOS33} [get_ports o_SPI_CS_n_0]
set_property -dict {PACKAGE_PIN W7 IOSTANDARD LVCMOS33} [get_ports o_SPI_MOSI_0]
set_property -dict {PACKAGE_PIN V5 IOSTANDARD LVCMOS33} [get_ports i_SPI_MISO_0]
set_property -dict {PACKAGE_PIN V4 IOSTANDARD LVCMOS33} [get_ports o_SPI_Clk_0]
set_property -dict {PACKAGE_PIN W5 IOSTANDARD LVCMOS33} [get_ports o_SPI_CS_MAX_n_0]
set_property -dict {PACKAGE_PIN W6 IOSTANDARD LVCMOS33} [get_ports o_SPI_CS_ADC_n_0]
set_property -dict {PACKAGE_PIN U5 IOSTANDARD LVCMOS33} [get_ports trig_plus]
set_property -dict {PACKAGE_PIN U6 IOSTANDARD LVCMOS33} [get_ports trig_neg]

## PMOD Cola AD5541A on JB
set_property -dict {PACKAGE_PIN W11 IOSTANDARD LVCMOS33} [get_ports cola_sdo] ; ##W11
set_property -dict {PACKAGE_PIN W8 IOSTANDARD LVCMOS33} [get_ports cola_sclk] ; ##W8
set_property -dict {PACKAGE_PIN W12 IOSTANDARD LVCMOS33} [get_ports cola_cs]  ; ##W12



create_clock -period 29.800 -name adc_clk [get_ports clk_in]

## set_property SLEW SLOW [get_ports iic_scl]
## set_property SLEW SLOW [get_ports coupling_iic_scl]
## set_property SLEW SLOW [get_ports coupling_iic_sda]
