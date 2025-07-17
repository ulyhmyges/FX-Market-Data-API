#pragma once

#include "option/option.hpp"
#include <string>

namespace database
{

    bool store_user(const std::string &pseudo, const std::string &password);
    bool retrieve_user(const std::string &pseudo, const std::string &password);
    unsigned int check_user(const std::string &pseudo);
    bool update_or_store_option(const option::OptionRequest &option);
    std::vector<option::OptionRequest> get_option_by_user_id(const std::string &user_id);
    bool delete_option_by_id(const std::string &user_id);
}