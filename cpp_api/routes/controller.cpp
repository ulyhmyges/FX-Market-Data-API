#include "routes/controller.hpp"
#include "routes/handlers.hpp"

#include <iostream>
#include <memory>
#include <string>
#include <thread>
#include <string>

namespace routes
{
    http::response<http::string_body> handle_request(http::request<http::string_body> const &req)
    {
        // OPTIONS
        if (req.method() == http::verb::options)
            return handle_options(req);

        // GET
        else if (req.method() == http::verb::get)
        {
            // Extract path without query
            std::string_view target = req.target();
            std::string_view path = target.substr(0, target.find('?'));

            // TODO
            // /option?id=3
            if (path == "/option")
                return handle_get_option_by_id(req);
            
            else if (path == "/health")
                return handle_get_health(req);
            
            else if (path == "/price")
                return handle_get_price(req);

            // /option/all?user_id=1
            else if (path == "/option/all")
                return handle_get_option_by_user_id(req);

            else if (req.target() == "/auth/me")
                return handle_me(req);
        }
        // POST
        else if (req.method() == http::verb::post)
        {
            // Extract path without query
            std::string_view target = req.target();
            std::string_view path = target.substr(0, target.find('?'));

            if (req.target() == "/option")
            {
                return handle_post_option(req);
            }

            else if (req.target() == "/option/price")
                return handle_post_price(req);

            else if (req.target() == "/auth/subscribe")
                return handle_subscribe(req);

            else if (req.target() == "/auth/login")
                return handle_login(req);
        }

        // DELETE
        else if (req.method() == http::verb::delete_)
        {
            // Extract path without query
            std::string_view target = req.target();
            std::string_view path = target.substr(0, target.find('?'));

            if (path == "/option")
            {
                return handle_delete_option_by_id(req);
            }
      
        }

        // Default response for unsupported methods
        return http::response<http::string_body>{http::status::bad_request, req.version()};
    }
}