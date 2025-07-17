#pragma once
#include <boost/beast/core.hpp>
#include <boost/beast/http.hpp>


namespace beast = boost::beast; // from <boost/beast.hpp>
namespace http = beast::http;   // from <boost/beast/http.hpp>
namespace net = boost::asio;    // from <boost/asio.hpp>
using tcp = net::ip::tcp;       // from <boost/asio/ip/tcp.hpp>


namespace server
{
    // This class handles an HTTP server connection.
    class Session : public std::enable_shared_from_this<Session>
    {
        tcp::socket socket_;
        beast::flat_buffer buffer_;
        http::request<http::string_body> req_;

    public:
        explicit Session(tcp::socket socket);

        void run();

    private:
        void do_read();
        void do_write(http::response<http::string_body> res);
    };

    // This class accepts incoming connections and launches the sessions.
    class Listener : public std::enable_shared_from_this<Listener>
    {
        net::io_context &ioc_;
        tcp::acceptor acceptor_;

    public:
        Listener(net::io_context &ioc, tcp::endpoint endpoint);

    private:
        void do_accept();
    };
}