#include "routes/handlers.hpp"
#include "nlohmann/json.hpp"
#include "option/option.hpp"
#include <jwt-cpp/jwt.h>
#include "dotenv.h"
#include "database/postgresql.hpp"
#include "utils/utils.hpp"

namespace routes
{
    template <typename Response>
    void add_cors_headers(Response &res)
    {
        res.set(http::field::access_control_allow_origin, "*");
        res.set(http::field::access_control_allow_methods, "GET, POST, PUT, DELETE, OPTIONS");
        res.set(http::field::access_control_allow_headers, "Content-Type, Authorization");
    }
    // method: OPTION
    // route: *
    http::response<http::string_body> handle_options(http::request<http::string_body> const &req)
    {
        http::response<http::string_body> res{http::status::no_content, req.version()};
        add_cors_headers(res);
        res.set(http::field::content_length, "0");
        res.keep_alive(req.keep_alive());
        return res;
    }

    // method: POST
    // route: /price
    http::response<http::string_body> handle_post_price(http::request<http::string_body> const &req)
    {
        try
        {
            auto body = nlohmann::json::parse(req.body());
            option::OptionRequest opt = body.get<option::OptionRequest>();

            // std::string response_message = body.dump();
            nlohmann::json json = {{"price", opt.compute()}};
            http::response<http::string_body> res{http::status::ok, req.version()};
            add_cors_headers(res);
            res.set(http::field::server, "Beast");
            res.set(http::field::content_type, "application/json");
            res.keep_alive(req.keep_alive());
            res.body() = json.dump();
            res.prepare_payload();
            return res;
        }
        catch (const std::exception &e)
        {
            http::response<http::string_body> res{http::status::bad_request, req.version()};
            add_cors_headers(res);
            res.set(http::field::content_type, "text/plain");
            res.keep_alive(req.keep_alive());
            res.body() = std::string("Invalid JSON: ") + e.what();
            res.prepare_payload();
            return res;
        }
    }

    // method: POST
    // route: /auth/subscribe
    http::response<http::string_body> handle_subscribe(http::request<http::string_body> const &req)
    {
        http::response<http::string_body> res;
        add_cors_headers(res); // add CORS hearders

        try
        {
            auto body = nlohmann::json::parse(req.body());
            std::string pseudo = body.at("pseudo");
            std::string password = body.at("password");

            if (pseudo.empty() || password.empty())
            {
                res.result(http::status::bad_request);
                res.body() = R"({"error": "Username and password are required."})";
                res.set(http::field::content_type, "application/json");
                return res;
            }

            // Try to store user
            if (!database::store_user(pseudo, password))
            {
                res.result(http::status::conflict);
                res.body() = R"({"error": "User already exists."})";
                res.set(http::field::content_type, "application/json");
                return res;
            }

            // Success 201
            res.result(http::status::created);
            res.body() = R"({"message": "User registered successfully."})";
            res.set(http::field::content_type, "application/json");
            return res;
        }
        catch (const nlohmann::json::exception &e)
        {
            res.result(http::status::bad_request); // 400
            res.body() = R"({"error": "Invalid JSON payload."})";
            res.set(http::field::content_type, "application/json");
            return res;
        }
        catch (const std::exception &e)
        {
            res.result(http::status::internal_server_error);
            res.body() = R"({"error": "Server error."})";
            res.set(http::field::content_type, "application/json");
            return res;
        }
    }

    // method: POST
    // route: /auth/login
    http::response<http::string_body> handle_login(http::request<http::string_body> const &req)
    {
        http::response<http::string_body> res;
        add_cors_headers(res);

        auto credentials = nlohmann::json::parse(req.body());
        std::string pseudo = credentials["pseudo"];
        std::string password = credentials["password"];
        dotenv::env.load_dotenv("../.env", true);

        if (database::retrieve_user(pseudo, password))
        {
            // generate token
            auto token = jwt::create()
                             .set_issuer("RESTApi")
                             .set_type("JWT")
                             .set_subject(pseudo)
                             .set_issued_at(std::chrono::system_clock::now())
                             .set_expires_at(std::chrono::system_clock::now() + std::chrono::minutes{1})
                             .sign(jwt::algorithm::hs256{dotenv::env["JWT_SECRET"]});

            nlohmann::json response = {{"token", token}};
            res.result(http::status::ok);
            res.version(req.version());
            res.set(http::field::content_type, "application/json");
            res.body() = response.dump();
            res.prepare_payload();
            return res;
        }
        res.result(http::status::unauthorized);
        res.version(req.version());
        return res;
    }

    // method: GET
    // route: /auth/me
    http::response<http::string_body> handle_me(http::request<http::string_body> const &req)
    {
        std::string auth_header = req[http::field::authorization];
        if (auth_header.find("Bearer ") != 0)
        {
            return {http::status::unauthorized, req.version()};
        }
        try
        {
            std::string token = auth_header.substr(7); // Skip "Bearer "
            dotenv::env.load_dotenv("../.env", true);
            const std::pair<bool, std::string> pair = utils::is_token_expired(token, dotenv::env["JWT_SECRET"]);
            const unsigned int user_id = database::check_user(pair.second);

            http::response<http::string_body> res{http::status::ok, req.version()};
            add_cors_headers(res); // add CORS hearders
            res.set(http::field::content_type, "application/json");
            nlohmann::json body = {{"token_expired", pair.first}, {"pseudo", pair.second}, {"user_id", user_id}};
            res.body() = body.dump();
            res.prepare_payload();
            return res;
        }
        catch (std::exception const &e)
        {
            return {http::status::bad_request, req.version()};
        }
    }

    // method: POST
    // route: /option
    http::response<http::string_body> handle_post_option(http::request<http::string_body> const &req)
    {
        http::response<http::string_body> res;
        add_cors_headers(res);
        try
        {
            auto body = nlohmann::json::parse(req.body());
            option::OptionRequest option = body.get<option::OptionRequest>();
            dotenv::env.load_dotenv("../.env", true);

            if (database::check_user(option.client))
            {
                database::update_or_store_option(option);
                res.result(http::status::ok);
                res.version(req.version());
                res.set(http::field::content_type, "application/json");
                res.keep_alive(req.keep_alive());
                res.body() = R"({"state": "stored"})";
                res.prepare_payload();
                return res;
            }
        }
        catch (const std::exception &err)
        {
            std::cerr << "Store option failed: " << err.what();
        }
        res.result(http::status::unauthorized);
        res.version(req.version());
        res.set(http::field::content_type, "application/json");
        // res.keep_alive(req.keep_alive());
        res.body() = R"({"state": "unstored"})";
        res.prepare_payload();
        return res;
    }

    // TODO
    // method: GET
    // route: /option?id=5
    http::response<http::string_body> handle_get_option_by_id(http::request<http::string_body> const &req)
    {
        http::response<http::string_body> res;
        try
        {
            // Parse the query string for the "id" parameter
            std::string target = std::string(req.target()); // e.g., /option?id=5
            std::string id;

            auto pos = target.find('?');
            if (pos != std::string::npos)
            {
                std::string query = target.substr(pos + 1); // e.g., id=5
                std::istringstream queryStream(query);
                std::string keyValue;

                while (std::getline(queryStream, keyValue, '&'))
                {
                    auto eqPos = keyValue.find('=');
                    if (eqPos != std::string::npos)
                    {
                        std::string key = keyValue.substr(0, eqPos);
                        std::string value = keyValue.substr(eqPos + 1);
                        if (key == "id")
                        {
                            id = value;
                            break;
                        }
                    }
                }
            }

            if (id.empty())
            {
                res.result(http::status::bad_request);
                res.body() = "Missing 'id' query parameter";
            }
            else
            {
                // TODO: Retrieve option by ID from the database
                // For example:
                // Option option = database.get_option_by_id(id);
                // res.body() = serialize_to_json(option);

                res.result(http::status::ok);
                res.body() = R"({"id": )" + id + R"(, "message": "Option fetched"})";
            }
        }
        catch (const std::exception &e)
        {
            res.result(http::status::internal_server_error);
            res.body() = std::string("Internal Server Error: ") + e.what();
        }

        res.version(req.version());
        res.set(http::field::server, "Beast");
        res.set(http::field::content_type, "application/json");
        res.keep_alive(req.keep_alive());

        return res;
    }

    // method: GET
    // route: /option/all?user_id=1
    http::response<http::string_body> handle_get_option_by_user_id(http::request<http::string_body> const &req)
    {
        http::response<http::string_body> res;
        add_cors_headers(res);
        try
        {
            // Parse the query string for the "id" parameter
            std::string target = std::string(req.target()); // e.g., /option?id=5
            std::string user_id;

            auto pos = target.find('?');
            if (pos != std::string::npos)
            {
                std::string query = target.substr(pos + 1); // e.g., id=5
                std::istringstream queryStream(query);
                std::string keyValue;

                while (std::getline(queryStream, keyValue, '&'))
                {
                    auto eqPos = keyValue.find('=');
                    if (eqPos != std::string::npos)
                    {
                        std::string key = keyValue.substr(0, eqPos);
                        std::string value = keyValue.substr(eqPos + 1);
                        if (key == "user_id")
                        {
                            user_id = value;
                            break;
                        }
                    }
                }
            }

            if (user_id.empty())
            {
                res.result(http::status::bad_request);
                res.body() = "Missing 'user_id' query parameter";
            }
            else
            {
                std::vector<option::OptionRequest> options = database::get_option_by_user_id(user_id);
                nlohmann::json body_array = nlohmann::json::array();

                for (const auto &option : options)
                    body_array.push_back(option);

                res.body() = body_array.dump();
                res.prepare_payload();

                res.result(http::status::ok);
            }

        
        }

        catch (const std::exception &e)
        {
            res.result(http::status::internal_server_error);
            res.body() = std::string("Internal Server Error: ") + e.what();
        }

        res.version(req.version());
        res.set(http::field::server, "Beast");
        res.set(http::field::content_type, "application/json");

        return res;
    }

    // method: GET
    // route: /price
    http::response<http::string_body> handle_get_price(http::request<http::string_body> const &req)
    {
        http::response<http::string_body> res;
             add_cors_headers(res); // add CORS hearders
        try
        {
            const double price = 11;
            nlohmann::json json = {{"price", price}};
            res.result(http::status::ok);
       
            res.set(http::field::server, "Beast");
            res.set(http::field::content_type, "application/json");
            res.keep_alive(req.keep_alive());
            res.body() = json.dump();
            res.prepare_payload();
            return res;
        }
        catch (std::exception const &e)
        {
            res.result(http::status::bad_request);
            res.body() = R"({"error": "bad request"})";
            res.set(http::field::content_type, "application/json");
            return res;
        }
    }


    // method: DELETE
    // route: /option/all?user_id=1
    http::response<http::string_body> handle_delete_option_by_id(http::request<http::string_body> const &req)
    {
        http::response<http::string_body> res;
        add_cors_headers(res);
        try
        {
            // Parse the query string for the "id" parameter
            std::string target = std::string(req.target()); // e.g., /option?id=5
            std::string id;

            auto pos = target.find('?');
            if (pos != std::string::npos)
            {
                std::string query = target.substr(pos + 1); // e.g., id=5
                std::istringstream queryStream(query);
                std::string keyValue;

                while (std::getline(queryStream, keyValue, '&'))
                {
                    auto eqPos = keyValue.find('=');
                    if (eqPos != std::string::npos)
                    {
                        std::string key = keyValue.substr(0, eqPos);
                        std::string value = keyValue.substr(eqPos + 1);
                        if (key == "id")
                        {
                            id = value;
                            break;
                        }
                    }
                }
            }

            if (id.empty())
            {
                res.result(http::status::bad_request);
                res.body() = "Missing 'id' query parameter";
            }
            else
            {
                bool is_deleted = database::delete_option_by_id(id);
                nlohmann::json body = {{"message", "option deleted with id = " + id}};

                res.body() = body.dump();
                res.prepare_payload();

                res.result(http::status::ok);
            }
        }
        catch (const std::exception &e)
        {
            res.result(http::status::internal_server_error);
            res.body() = std::string("Internal Server Error: ") + e.what();
        }

        res.version(req.version());
        res.set(http::field::server, "Beast");
        res.set(http::field::content_type, "application/json");

        return res;
    }

}