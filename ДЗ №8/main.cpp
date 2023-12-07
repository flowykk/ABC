#include <iostream>
#include <vector>
#include <chrono>

const int vectorSize = 10000000;
const int numThreads = 4;

std::vector<double> vectorA(vectorSize);
std::vector<double> vectorB(vectorSize);
double resultWithThreads = 0.0;
double resultWithoutThreads = 0.0;
pthread_mutex_t mutexResult;


// Генерация векторов A и B
void GenerateVectors() {
    for (int i = 0; i < vectorSize; ++i) {
        vectorA[i] = i + 1.0;
        vectorB[i] = vectorSize - i;
    }
}

void* VectorProduct(void* param) {
    int threadId = *((int*)param);

    int chunkSize = vectorSize / numThreads;
    int startIndex = threadId * chunkSize;
    int endIndex = startIndex + chunkSize;

    double partialResult = 0.0;
    for (int i = startIndex; i < endIndex; ++i) {
        partialResult += vectorA[i] * vectorB[i];
    }

    pthread_mutex_lock(&mutexResult);
    resultWithThreads += partialResult;
    pthread_mutex_unlock(&mutexResult);

    return nullptr;
}

// Вычисление векторного произведения без использования потоков
void VectorProductWithoutThreads() {
    for (int i = 0; i < vectorSize; ++i) {
        resultWithoutThreads += vectorA[i] * vectorB[i];
    }
}

int main() {
    GenerateVectors();
    pthread_mutex_init(&mutexResult, nullptr);

    auto startTimeThreads = std::chrono::high_resolution_clock::now();

    pthread_t threads[numThreads];
    int threadIds[numThreads];

    for (int i = 0; i < numThreads; ++i) {
        threadIds[i] = i;
        pthread_create(&threads[i], nullptr, VectorProduct, (void*)&threadIds[i]);
    }

    for (int i = 0; i < numThreads; ++i) {
        pthread_join(threads[i], nullptr);
    }

    pthread_mutex_destroy(&mutexResult);

    auto endTimeThreads = std::chrono::high_resolution_clock::now();
    auto durationThreads = std::chrono::duration_cast<std::chrono::milliseconds>(endTimeThreads - startTimeThreads);

    auto startTimeWithoutThreads = std::chrono::high_resolution_clock::now();

    VectorProductWithoutThreads();

    auto endTimeWithoutThreads = std::chrono::high_resolution_clock::now();
    auto durationWithoutThreads = std::chrono::duration_cast<std::chrono::milliseconds>(endTimeWithoutThreads - startTimeWithoutThreads);

    std::cout << "Vector product result with 4 threads: " << resultWithThreads << std::endl;
    std::cout << "Execution time with 4 threads: " << durationThreads.count() << " milliseconds" << std::endl;

    std::cout << "Vector product result with 1 thread: " << resultWithoutThreads << std::endl;
    std::cout << "Execution time with 1 thread: " << durationWithoutThreads.count() << " milliseconds" << std::endl;

    return 0;
}
