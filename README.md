# pricer_app

A new Flutter project on forex prices and pricing options on forex

## Getting Started

Run the web app

```shell
cd flutter_app
flutter run -d chrome
```

Run the API

```shell
cd cpp_api
make start
```

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
