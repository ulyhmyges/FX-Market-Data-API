#include <ql/quantlib.hpp>
#include <iostream>
#include "option/option.hpp"

template <typename T>
std::ostream &operator<<(std::ostream &os, const std::vector<T> &vec)
{
    os << "[";
    for (size_t i = 0; i < vec.size(); ++i)
    {
        os << vec[i];
        if (i != vec.size() - 1)
        {
            os << ", ";
        }
    }
    os << "]";
    return os;
}

namespace option
{

    using namespace QuantLib;

    double OptionRequest::compute() const
    {
        Calendar calendar = TARGET();
        Date today(31, March, 2025);
        Settings::instance().evaluationDate() = today;

        // Option parameters
        Option::Type optionType = (this->type == "Call") ? Option::Call : (this->type == "Put") ? Option::Put
                                                                                                : Option::Call; // Default fallback

        Real spot = this->spot;
        Real strike = this->strike;
        Rate rd = this->rateDomestic;      // domestic (USD) risk-free rate 0.041669
        Rate rf = this->rateForeign;       // foreign (EUR) risk-free rate 0.021889
        Volatility vol = this->volatility; // 0.080457

        // Parse maturity "YYYY-MM-DD"
        int year;
        int month;
        int day;
        sscanf(this->maturity.c_str(), "%d-%d-%d", &year, &month, &day);
        Date maturityDate(day, Month(month), year);
        // Date maturity = calendar.advance(today, 6, Months);

        DayCounter dc = this->dayCounter == "ActualActual" ? ActualActual(ActualActual::ISDA) : "Actual365" ? ActualActual(ActualActual::Actual365)
                                                                                                            : ActualActual(ActualActual::ISDA);

        // Handle FX spot
        Handle<Quote> spotFx(boost::shared_ptr<Quote>(new SimpleQuote(spot)));

        // Domestic and foreign yield curves
        Handle<YieldTermStructure> domesticTS(boost::shared_ptr<YieldTermStructure>(
            new FlatForward(today, rd, dc)));
        Handle<YieldTermStructure> foreignTS(boost::shared_ptr<YieldTermStructure>(
            new FlatForward(today, rf, dc)));

        // Volatility surface
        Handle<BlackVolTermStructure> volTS(boost::shared_ptr<BlackVolTermStructure>(
            new BlackConstantVol(today, calendar, vol, dc)));

        // Payoff and exercise
        boost::shared_ptr<StrikedTypePayoff> payoff(new PlainVanillaPayoff(optionType, strike));
        boost::shared_ptr<Exercise> exercise(new EuropeanExercise(maturityDate));

        // FX Option
        VanillaOption fxOption(payoff, exercise);

        // Garman-Kohlhagen process
        boost::shared_ptr<BlackScholesMertonProcess> bsmProcess(
            new BlackScholesMertonProcess(spotFx, foreignTS, domesticTS, volTS));

        fxOption.setPricingEngine(boost::shared_ptr<PricingEngine>(
            new AnalyticEuropeanEngine(bsmProcess)));

        return fxOption.NPV();
    }

    void from_json(const nlohmann::json &j, option::OptionRequest &opt)
    {
        j.at("id").get_to(opt.id);
        if (j.contains("client"))
            j.at("client").get_to(opt.client);
        j.at("client").get_to(opt.client);
        j.at("type").get_to(opt.type);
        j.at("spot").get_to(opt.spot);
        j.at("strike").get_to(opt.strike);
        j.at("rateDomestic").get_to(opt.rateDomestic);
        j.at("rateForeign").get_to(opt.rateForeign);
        j.at("volatility").get_to(opt.volatility);
        j.at("maturity").get_to(opt.maturity);
        j.at("dayCounter").get_to(opt.dayCounter);
        if (j.contains("price"))
            j.at("price").get_to(opt.price);
    }

    void to_json(nlohmann::json &j, const option::OptionRequest &opt)
    {
        j = {
            {"id", opt.id},
            //{"client", opt.client},
            {"type", opt.type},
            {"spot", opt.spot},
            {"strike", opt.strike},
            {"rateDomestic", opt.rateDomestic},
            {"rateForeign", opt.rateForeign},
            {"volatility", opt.volatility},
            {"maturity", opt.maturity},
            {"dayCounter", opt.dayCounter},
        };

        if (opt.price != 0)
            j["price"] = opt.price;
    }

}
