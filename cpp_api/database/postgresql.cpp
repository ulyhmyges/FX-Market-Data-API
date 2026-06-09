#include "database/postgresql.hpp"
#include "option/option.hpp"

#include <pqxx/pqxx>
#include <iostream>

extern "C"
{
#include "bcrypt.h"
}

namespace database
{
    std::string getDB_URL(){
        const char* host = std::getenv("DB_HOST");
        host="db";
        if (!host) {
            throw std::runtime_error("DB_HOST environment variable is not set");
        }
        return "dbname=restapi user=admin password=admin host=" + std::string(host) + " port=5432";
    }

    bool retrieve_user(const std::string &pseudo, const std::string &password)
    {
        // Connect to PostgreSQL
        pqxx::connection conn(getDB_URL());

        conn.prepare("check_user", "SELECT password FROM users WHERE pseudo = $1");

        pqxx::work txn(conn);
        
        //pqxx::result r = txn.exec(pqxx::prepped("check_user"), pqxx::params(pseudo));
        pqxx::result r = txn.exec_prepared("check_user", pseudo);

        if (r.empty())
        {
            std::cerr << "User not found\n";
            return false;
        }

        std::string stored_hashed = r[0][0].as<std::string>();

        // Compare the given password with the stored hash
        int result = bcrypt_checkpw(password.c_str(), stored_hashed.c_str());

        if (result == 0)
        {
            std::cout << "Password match\n";
            return true;
        }
        else if (result == -1)
        {
            std::cerr << "Error during password check\n";
            return false;
        }
        else
        {
            std::cerr << "Password does not match\n";
            return false;
        }
    }

    bool store_user(const std::string &pseudo, const std::string &password)
    {
        try
        {
            // Connect to PostgreSQL
            pqxx::connection conn(getDB_URL());

            conn.prepare("check_user", "SELECT 1 FROM users WHERE pseudo = $1");
            conn.prepare("insert_user", "INSERT INTO users (pseudo, password) VALUES ($1, $2)");

            pqxx::work txn(conn);
            
            pqxx::result r = txn.exec_prepared("check_user", pseudo);
            //pqxx::result r = txn.exec(pqxx::prepped("check_user"), pqxx::params(pseudo));
            if (!r.empty())
                return false;

            // TODO: hash password (e.g., bcrypt)
            // std::string hashedPassword = password; // placeholder

            char hashedPassword[100];
            // const char* password = "my_password";
            const char *salt = "$2a$12$abcdefghijklmnopqrstuv"; // 29 chars
            // bcrypt_gensalt(12, salt);

            if (bcrypt_hashpw(password.c_str(), salt, hashedPassword) == 0)
                std::cout << "Hashed password: " << hashedPassword << std::endl;

            txn.exec_prepared("insert_user", pseudo, hashedPassword);
            //txn.exec(pqxx::prepped("insert_user"), pqxx::params(pseudo, hashedPassword));

            txn.commit();
            return true;
        }
        catch (const std::exception &e)
        {
            std::cerr << "Database error: " << e.what() << std::endl;
            return false;
        }
    }

    unsigned int check_user(const std::string &pseudo)
    {
        // Connect to PostgreSQL
        pqxx::connection conn(getDB_URL());

        conn.prepare("check_user", "SELECT id FROM users WHERE pseudo = $1");

        pqxx::work txn(conn);
        
        pqxx::result r = txn.exec_prepared("check_user", pseudo);
        //pqxx::result r = txn.exec(pqxx::prepped("check_user"), pqxx::params(pseudo));

        if (r.empty())
        {
            std::cerr << "User not found.\n";
            return 0;
        }

        return r[0][0].as<unsigned int>();
    }

    bool update_or_store_option(const option::OptionRequest &opt)
    {
        try
        {
            // Connect to PostgreSQL
            pqxx::connection conn(getDB_URL());
            conn.prepare("user_id", "SELECT id FROM users WHERE pseudo = $1");

            pqxx::work txn(conn);
            
            //pqxx::result r = txn.exec(pqxx::prepped("user_id"), pqxx::params(opt.client));
            pqxx::result r = txn.exec_prepared("user_id", opt.client);
            if (r.empty())
            {
            std:
                std::cerr << "User id not found\n";
                return false;
            }

            std::string user_id = r[0][0].as<std::string>();

            if (opt.id > 0)
            {
                conn.prepare("update_option", "update options SET type = $1, price = $2, strike = $3, rate_domestic = $4, rate_foreign = $5, volatility = $6, maturity = $7, day_counter = $8, spot = $9 WHERE id = $10;");
                // pqxx::result res_update = txn.exec(pqxx::prepped("update_option"), pqxx::params(opt.type, opt.price, opt.strike, opt.rateDomestic, opt.rateForeign, opt.volatility, opt.maturity, opt.dayCounter, opt.spot, opt.id));
                pqxx::result res_update = txn.exec_prepared("update_option", opt.type, opt.price, opt.strike, opt.rateDomestic, opt.rateForeign, opt.volatility, opt.maturity, opt.dayCounter, opt.spot, opt.id);   
            }
            else
            {
                conn.prepare("insert_option", "INSERT INTO options (type, spot, strike, rate_domestic, rate_foreign, volatility, maturity, day_counter, price, user_id) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)");
                
                // txn.exec(pqxx::prepped("insert_option"), pqxx::params(opt.type, opt.spot, opt.strike, opt.rateDomestic, opt.rateForeign, opt.volatility, opt.maturity, opt.dayCounter, opt.price, user_id));
                txn.exec_prepared("insert_option", opt.type, opt.spot, opt.strike, opt.rateDomestic, opt.rateForeign, opt.volatility, opt.maturity, opt.dayCounter, opt.price, user_id);
            }

            txn.commit();
            return true;
        }
        catch (const std::exception &e)
        {
            std::cerr << "Database error: " << e.what() << std::endl;
            return false;
        }
    }

    std::vector<option::OptionRequest> get_option_by_user_id(const std::string &user_id)
    {
        try
        {
            // Connect to PostgreSQL
            pqxx::connection conn(getDB_URL());
            conn.prepare("options", "SELECT * FROM options WHERE user_id = $1");

            pqxx::work txn(conn);
            
            //pqxx::result r = txn.exec(pqxx::prepped("options"), pqxx::params(user_id));
            pqxx::result r = txn.exec_prepared("options", user_id);
            if (r.empty())
            {
                std::cerr << "No option found for user_id = " << user_id << "\n";
                return std::vector<option::OptionRequest>();
            }

            std::vector<option::OptionRequest> options;

            for (const auto &row : r)
            {
                option::OptionRequest opt = {
                    row[0].as<unsigned int>(), // id
                    row[1].as<std::string>(),  // type
                    row[2].as<double>(),       // spot
                    row[3].as<double>(),       // strike
                    row[4].as<double>(),       // rateDomestic
                    row[5].as<double>(),       // rateForeign
                    row[6].as<double>(),       // volatility
                    row[7].as<std::string>(),  // maturity
                    row[8].as<std::string>(),  // dayCounter
                    row[9].as<double>()        // price
                    // row[10].as<unsigned int>(); // user_id
                };
                options.push_back(opt);
            }

            return options;
        }
        catch (const std::exception &e)
        {
            std::cerr << "Database error: " << e.what() << std::endl;
            return std::vector<option::OptionRequest>();
        }
    }

    bool delete_option_by_id(const std::string &id)
    {
        try
        {
            // Connect to PostgreSQL
            pqxx::connection conn(getDB_URL());
            conn.prepare("delete_option", "DELETE FROM options WHERE id = $1");
            conn.prepare("get_option", "SELECT * FROM options WHERE id = $1");

            pqxx::work txn(conn);
            
            // txn.exec(pqxx::prepped("delete_option"), pqxx::params(id));
            txn.exec_prepared("delete_option", id);
            txn.commit();

            // pqxx::result r = txn.exec(pqxx::prepped("get_option"), pqxx::params(id));
            pqxx::result r = txn.exec_prepared("get_option", id);
            if (!r.empty())
            {
                std::cerr << "Option was not deleted with id = " << id << "\n";
                return false;
            }

            return true;
        }
        catch (const std::exception &e)
        {
            std::cerr << "Database error: " << e.what() << std::endl;
            return false;
        }
    }

}