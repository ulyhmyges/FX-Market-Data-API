# RESTApi

Create a Restful API server using C++ library (Boost.Beast)

## Running the server

```shell
make start
```

## Installation

- Install OpenSSL
```shell
brew install openssl
```

- Clone and install jwt-cpp in the project

```shell
cd libraries
git clone https://github.com/Thalhammer/jwt-cpp.git
cd jwt-cpp
cmake -S . -B build -DJWT_BUILD_EXAMPLES=OFF -DJWT_BUILD_TESTS=OFF -DCMAKE_INSTALL_PREFIX=./install
cmake --build build
cmake --install build
```

- Use jwt-cpp in the project

In `CMakeLists.txt` file:

```shell
cmake_minimum_required(VERSION 3.14)
project(my_app)

# Required to find OpenSSL and jwt-cpp properly
find_package(OpenSSL REQUIRED)
find_package(jwt-cpp CONFIG REQUIRED)

target_link_libraries(my_app
    PRIVATE
        OpenSSL::SSL
        OpenSSL::Crypto
        jwt-cpp::jwt-cpp
)
```

- clone and install dotenv-cpp

```shell
git clone https://github.com/adeharo9/cpp-dotenv.git
cd dotenv-cpp
cmake -S . -B build
sudo cmake --install build
```

- Use dotenv-cpp in the project
In `CMakeLists.txt`file:

```shell
add_subdirectory(${CMAKE_SOURCE_DIR}/libraries/cpp-dotenv)
target_link_libraries(RESTApi PTIVATE cpp_dotenv)
```

- Install library bcrypt

```shell
git clone https://github.com/rg3/bcrypt.git libraries/bcrypt

```


- start the service PostgreSQL

```shell

docker compose up --build
```

- C++ connector for PostgreSQL

```shell
brew install libpqxx
brew install pkg-config
```

- Verification 

```shell
psql --version        # PostgreSQL CLI
pg_config --version   # PostgreSQL config tool
pkg-config --modversion libpqxx  # Should print libpqxx version
```

## Tutorial API

<https://medium.com/@AlexanderObregon/building-restful-apis-with-c-4c8ac63fe8a7>

## add JSON support

<https://github.com/nlohmann/json>

## currency API

Exchange rates: <https://frankfurter.dev>
<https://api.frankfurter.app/latest?from=EUR&to=USD>
