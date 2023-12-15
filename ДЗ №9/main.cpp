#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <random>
#include <iostream>

// Размер буфера
#define BUFFER_SIZE 50
// Число потоков
#define THREADS_NUMBER 20

// Общий буфер, в который помещаются числа
int buffer[BUFFER_SIZE];
// Текущий индекс в буфере
int currentNumber = 0;
// Мьютекс для безопасного доступа к буферу
pthread_mutex_t bufferMutex;
// Условная переменная для сигнализации об изменении буфера
pthread_cond_t bufferCond;

// Количество активных генераторов и сумматоров
int generators = THREADS_NUMBER;
int summators = 0;
// Окончательный результат
int result = 0;

// Инициализация функций
void* sumThread(void* args);
void* observeThread(void* arg);
void* generatorThread(void* arg);

int main() {
    // Инициализация мьютекса и условной переменной
    pthread_mutex_init(&bufferMutex, nullptr);
    pthread_cond_init(&bufferCond, nullptr);

    // Создание потока отслеживания буфера
    pthread_t observer;
    pthread_create(&observer, nullptr, observeThread, nullptr);

    // Создание потоков генераторов
    for (int i = 1; i <= THREADS_NUMBER; ++i) {
        pthread_t thread;
        int* number = new int;
        *number = i;

        // Запуск потока генератора
        pthread_create(&thread, nullptr, generatorThread, number);
    }

    // Ожидание завершения потока отслеживания буфера
    pthread_join(observer, nullptr);

    // Уничтожение мьютекса и условной переменной
    pthread_mutex_destroy(&bufferMutex);
    pthread_cond_destroy(&bufferCond);

    // Вывод окончательного результата
    std::cout << "Result: " <<  result << std::endl;

    return 0;
}

// Функция для суммирования чисел с задержкой
void* sumThread(void* args) {
    sleep(rand() % 3 + 3);

    pthread_mutex_lock(&bufferMutex);

    // Получение чисел для суммирования
    int* numbers = (int*) args;
    int sum = numbers[0] + numbers[1];
    std::cout << "SumThread summed numbers {" << numbers[0] << ", " << numbers[1] << "} and sent result " << sum << " to buffer" << std::endl;

    // Помещение результата суммирования в буфер
    buffer[currentNumber++] = sum;
    // Уменьшение счетчика активных сумматоров
    summators--;

    // Сигнализация об изменении буфера
    pthread_cond_signal(&bufferCond);
    pthread_mutex_unlock(&bufferMutex);

    return nullptr;
}

// Функция для генерации случайного числа с задержкой
void* generatorThread(void* arg) {
    sleep(rand() % 7 + 1);

    pthread_mutex_lock(&bufferMutex);

    // Генерация случайного числа от 1 до 20
    int number = rand() % 20 + 1;
    std::cout << "Generator Thread sent number " << number << " to buffer\n";

    // Помещение числа в буфер
    buffer[currentNumber++] = number;
    // Уменьшение счетчика активных генераторов
    generators--;

    // Сигнализация об изменении буфера
    pthread_cond_signal(&bufferCond);
    pthread_mutex_unlock(&bufferMutex);

    return nullptr;
}

// Функция для отслеживания буфера и запуска сумматоров
void* observeThread(void* arg) {
    while (true) {
        pthread_mutex_lock(&bufferMutex);

        // Ждем, пока в буфере не будет хотя бы двух чисел или не завершатся генераторы и сумматоры
        while (currentNumber < 2 && !(generators == 0 && summators == 0)) {
            pthread_cond_wait(&bufferCond, &bufferMutex);
        }

        if (currentNumber >= 2) {
            // Создаем массив чисел для суммирования
            int* numbers = new int[2];
            numbers[0] = buffer[--currentNumber];
            numbers[1] = buffer[--currentNumber];

            // Увеличиваем счетчик активных сумматоров
            summators++;

            // Разблокируем мьютекс, чтобы другие потоки могли продолжить выполнение
            pthread_mutex_unlock(&bufferMutex);

            // Запускаем поток сумматора
            pthread_t adder;
            pthread_create(&adder, nullptr, sumThread, numbers);
        } else if (generators == 0 && summators == 0) {
            // Завершаем работу, если генераторы и сумматоры завершились
            result = buffer[0];

            // Разблокируем мьютекс и завершаем поток
            pthread_mutex_unlock(&bufferMutex);
            return nullptr;
        } else {
            // Если нет двух чисел в буфере и не все генераторы/сумматоры завершились,
            // разблокируем мьютекс и продолжаем ожидание
            pthread_mutex_unlock(&bufferMutex);
        }
    }
}
