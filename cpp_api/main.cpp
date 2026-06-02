#include "option/option.hpp"
#include "routes/controller.hpp"
#include "server/connection.hpp"

#include <iostream>
#include <memory>
#include <string>
#include <thread>
//#include <string>

void set(char*& out, const char* ref){
    out = new char[strlen(ref) + 1];
    strcpy(out, ref);
}

int main() {
    try {
        auto const address = net::ip::make_address("0.0.0.0");
        unsigned short port = 8081;

        net::io_context ioc{1};

        auto test = std::make_shared<server::Listener>(ioc, tcp::endpoint{address, port});
        
        ioc.run();
        char* val = NULL;
        set(val, "A message");
        printf("%s\n", val);
        std::cout << "hello\n" ;
    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
    }
}