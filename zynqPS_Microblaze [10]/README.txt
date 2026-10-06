ДОМАШНЄ ЗАВДАННЯ ПІСЛЯ ЛЕКЦІЇ 10

impl_1 , synth - логи проекта з вівадо
папка vitis_logs - логи з самого вітіса
один файл wrapper.xsa та два zip файла з вівадо (lesson10.xpr.zip) та vitis.zip

///// файл XDC 

# led output
set_property -dict {PACKAGE_PIN T11 IOSTANDARD LVCMOS33} [get_ports {leds_tri_o[0]}]
set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33} [get_ports {leds_tri_o[1]}]
set_property -dict {PACKAGE_PIN T12 IOSTANDARD LVCMOS33} [get_ports {leds_tri_o[2]}]
set_property -dict {PACKAGE_PIN U12 IOSTANDARD LVCMOS33} [get_ports {leds_tri_o[3]}]
# btn input
set_property -dict {PACKAGE_PIN W13 IOSTANDARD LVCMOS33 PULLUP TRUE} [get_ports {btns_tri_i[0]}]
set_property -dict {PACKAGE_PIN T14 IOSTANDARD LVCMOS33 PULLUP TRUE} [get_ports {btns_tri_i[1]}]
set_property -dict {PACKAGE_PIN T15 IOSTANDARD LVCMOS33 PULLUP TRUE} [get_ports {btns_tri_i[2]}]
set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS33 PULLUP TRUE} [get_ports {btns_tri_i[3]}]
#sw 
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS33} [get_ports {gpio_rtl_0_tri_i[0]}]
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS33} [get_ports {gpio_rtl_0_tri_i[1]}]

///
пробував робити через свою платку, та підключення зовнішніх кнопок до IO
на моменті з роботою в vitis та app_component, світився або один світлодіод, або всі разом
проєкт збирається , але на залізі некоректна поведінка світлодіодів, не впевнений,де саме припустився помилки
