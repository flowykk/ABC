#include <iostream>
#include <pthread.h>
#include <unistd.h> // Для функции sleep()
#include <fstream>

pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t student_cond = PTHREAD_COND_INITIALIZER;
pthread_cond_t teacher_cond = PTHREAD_COND_INITIALIZER;

int current_ticket = 0;
int answered_students = 0;
bool is_teacher_active = false;
int current_student = 0;

int num_students;
std::string output_fileName;
std::ofstream output_file;

void *StudentThread(void *arg) {
    int student_id = *((int *)arg);

    while (true) {
        pthread_mutex_lock(&mutex);

        // Проверка, ответил ли уже этот студент
        if (answered_students >= num_students) {
            pthread_mutex_unlock(&mutex);
            break;
        }

        // Студент выбирает билет
        int ticket = ++current_ticket;
//        sleep(1);
        std::cout << "Студент " << student_id << " выбрал билет: " << ticket << std::endl;
        output_file << "Студент " << student_id << " выбрал билет: " << ticket << std::endl;

        // Готовится к ответу
        int preparation_time = rand() % 5 + 1; // Генерация случайного времени подготовки (от 1 до 5 секунд)
        std::cout << "Студент " << student_id << " готовится к ответу..." << std::endl;
        output_file << "Студент " << student_id << " готовится к ответу..." << std::endl;
        pthread_mutex_unlock(&mutex);
        sleep(preparation_time);

        // Защита билета
        pthread_mutex_lock(&mutex);
        std::cout << "Студент " << student_id << " защищает билет: " << ticket << std::endl;
        output_file << "Студент " << student_id << " защищает билет: " << ticket << std::endl;
        is_teacher_active = true; // Устанавливаем флаг, что преподаватель может действовать
        current_student = student_id;
        answered_students++;
        pthread_cond_signal(&teacher_cond); // Сигнал преподавателю

        std::cout << "студент ждет вердикт" << std::endl;
        output_file << "студент ждет вердикт" << std::endl;

        // Ожидание оценки
        pthread_cond_wait(&student_cond, &mutex);
        pthread_mutex_unlock(&mutex);
        break; // Завершение потока после ответа
    }

    return nullptr;
}

void *TeacherThread(void *arg) {
    while (true) {
        pthread_mutex_lock(&mutex);

        // Проверка, ответили ли уже все студенты
        if (answered_students >= num_students) {
            std::cout << "Все студенты сдали экзамен. Программа завершена. Результат записан в выходной файл.";
            output_file << "Все студенты сдали экзамен. ";
            pthread_mutex_unlock(&mutex);
            break;
        }

        // Ожидание сигнала от студента
        while (!is_teacher_active) {
            pthread_cond_wait(&teacher_cond, &mutex);
        }

        // Преподаватель оценивает билет
        int grade = rand() % 10 + 1; // Генерация случайной оценки (от 1 до 10)
        std::cout << "Преподаватель выставляет оценку " << grade << " студенту " << current_student << std::endl;
        output_file << "Преподаватель выставляет оценку " << grade << " студенту " << current_student << std::endl;

        is_teacher_active = false; // Сбрасываем флаг
        pthread_cond_signal(&student_cond); // Сигнал студенту
        pthread_mutex_unlock(&mutex);
    }

    return nullptr;
}

int main() {
    int decision;
    std::cout << "Выберите, как Вы хотите ввести данные, нужные для работы программы: \n"
                 "1. Взять данные из подготовленного файла. \n"
                 "2. Ввести данные в консоль. \n"
                 "0. Выйти из программы. \n"
                 "В качестве ответа введите одну цифру: 0, 1 или 2: ";
    std::cin >> decision;
    while (decision != 0 and decision != 1 and decision != 2) {
        std::cout << "Вы должны ввести только цифры 0, 1 или 2! Попробуйте ещё раз: ";
        std::cin >> decision;
    }

    if (decision == 0) {
        std::cout << "До свидания!";
        return 0;
    } else if (decision == 1) {
        std::string inputFileName;
        std::cout << "Введите полный путь к файлу, из которого надо считать данные: ";
        std::cin >> inputFileName;

        std::ifstream inputFile(inputFileName);

        if (!inputFile.is_open()) {
            std::cerr << "Не удалось открыть файл." << std::endl;
            return 1; // Возвращаем ошибку
        }

        std::cout << "Данные успешно считались из файла! \n";
        inputFile >> num_students;
        inputFile >> output_fileName;

        inputFile.close();
    } else if (decision == 2) {
        std::cout << "Введите число студентов, который будут сдавать экзамен: ";
        std::cin >> num_students;

        std::cout << "Выведите полный путь к файлу, куда записать результат работы программы: ";
        std::cin >> output_fileName;
    }

    output_file.open(output_fileName);

    pthread_t students[num_students];
    pthread_t teacher;

    // Создание потоков студентов
    for (int i = 0; i < num_students; ++i) {
        int *student_id = new int(i + 1);
        pthread_create(&students[i], nullptr, StudentThread, (void *)student_id);
    }

    // Создание потока преподавателя
    pthread_create(&teacher, nullptr, TeacherThread, nullptr);

    // Ожидание завершения потоков студентов
    for (int i = 0; i < num_students; ++i) {
        pthread_join(students[i], nullptr);
    }

    // Ожидание завершения потока преподавателя
    pthread_join(teacher, nullptr);

    return 0;
}


/*

/Users/danila/CLionProjects/untitled3/input.txt

*/
