# ДЗ №9

__Работу выполнил__: Рахманов Данила Дмитриевич

## Что сделано в ДЗ №9?

- Разработана многопоточная программа, которая при помощи 20-ти разных потоков суммирует числа.
- Каждый из 20-ти потоков порождает одно целое число, которое потом отправляется в буфер.
- Суммирующие потоки в течение нужного времени суммируют пары чисел и отправляют результат в буфер.
- Числа в потоках и аргументы функции **sleep()** генерируются согласно условию.

## Код программы
### [Главный файл программы](main.cpp)

## Лог программы
```
Generator Thread 0 sent number 8 to buffer.
Generator Thread 1 sent number 10 to buffer.
Generator Thread 0 sent number 14 to buffer.
Generator Thread 1 sent number 19 to buffer.
Generator Thread 0 sent number 5 to buffer.
Generator Thread 1 sent number 19 to buffer.
Generator Thread 2 sent number 4 to buffer.
Generator Thread 1 sent number 1 to buffer.
Generator Thread 2 sent number 6 to buffer.
Generator Thread 3 sent number 13 to buffer.
Generator Thread 2 sent number 3 to buffer.
Generator Thread 1 sent number 8 to buffer.
Generator Thread 2 sent number 10 to buffer.
Generator Thread 1 sent number 13 to buffer.
Generator Thread 0 sent number 10 to buffer.
Generator Thread 1 sent number 10 to buffer.
SumThread summed numbers 10, 8 and sent result 18 to buffer.
Generator Thread 1 sent number 1 to buffer.
Generator Thread 2 sent number 14 to buffer.
Generator Thread 1 sent number 19 to buffer.
Generator Thread 0 sent number 17 to buffer.
SumThread summed numbers 13, 6 and sent result 19 to buffer.
SumThread summed numbers 19, 14 and sent result 33 to buffer.
SumThread summed numbers 4, 19 and sent result 23 to buffer.
SumThread summed numbers 13, 5 and sent result 18 to buffer.
SumThread summed numbers 10, 8 and sent result 18 to buffer.
SumThread summed numbers 3, 1 and sent result 4 to buffer.
SumThread summed numbers 14, 1 and sent result 15 to buffer.
SumThread summed numbers 10, 10 and sent result 20 to buffer.
SumThread summed numbers 19, 18 and sent result 37 to buffer.
SumThread summed numbers 19, 17 and sent result 36 to buffer.
SumThread summed numbers 23, 33 and sent result 56 to buffer.
SumThread summed numbers 15, 18 and sent result 33 to buffer.
SumThread summed numbers 4, 18 and sent result 22 to buffer.
SumThread summed numbers 56, 36 and sent result 92 to buffer.
SumThread summed numbers 37, 20 and sent result 57 to buffer.
SumThread summed numbers 22, 33 and sent result 55 to buffer.
SumThread summed numbers 57, 92 and sent result 149 to buffer.
SumThread summed numbers 149, 55 and sent result 204 to buffer.
Final sum: 204
```

## Скриншот работы программы
![Снимок экрана 2023-12-12 в 15 42 58](https://github.com/flowykk/ABC/assets/71427624/002ab2ee-95f1-43ee-89f5-93396fcdfdb1)
