##Clock signal
set_property -dict {PACKAGE_PIN K17 IOSTANDARD LVCMOS33} [get_ports clock]
create_clock -period 8.000 -name sys_clk_pin -waveform {0.000 4.000} -add [get_ports clock]

##Switches
set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS33} [get_ports {switch[0]}]
set_property -dict {PACKAGE_PIN P15 IOSTANDARD LVCMOS33} [get_ports {switch[1]}]
set_property -dict {PACKAGE_PIN W13 IOSTANDARD LVCMOS33} [get_ports {switch[2]}]
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS33} [get_ports {switch[3]}]

##Buttons
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33} [get_ports {button[0]}]
set_property -dict {PACKAGE_PIN P16 IOSTANDARD LVCMOS33} [get_ports {button[1]}]
set_property -dict {PACKAGE_PIN K19 IOSTANDARD LVCMOS33} [get_ports {button[2]}]
set_property -dict {PACKAGE_PIN Y16 IOSTANDARD LVCMOS33} [get_ports {button[3]}]

##LEDs
set_property -dict {PACKAGE_PIN M14 IOSTANDARD LVCMOS33} [get_ports {led[0]}]
set_property -dict {PACKAGE_PIN M15 IOSTANDARD LVCMOS33} [get_ports {led[1]}]
set_property -dict {PACKAGE_PIN G14 IOSTANDARD LVCMOS33} [get_ports {led[2]}]
set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVCMOS33} [get_ports {led[3]}]

##RGB LED 6
set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS33} [get_ports led_red]
set_property -dict {PACKAGE_PIN F17 IOSTANDARD LVCMOS33} [get_ports led_green]
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS33} [get_ports led_blue]

##USB-OTG over-current detect pin
#set_property -dict { PACKAGE_PIN U13   IOSTANDARD LVCMOS33 } [get_ports { otg_oc }]; #IO_L3P_T0_DQS_PUDC_B_34 Sch=otg_oc

##Pmod Header JE
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports ps2_data]
set_property -dict {PACKAGE_PIN H15 IOSTANDARD LVCMOS33} [get_ports ps2_clock]

set_property PULLUP true [get_ports ps2_clock]
set_property PULLUP true [get_ports ps2_data]
