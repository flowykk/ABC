# ДЗ №9

__Работу выполнил__: Рахманов Данила Дмитриевич

## Что сделано в ДЗ №9?

- Разработана многопоточная программа, которая при помощи 20-ти разных потоков суммирует числа.
- Каждый из 20-ти потоков порождает одно целое число, которое потом отправляется в буфер.
- Суммирующие потоки в течение нужного времени суммируют пары чисел и отправляют результат в буфер.
- Числа в потоках и аргументы функции **sleep()** генерируются согласно условию.

## Код программы
### [Главный файл программы](main.cpp)

## Примерный лог программы
```
Generator Thread sent number 13 to buffer
Generator Thread sent number 4 to buffer
Generator Thread sent number 10 to buffer
Generator Thread sent number 18 to buffer
Generator Thread sent number 14 to buffer
Generator Thread sent number 20 to buffer
Generator Thread sent number 19 to buffer
Generator Thread sent number 16 to buffer
Generator Thread sent number 18 to buffer
Generator Thread sent number 7 to buffer
Generator Thread sent number 13 to buffer
SumThread summed numbers {4, 13} and sent result 17 to buffer
Generator Thread sent number 20 to buffer
Generator Thread sent number 10 to buffer
SumThread summed numbers {18, 10} and sent result 28 to buffer
Generator Thread sent number 2 to buffer
Generator Thread sent number 8 to buffer
Generator Thread sent number 14 to buffer
Generator Thread sent number 17 to buffer
Generator Thread sent number 6 to buffer
Generator Thread sent number 6 to buffer
Generator Thread sent number 12 to buffer
SumThread summed numbers {18, 16} and sent result 34 to buffer
SumThread summed numbers {20, 14} and sent result 34 to buffer
SumThread summed numbers {17, 19} and sent result 36 to buffer
SumThread summed numbers {10, 20} and sent result 30 to buffer
SumThread summed numbers {13, 7} and sent result 20 to buffer
SumThread summed numbers {6, 17} and sent result 23 to buffer
SumThread summed numbers {12, 6} and sent result 18 to buffer
SumThread summed numbers {2, 28} and sent result 30 to buffer
SumThread summed numbers {14, 8} and sent result 22 to buffer
SumThread summed numbers {34, 34} and sent result 68 to buffer
SumThread summed numbers {30, 36} and sent result 66 to buffer
SumThread summed numbers {23, 20} and sent result 43 to buffer
SumThread summed numbers {30, 18} and sent result 48 to buffer
SumThread summed numbers {68, 22} and sent result 90 to buffer
SumThread summed numbers {43, 66} and sent result 109 to buffer
SumThread summed numbers {90, 48} and sent result 138 to buffer
SumThread summed numbers {138, 109} and sent result 247 to buffer
Result: 247
```

## Скриншоты с демонстрацией работы программы
<img width="1440" alt="Снимок экрана 2023-12-15 в 14 05 38" src="https://github.com/flowykk/ABC/assets/71427624/6e12839c-0389-4813-8460-19713957a572">

![Снимок экрана 2023-12-15 в 14 06 29 (2)](https://github.com/flowykk/ABC/assets/71427624/9934ef0e-d092-4309-9815-ca6fb14ffb63)
<img width="1440" alt="Снимок экрана 2023-12-15 в 14 06 29" src="https://github.com/flowykk/ABC/assets/71427624/0aaba2e9-cb52-4930-9845-aa28b048a4ea">
