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
Generator Thread sent number 4 to buffer
Generator Thread sent number 10 to buffer
Generator Thread sent number 10 to buffer
Generator Thread sent number 18 to buffer
Generator Thread sent number 20 to buffer
Generator Thread sent number 19 to buffer
Generator Thread sent number 17 to buffer
Generator Thread sent number 18 to buffer
Generator Thread sent number 7 to buffer
Generator Thread sent number 13 to buffer
Generator Thread sent number 8 to buffer
Generator Thread sent number 20 to buffer
SumThread summed numbers {18, 10} and sent result 28 to buffer
Generator Thread sent number 20 to buffer
Generator Thread sent number 2 to buffer
SumThread summed numbers {10, 4} and sent result 14 to buffer
Generator Thread sent number 14 to buffer
SumThread summed numbers {7, 18} and sent result 25 to buffer
SumThread summed numbers {19, 20} and sent result 39 to buffer
Generator Thread sent number 6 to buffer
Generator Thread sent number 6 to buffer
Generator Thread sent number 9 to buffer
Generator Thread sent number 12 to buffer
Generator Thread sent number 15 to buffer
SumThread summed numbers {8, 13} and sent result 21 to buffer
SumThread summed numbers {28, 20} and sent result 48 to buffer
SumThread summed numbers {20, 17} and sent result 37 to buffer
SumThread summed numbers {25, 14} and sent result 39 to buffer
SumThread summed numbers {14, 2} and sent result 16 to buffer
SumThread summed numbers {12, 9} and sent result 21 to buffer
SumThread summed numbers {15, 6} and sent result 21 to buffer
SumThread summed numbers {6, 39} and sent result 45 to buffer
SumThread summed numbers {48, 21} and sent result 69 to buffer
SumThread summed numbers {39, 37} and sent result 76 to buffer
SumThread summed numbers {21, 16} and sent result 37 to buffer
SumThread summed numbers {76, 69} and sent result 145 to buffer
SumThread summed numbers {45, 21} and sent result 66 to buffer
SumThread summed numbers {145, 37} and sent result 182 to buffer
SumThread summed numbers {182, 66} and sent result 248 to buffer
Result: 248
Process finished with exit code 0

Generator Thread sent number 13 to buffer
Generator Thread sent number 4 to buffer
Generator Thread sent number 10 to buffer
Generator Thread sent number 10 to buffer
Generator Thread sent number 14 to buffer
Generator Thread sent number 20 to buffer
Generator Thread sent number 19 to buffer
Generator Thread sent number 16 to buffer
Generator Thread sent number 18 to buffer
Generator Thread sent number 7 to buffer
Generator Thread sent number 13 to buffer
Generator Thread sent number 11 to buffer
Generator Thread sent number 10 to buffer
Generator Thread sent number 20 to buffer
SumThread summed numbers {10, 10} and sent result 20 to buffer
SumThread summed numbers {4, 13} and sent result 17 to buffer
Generator Thread sent number 8 to buffer
SumThread summed numbers {13, 7} and sent result 20 to buffer
Generator Thread sent number 17 to buffer
Generator Thread sent number 6 to buffer
Generator Thread sent number 6 to buffer
Generator Thread sent number 9 to buffer
SumThread summed numbers {18, 16} and sent result 34 to buffer
SumThread summed numbers {11, 19} and sent result 30 to buffer
Generator Thread sent number 12 to buffer
SumThread summed numbers {20, 14} and sent result 34 to buffer
SumThread summed numbers {20, 20} and sent result 40 to buffer
SumThread summed numbers {12, 30} and sent result 42 to buffer
SumThread summed numbers {20, 8} and sent result 28 to buffer
SumThread summed numbers {34, 9} and sent result 43 to buffer
SumThread summed numbers {17, 10} and sent result 27 to buffer
SumThread summed numbers {6, 6} and sent result 12 to buffer
SumThread summed numbers {34, 17} and sent result 51 to buffer
SumThread summed numbers {42, 40} and sent result 82 to buffer
SumThread summed numbers {43, 28} and sent result 71 to buffer
SumThread summed numbers {12, 27} and sent result 39 to buffer
SumThread summed numbers {39, 71} and sent result 110 to buffer
SumThread summed numbers {82, 51} and sent result 133 to buffer
SumThread summed numbers {133, 110} and sent result 243 to buffer
Result: 243
```

## Скриншоты с демонстрацией работы программы
### Пример 1
<img width="1440" alt="Снимок экрана 2023-12-17 в 17 43 50" src="https://github.com/flowykk/ABC/assets/71427624/945bcfac-9dda-4595-8f3a-da6c01844a8b">

### Пример 2
<img width="1440" alt="Снимок экрана 2023-12-17 в 17 44 38" src="https://github.com/flowykk/ABC/assets/71427624/c1a72118-7262-4b88-b4b9-7893c616ec3a">
