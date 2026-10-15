
# constraints






# iic

set_property -dict {PACKAGE_PIN R7 IOSTANDARD LVCMOS33} [get_ports iic_scl]
set_property -dict {PACKAGE_PIN U7 IOSTANDARD LVCMOS33} [get_ports iic_sda]
set_property PACKAGE_PIN AA18 [get_ports {iic_mux_scl[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {iic_mux_scl[1]}]
set_property PULLTYPE PULLUP [get_ports {iic_mux_scl[1]}]
set_property PACKAGE_PIN Y16 [get_ports {iic_mux_sda[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {iic_mux_sda[1]}]
set_property PULLTYPE PULLUP [get_ports {iic_mux_sda[1]}]
set_property PACKAGE_PIN AB4 [get_ports {iic_mux_scl[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {iic_mux_scl[0]}]
set_property PULLTYPE PULLUP [get_ports {iic_mux_scl[0]}]
set_property PACKAGE_PIN AB5 [get_ports {iic_mux_sda[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {iic_mux_sda[0]}]
set_property PULLTYPE PULLUP [get_ports {iic_mux_sda[0]}]

# otg

set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS25} [get_ports otg_vbusoc]

# gpio (switches, leds and such)

set_property -dict {PACKAGE_PIN P16 IOSTANDARD LVCMOS25} [get_ports {gpio_bd[0]}]
set_property -dict {PACKAGE_PIN R16 IOSTANDARD LVCMOS25} [get_ports {gpio_bd[1]}]
set_property -dict {PACKAGE_PIN N15 IOSTANDARD LVCMOS25} [get_ports {gpio_bd[2]}]
set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS25} [get_ports {gpio_bd[3]}]
set_property -dict {PACKAGE_PIN T18 IOSTANDARD LVCMOS25} [get_ports {gpio_bd[4]}]
set_property -dict {PACKAGE_PIN U10 IOSTANDARD LVCMOS33} [get_ports {gpio_bd[5]}]
set_property -dict {PACKAGE_PIN U9 IOSTANDARD LVCMOS33} [get_ports {gpio_bd[6]}]
set_property -dict {PACKAGE_PIN AB12 IOSTANDARD LVCMOS33} [get_ports {gpio_bd[7]}]
set_property -dict {PACKAGE_PIN AA12 IOSTANDARD LVCMOS33} [get_ports {gpio_bd[8]}]
set_property -dict {PACKAGE_PIN U11 IOSTANDARD LVCMOS33} [get_ports {gpio_bd[9]}]
set_property -dict {PACKAGE_PIN U12 IOSTANDARD LVCMOS33} [get_ports {gpio_bd[10]}]

set_property -dict {PACKAGE_PIN F22 IOSTANDARD LVCMOS33} [get_ports {gpio_bd[11]}]
set_property -dict {PACKAGE_PIN G22 IOSTANDARD LVCMOS33} [get_ports {gpio_bd[12]}]
set_property -dict {PACKAGE_PIN H22 IOSTANDARD LVCMOS33} [get_ports {gpio_bd[13]}]
set_property -dict {PACKAGE_PIN F21 IOSTANDARD LVCMOS33} [get_ports {gpio_bd[14]}]
set_property -dict {PACKAGE_PIN H19 IOSTANDARD LVCMOS33} [get_ports {gpio_bd[15]}]
set_property -dict {PACKAGE_PIN H18 IOSTANDARD LVCMOS33} [get_ports {gpio_bd[16]}]
set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS33} [get_ports {gpio_bd[17]}]
set_property -dict {PACKAGE_PIN M15 IOSTANDARD LVCMOS25} [get_ports {gpio_bd[18]}]

#set_property -dict {PACKAGE_PIN T22 IOSTANDARD LVCMOS33} [get_ports {gpio_bd[19]}]; ##ld0:red
set_property -dict {PACKAGE_PIN AA4 IOSTANDARD LVCMOS33} [get_ports {gpio_bd[19]}]
#set_property -dict {PACKAGE_PIN V4 IOSTANDARD LVCMOS33} [get_ports {gpio_bd[19]}]; ## JD2_N led on PMOD JD
set_property -dict {PACKAGE_PIN T21 IOSTANDARD LVCMOS33} [get_ports {gpio_bd[20]}]
set_property -dict {PACKAGE_PIN U22 IOSTANDARD LVCMOS33} [get_ports {gpio_bd[21]}]
set_property -dict {PACKAGE_PIN U21 IOSTANDARD LVCMOS33} [get_ports {gpio_bd[22]}]
#set_property -dict {PACKAGE_PIN V22 IOSTANDARD LVCMOS33} [get_ports {gpio_bd[22]}] ## override
set_property -dict {PACKAGE_PIN V22 IOSTANDARD LVCMOS33} [get_ports {gpio_bd[23]}]
set_property -dict {PACKAGE_PIN W22 IOSTANDARD LVCMOS33} [get_ports {gpio_bd[24]}]
set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVCMOS33} [get_ports {gpio_bd[25]}]
set_property -dict {PACKAGE_PIN U14 IOSTANDARD LVCMOS33} [get_ports {gpio_bd[26]}]

set_property -dict {PACKAGE_PIN H15 IOSTANDARD LVCMOS25} [get_ports {gpio_bd[27]}]
set_property -dict {PACKAGE_PIN R15 IOSTANDARD LVCMOS25} [get_ports {gpio_bd[28]}]
set_property -dict {PACKAGE_PIN K15 IOSTANDARD LVCMOS25} [get_ports {gpio_bd[29]}]
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS25} [get_ports {gpio_bd[30]}]

set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVCMOS33} [get_ports {gpio_bd[31]}]

# Define SPI clock
create_clock -period 40.000 -name spi0_clk [get_pins -hier */EMIOSPI0SCLKO]
create_clock -period 40.000 -name spi1_clk [get_pins -hier */EMIOSPI1SCLKO]

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]






