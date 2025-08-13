FROM debian:bullseye-slim
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    unzip \
    cmake
WORKDIR /build
RUN wget https://www.sqlite.org/2018/sqlite-amalgamation-3260000.zip && \
    unzip sqlite-amalgamation-3260000.zip 
WORKDIR /build/sqlite-amalgamation-3260000
RUN cat <<EOF > CMakeLists.txt
            cmake_minimum_required(VERSION 3.10)
            project(sqlite3 C)
            set(SQLITE_SOURCES sqlite3.c)
            set(SQLITE_HEADERS sqlite3.h)
            add_library(sqlite3 SHARED \${SQLITE_SOURCES})
            target_include_directories(sqlite3 PUBLIC \${CMAKE_CURRENT_SOURCE_DIR})
            set_target_properties(sqlite3 PROPERTIES OUTPUT_NAME "sqlite3" PREFIX "lib" SUFFIX ".so")
EOF
RUN mkdir build && cd build && \
    cmake .. && make > build.log 2>&1
CMD ["bash"]


