# libraries/bcrypt/CMakeLists.txt
cmake_minimum_required(VERSION 3.10)

project(bcrypt C)

# Collect Blowfish sources
file(GLOB CRYPT_BLOWFISH_SOURCES
    crypt_blowfish/*.c
)

add_library(bcrypt STATIC
    bcrypt.c
    ${CRYPT_BLOWFISH_SOURCES}
)

target_include_directories(bcrypt PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/crypt_blowfish
)

# Optionally compile with stricter flags
target_compile_options(bcrypt PRIVATE -Wall -Wextra -O2)
