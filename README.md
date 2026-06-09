# FX-Market-Data-API

A new Flutter web app that
    - give exchange rates data with EUR as the base currency from external api
    - compute the price of options from backend c++ api
    - persist users and options data on postgreSQL database

## Getting Started

### Clone and run the project

```shell
git clone https://github.com/ulyhmyges/FX-Market-Data-API.git
cd FX-Market-Data-API
make all
```

That will build the project and the result is at <http://localhost:88>



## cpp_api

### Add .env file

- Rename .env.dist file to .env
- Initialize environement variable JWT_SECRET

### Need these following requirements to run the API

The [CMakeList.txt](./cpp_api/CMakeLists.txt) will look in your system for these two libraries

- Boost library
- libpqxx library
- OpenSSL
- Docker

```shell
brew install boost
brew install libpqxx
brew install openssl
```

### Libraries in the project

- [bcrypt](./cpp_api/libraries/bcrypt/)
- [cpp-dotenv](./cpp_api/libraries/cpp-dotenv/)
- [jwt-cpp](./cpp_api/libraries/jwt-cpp/)
- [nlohmann](./cpp_api/libraries/nlohmann/)
- [Quantlib](./cpp_api/libraries/local/)

The [README.md](./cpp_api/README.md) of the project

## fluter_app

The [README.md](./flutter_app/README.md) of the project
