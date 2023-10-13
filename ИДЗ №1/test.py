import subprocess
import os

def run_asm_file(file_path, input_data):
    extra_spaces = 66
    try:
        for input in input_data:
            result = subprocess.run(["java", "-jar", "rars.jar", file_path], input=input, text=True, capture_output=True)
            print("Входные данные от пользователя:\n" + input)
            print(result.stdout[extra_spaces:])
    except subprocess.CalledProcessError as e:
        print("Произошла ошибка:", e)

def main():
    asm_file_path = "idz1.asm"

    test_data = [
        "-21\n",
        "0\n",
        "65\n",
        "11\n",
        "3\n0\n-1\n0\n",
        "4\n1\n0\n-1\n0\n",
        "5\n0\n14\n0\n-6\n0\n",
        "6\n3\n0\n0\n-4\n0\n-1\n",
        "7\n0\n3\n1\n0\n-9\n0\n0\n",
        "9\n4\n0\n5\n0\n0\n2\n-3\n3\n0\n",
        "10\n0\n2\n7\n0\n3\n0\n-4\n0\n-1\n0\n",
    ]

    if not os.path.exists("rars.jar"):
        print("Ошибка: Файл rars.jar не найден в текущем каталоге.")
        return

    run_asm_file(asm_file_path, test_data)

if __name__ == "__main__":
    main()
