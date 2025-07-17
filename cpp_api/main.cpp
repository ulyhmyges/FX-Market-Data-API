#include "option/option.hpp"
#include "routes/controller.hpp"
#include "server/connection.hpp"

#include <iostream>
#include <memory>
#include <string>
#include <thread>
//#include <string>


int main() {
    try {
        auto const address = net::ip::make_address("127.0.0.1");
        unsigned short port = 8081;

        net::io_context ioc{1};

        auto test = std::make_shared<server::Listener>(ioc, tcp::endpoint{address, port});
        
        ioc.run();
    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
    }
}