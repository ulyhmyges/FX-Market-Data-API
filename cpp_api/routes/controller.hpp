#pragma once
#include <boost/beast/core.hpp>
#include <boost/beast/http.hpp>
// #include <boost/beast/version.hpp>
// #include <boost/asio/ip/tcp.hpp>
// #include <boost/asio/strand.hpp>
// #include <boost/config.hpp>

namespace beast = boost::beast; // from <boost/beast.hpp>
namespace http = beast::http;   // from <boost/beast/http.hpp>
namespace net = boost::asio;    // from <boost/asio.hpp>
using tcp = net::ip::tcp;       // from <boost/asio/ip/tcp.hpp>

namespace routes
{
    /**
     * @brief Handles incoming HTTP requests and routes them to appropriate handlers.
     * 
     * This function inspects the HTTP method and target (URL path) of the request,
     * then delegates handling to the corresponding route handler (e.g., /auth/login, /auth/me).
     * 
     * @param req The incoming HTTP request with a string body.
     * @return An HTTP response corresponding to the requested route and method.
     */
    http::response<http::string_body> handle_request(http::request<http::string_body> const &req);
}