#pragma once
#include <string>
#include "nlohmann/json.hpp"

namespace option
{
    double price();

    struct OptionRequest
    {
        unsigned int id;
        std::string type;
        double spot;
        double strike;
        double rateDomestic;
        double rateForeign;
        double volatility;
        std::string maturity;
        std::string dayCounter;
        double price = 0;
        std::string client;

        double compute() const;
    };

    void from_json(const nlohmann::json &j, option::OptionRequest &opt);
    void to_json(nlohmann::json &j, const option::OptionRequest &opt);

    
}