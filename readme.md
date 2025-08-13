
# Используем легковесный образ
FROM debian:bullseye-slim

# Устанавливаем необходимые пакеты
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    unzip \
    cmake

# Создаём рабочую директорию
WORKDIR /build

# Загружаем исходники SQLite, разархивируем
RUN wget https://www.sqlite.org/2018/sqlite-amalgamation-3260000.zip && \
    unzip sqlite-amalgamation-3260000.zip

# Переходим в новую рабочую директорию
WORKDIR /build/sqlite-amalgamation-3260000

# создаем файл CMakeLists.txt
RUN cat <<EOF > CMakeLists.txt
            cmake_minimum_required(VERSION 3.10)
            project(sqlite3 C)
            set(SQLITE_SOURCES sqlite3.c)
            set(SQLITE_HEADERS sqlite3.h)
            add_library(sqlite3 SHARED \${SQLITE_SOURCES})
            target_include_directories(sqlite3 PUBLIC \${CMAKE_CURRENT_SOURCE_DIR})
            set_target_properties(sqlite3 PROPERTIES OUTPUT_NAME "sqlite3" PREFIX "lib" SUFFIX ".so")
EOF

# создаем директорию build, компилируем и выводим лог в файл build.log
RUN mkdir build && cd build && \
    cmake .. && make > build.log 2>&1

# Добавляем оболочку при запуске
CMD ["bash"]




# создаем образ из dockerfile
docker build -t sqlite-builder .

# стартуем контейнер (плюс добавляем опции, чтобы не завершался)
docker run -dit --name sqlite-builder sqlite-builder

# входим
docker exec -it sqlite-builder bash