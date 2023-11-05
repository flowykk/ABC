import math
import subprocess
import os

def run_asm_file(file_path, input_data):
    extra_spaces = 83
    test_number = 1
    for input in input_data:
        result = subprocess.run(["java", "-jar", "rars.jar", file_path], input=input, text=True, capture_output=True)
        print("Тест №" + str(test_number))
        test_number += 1
        print("Входные данные от пользователя:\n" + input)
        print(result.stdout[extra_spaces:])

        print("Проверка вызовом функций python 3.8:")
        print("sin(x) = " + str(math.sin(float(input[:-1]))))
        print("cos(x) = " + str(math.cos(float(input[:-1]))))
        print("tg(x) = " + str(math.tan(float(input[:-1]))))

        print()

def main():
    asm_file_path = "main.asm"

    test_data = [
        "1.1\n",
        "-1.0\n",
        "2.0\n",
        "-2.0\n",
        "-2.5\n",
        "2.5\n",
        "1.56\n",
    ]

    if not os.path.exists("rars.jar"):
        print("Ошибка: Файл rars.jar не найден в текущем каталоге.")
        return

    run_asm_file(asm_file_path, test_data)

if __name__ == "__main__":
    main()
