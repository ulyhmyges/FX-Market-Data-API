#pragma once

// #include <boost/beast/core.hpp>
#include <boost/beast/http.hpp>

namespace http = boost::beast::http; // from <boost/beast/http.hpp>

namespace routes
{
    template <typename Response>
    void add_cors_headers(Response &res);

    // These functions produce an HTTP response for the given request.
    http::response<http::string_body> handle_subscribe(http::request<http::string_body> const &req);
    http::response<http::string_body> handle_login(http::request<http::string_body> const &req);
    http::response<http::string_body> handle_me(http::request<http::string_body> const &req);
    http::response<http::string_body> handle_post_price(http::request<http::string_body> const &req);
    http::response<http::string_body> handle_get_price(http::request<http::string_body> const &req);
    http::response<http::string_body> handle_post_option(http::request<http::string_body> const &req);
    http::response<http::string_body> handle_get_option_by_id(http::request<http::string_body> const &req);
    http::response<http::string_body> handle_get_option_by_user_id(http::request<http::string_body> const &req);
    http::response<http::string_body> handle_options(http::request<http::string_body> const &req);
    http::response<http::string_body> handle_delete_option_by_id(http::request<http::string_body> const &req);
    http::response<http::string_body> handle_get_health(http::request<http::string_body> const &req);

    // Mock function to store user (you should replace this)
    bool store_user(const std::string &username, const std::string &password);
}