#include <iostream>
#include <pthread.h>
#include <unistd.h>
#include <fstream>
#include <random>
#include <vector>

pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t student_cond = PTHREAD_COND_INITIALIZER;
pthread_cond_t teacher_cond = PTHREAD_COND_INITIALIZER;

std::vector<int> tickets_number;
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

        int queue_time = rand() % 2 + 1;
        int preparation_time = rand() % 3 + 1;

        sleep(queue_time);
        // Студент выбирает билет
        std::cout << "Студент " << student_id << " выбрал билет: " << tickets_number[student_id - 1] << std::endl;
        output_file << "Студент " << student_id << " выбрал билет: " << tickets_number[student_id - 1] << std::endl;

        pthread_mutex_unlock(&mutex);

        // Очередь перед следующим студентом
        sleep(queue_time);

        // Защита билета
        pthread_mutex_lock(&mutex);
        std::cout << "Студент " << student_id << " защищает билет: " << tickets_number[student_id - 1] << std::endl;
        output_file << "Студент " << student_id << " защищает билет: " << tickets_number[student_id - 1] << std::endl;
        sleep(preparation_time);
        is_teacher_active = true;
        current_student = student_id;
        answered_students++;
        pthread_cond_signal(&teacher_cond);
        pthread_mutex_unlock(&mutex);
        sleep(preparation_time);

        // Ожидание ответа от преподавателя
        pthread_mutex_lock(&mutex);
        while (is_teacher_active) {
            pthread_cond_wait(&student_cond, &mutex);
        }
        pthread_mutex_unlock(&mutex);
        sleep(1);

        break;
    }

    pthread_exit(NULL); // Явное завершение потока
}

void *TeacherThread(void *arg) {
    while (true) {
        pthread_mutex_lock(&mutex);

        if (answered_students >= num_students) {
            std::cout << "Все студенты сдали экзамен. Программа завершена. Результат записан в выходной файл.";
            output_file << "Все студенты сдали экзамен. ";
            pthread_mutex_unlock(&mutex);
            break;
        }

        while (!is_teacher_active) {
            pthread_cond_wait(&teacher_cond, &mutex);
        }

        int checking_time = rand() % 2 + 1;

        std::cout << "Преподаватель проверяет работу студента " << current_student << std::endl;
        output_file << "Преподаватель проверяет работу студента " << current_student << std::endl;
        sleep(checking_time);
        int grade = rand() % 10 + 1;
        std::cout << "Преподаватель выставляет оценку " << grade << " студенту " << current_student << std::endl;
        output_file << "Преподаватель выставляет оценку " << grade << " студенту " << current_student << std::endl;

        is_teacher_active = false;
        pthread_cond_signal(&student_cond);
        pthread_mutex_unlock(&mutex);
    }

    pthread_exit(NULL);
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

    for (int i = 0; i < num_students; ++i) {
        std::random_device rd;
        std::mt19937 gen(rd());
        std::uniform_int_distribution<int> dis(2, 30);

        int ticket_number = dis(gen);
        auto ind = std::find(tickets_number.begin(), tickets_number.end(), ticket_number);

        while (ind != tickets_number.end())
        {
            ticket_number = dis(gen);
            ind = std::find(tickets_number.begin(), tickets_number.end(), ticket_number);
        }

        tickets_number.push_back(ticket_number);
    }

    // Создание потоков студентов
    for (int i = 0; i < num_students; ++i) {
        int *student_id = new int(i + 1);
        pthread_create(&students[i], NULL, StudentThread, (void *)student_id);
    }

    // Создание потока преподавателя
    pthread_create(&teacher, NULL, TeacherThread, NULL);

    // Ожидание завершения потоков студентов
    for (int i = 0; i < num_students; ++i) {
        pthread_join(students[i], NULL);
    }

    // Ожидание завершения потока преподавателя
    pthread_join(teacher, NULL);

    return 0;
}


/*

/Users/danila/CLionProjects/untitled3/input.txt

*/
