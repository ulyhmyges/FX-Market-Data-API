#include "server/connection.hpp"
#include "routes/controller.hpp"

#include <boost/asio/strand.hpp>
#include <iostream>

namespace server
{
    server::Session::Session(tcp::socket socket) : socket_(std::move(socket)) {}

    void Session::run()
    {
        do_read();
    }

    void Session::do_read()
    {
        auto self(shared_from_this());
        http::async_read(socket_, buffer_, req_, [this, self](beast::error_code ec, std::size_t)
                         {
            if (!ec) {
                do_write(routes::handle_request(req_));
            } });
    }

    void Session::do_write(http::response<http::string_body> res)
    {
        auto self(shared_from_this());
        auto sp = std::make_shared<http::response<http::string_body>>(std::move(res));
        http::async_write(socket_, *sp, [this, self, sp](beast::error_code ec, std::size_t)
                          { socket_.shutdown(tcp::socket::shutdown_send, ec); });
    }

    server::Listener::Listener(net::io_context &ioc, tcp::endpoint endpoint)
        : ioc_(ioc), acceptor_(net::make_strand(ioc))
    {
        beast::error_code ec;

        // Open the acceptor
        acceptor_.open(endpoint.protocol(), ec);
        if (ec)
        {
            std::cerr << "Open error: " << ec.message() << std::endl;
            return;
        }

        // Allow address reuse
        acceptor_.set_option(net::socket_base::reuse_address(true), ec);
        if (ec)
        {
            std::cerr << "Set option error: " << ec.message() << std::endl;
            return;
        }

        // Bind to the server address
        acceptor_.bind(endpoint, ec);
        if (ec)
        {
            std::cerr << "Bind error: " << ec.message() << std::endl;
            return;
        }

        // Start listening for connections
        acceptor_.listen(net::socket_base::max_listen_connections, ec);
        if (ec)
        {
            std::cerr << "Listen error: " << ec.message() << std::endl;
            return;
        }

        std::cout << "The server is running on port " << endpoint.port() << "...\n";
        do_accept();
    }

    void Listener::do_accept()
    {
        acceptor_.async_accept(net::make_strand(ioc_), [this](beast::error_code ec, tcp::socket socket)
                               {
            if (!ec) {
                std::make_shared<Session>(std::move(socket))->run();
            }
            do_accept(); });
    }
}