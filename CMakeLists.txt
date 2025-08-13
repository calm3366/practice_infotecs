cmake_minimum_required(VERSION 3.10)
project(sqlite3 C)

# Указываем исходники
set(SQLITE_SOURCES
    sqlite3.c
)

# Указываем заголовки (для IDE и установки)
set(SQLITE_HEADERS
    sqlite3.h
)

# Создаём shared library
add_library(sqlite3 SHARED ${SQLITE_SOURCES})

# Устанавливаем заголовки
target_include_directories(sqlite3 PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

# Устанавливаем свойства для Windows
if (WIN32)
    set_target_properties(sqlite3 PROPERTIES
        OUTPUT_NAME "sqlite3"
        PREFIX ""
        SUFFIX ".dll"
    )
endif()

# Устанавливаем свойства для Linux
if (UNIX)
    set_target_properties(sqlite3 PROPERTIES
        OUTPUT_NAME "sqlite3"
        PREFIX "lib"
        SUFFIX ".so"
    )
endif()
