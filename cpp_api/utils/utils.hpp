#include <string>

namespace utils {
    std::string generate_salt();
    std::pair<bool, std::string> is_token_expired(const std::string &token, const std::string &secret);
}