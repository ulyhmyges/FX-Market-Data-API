cmake_minimum_required(VERSION 3.10)
#cmake_policy(SET CMP0167 NEW)

project(RESTApi)

set(CMAKE_CXX_STANDARD 17)

# automatically find Boost in my system
# CMake set variables
# Boost_FOUND: Whether Boost was found (TRUE or FALSE)

# Boost_INCLUDE_DIRS: The path(s) to Boost's header files (e.g., /usr/include or /usr/local/include)

# Boost_LIBRARIES: The actual .lib or .so files for linking (for the components you requested, like system and filesystem)

# Boost_<component>_LIBRARY: The individual libraries for each component, like Boost_SYSTEM_LIBRARY
find_package(Boost REQUIRED COMPONENTS system filesystem) 

# Required to find OpenSSL and jwt-cpp properly
find_package(OpenSSL REQUIRED)

set(CMAKE_PREFIX_PATH "${CMAKE_SOURCE_DIR}/ext/jwt-cpp/install")

find_package(jwt-cpp CONFIG REQUIRED)

# Find libpqxx
#find_package(PostgreSQL REQUIRED)
find_package(PkgConfig REQUIRED)
#find_package(libpqxx)
pkg_check_modules(LIBPQXX REQUIRED libpqxx)


link_directories(${LIBPQXX_LIBRARY_DIRS})

include_directories(${LIBPQXX_INCLUDE_DIRS}) # /opt/homebrew/Cellar/libpqxx/7.10.1/include
include_directories(${Boost_INCLUDE_DIRS})
include_directories(${CMAKE_SOURCE_DIR})
include_directories(${CMAKE_SOURCE_DIR}/ext/quantlib/include)
include_directories(${CMAKE_SOURCE_DIR}/ext)
#include_directories(${CMAKE_SOURCE_DIR}/ext/jwt-cpp/install/include)
add_subdirectory(${CMAKE_SOURCE_DIR}/ext/cpp-dotenv)
add_subdirectory(${CMAKE_SOURCE_DIR}/ext/bcrypt)

# Add the directory where QuantLib is located
link_directories(${CMAKE_SOURCE_DIR}/ext/quantlib/lib/ubuntu/amd64)

add_executable(RESTApi 
    main.cpp
    option/option.cpp
    routes/controller.cpp
    routes/handlers.cpp
    server/connection.cpp
    database/postgresql.cpp
    utils/utils.cpp
)

target_link_libraries(RESTApi PUBLIC ${Boost_LIBRARIES} QuantLib PRIVATE OpenSSL::SSL OpenSSL::Crypto jwt-cpp::jwt-cpp cpp_dotenv ${LIBPQXX_LDFLAGS} bcrypt) 

# Include dirs and link libs
target_include_directories(RESTApi PRIVATE ${LIBPQXX_INCLUDE_DIRS})


message(STATUS "Boost include dirs: ${Boost_INCLUDE_DIRS}") # -- Boost include dirs: /opt/homebrew/include
message(STATUS "Boost libraries: ${Boost_LIBRARIES}") # -- Boost libraries: Boost::system;Boost::filesystem
message(STATUS "C++ compiler: ${CMAKE_CXX_COMPILER}") # Apple clang version 17.0.0
message(STATUS "cmake prefix path: ${CMAKE_PREFIX_PATH}") # ./libraries/jwt-cpp/install
message(STATUS "LIBPQXX_INCLUDE_DIRS: ${LIBPQXX_INCLUDE_DIRS}") # /opt/homebrew/Cellar/libpqxx/7.10.1/include
message(STATUS "LIBPQXX_LIBRARIES: ${LIBPQXX_LIBRARIES}") # pqxx
message(STATUS "LIBPQXX_LIBRARY_DIRS: ${LIBPQXX_LIBRARY_DIRS}")  # /opt/homebrew/Cellar/libpqxx/7.10.1/lib
message(STATUS "LIBPQXX_LDFLAGS: ${LIBPQXX_LDFLAGS}") # -L/opt/homebrew/Cellar/libpqxx/7.10.1/lib;-lpqxx