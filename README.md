# FX-Market-Data-API

A new Flutter web app that
    - give exchange rates data with EUR as the base currency from external api
    - compute the price of options from backend c++ api
    - persist users and options data on postgreSQL database
    
## Requirements

- make
- Docker

## Getting Started

### Add .env file

- change directory to cpp_api
- Rename .env.dist file to .env
- Initialize variable JWT_SECRET

### Clone and run the project

```shell
git clone https://github.com/ulyhmyges/FX-Market-Data-API.git
cd FX-Market-Data-API
make all
```

That will build the project and the result is at <http://localhost:88>

## API project

location: ./cpp_api

The [README.md](./cpp_api/README.md) of the project

### Externe Libraries used

- [bcrypt](./cpp_api/libraries/bcrypt/)
- [cpp-dotenv](./cpp_api/libraries/cpp-dotenv/)
- [jwt-cpp](./cpp_api/libraries/jwt-cpp/)
- [nlohmann](./cpp_api/libraries/nlohmann/)
- [Quantlib](./cpp_api/libraries/local/)

## Flutter project

location: ./flutter_app

The [README.md](./flutter_app/README.md) of the project
