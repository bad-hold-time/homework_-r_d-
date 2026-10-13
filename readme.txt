Структура блок-дизайну
У проєкті структура блок-дизайну виконана згідно з ТЗ
В IP-ядрі AXI4-Full RAM використано такі налаштування:

Address Width = 16
Data Width = 32
Memory Depth = 16384
параметри забезпечують збереження одного кадру 320 на 200 у 32бітних словах

в axi_gpio увімкнено dual channel
 де перший inputs gpio / width - 1 
а другий outputs йде на пін старту топ модуля
Testbench
initial begin
    #200 rst = 0; <- через 200нс знімається ресет 
    #50000 btn = 1; <- через 50000 нс подається сигнал на кнопку
    wait (dut.design_1_i.top_module_0.start === 1'b1);
    repeat (10) @(negedge clk);
    for (i = 0; i < FRAME_BYTES; i = i + 1) begin
        @(negedge clk);
            pix_valid = 1;
            pix_data  = i[7:0];
        @(negedge clk);
            pix_valid = 0;
    end
repeat (5000) @(posedge clk); після відправки чекаємо 5000 тактів , щоб всі ланцюги встигли доопрацювати
    $finish;
end 

з роботою в ТБ виникло багато скландощів, але наче все працює