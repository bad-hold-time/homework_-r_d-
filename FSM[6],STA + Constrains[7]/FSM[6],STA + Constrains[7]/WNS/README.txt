За проєкт на якому проводився "аналіз timing summary report",
було взято лекційний приклад лектора, в constr було написано два періоди, в 10н/c та 20н/c

create clock -period 10 -name sys_clk [get_ports clk]

Setup - WNS  - 7,375ns  // Hold - WHS - 0,106ns 
pusle width wpws - 4,500ns

create clock -period 20 -name sys_clk [get_ports clk]
setup - WNS - 17,375 ns // hold - WHS - 0,106ns 
WPWS - 9.500ns