## Mimas A7 onboard 100 MHz clock
set_property -dict { PACKAGE_PIN H4 IOSTANDARD LVCMOS33 } [get_ports { clk }]

## Mimas A7 LED7
set_property -dict { PACKAGE_PIN M16 IOSTANDARD LVCMOS33 } [get_ports { led }]

## 100 MHz clock constraint
create_clock -period 10.000 -name sys_clk [get_ports { clk }]
