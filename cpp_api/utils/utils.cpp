#include <jwt-cpp/jwt.h>
#include <random>

namespace utils
{
    // bcrypt base64 alphabet
    const char b64t[] = "./ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

    // Generate 22 char bcrypt base64 string from 16 bytes random data
    std::string generate_salt()
    {
        std::random_device rd;
        std::uniform_int_distribution<int> dist(0, 255);
        unsigned char raw_salt[16];
        for (int i = 0; i < 16; i++)
        {
            raw_salt[i] = static_cast<unsigned char>(dist(rd));
        }

        std::string salt = "$2a$12$"; // cost=12

        // bcrypt base64 encode 16 bytes into 22 chars
        int c1, c2;
        int i = 0, idx = 0;
        while (idx < 22)
        {
            c1 = raw_salt[i++];
            salt += b64t[(c1 >> 2) & 0x3f];
            c2 = (c1 & 0x3) << 4;

            if (i >= 16)
            {
                salt += b64t[c2 & 0x3f];
                break;
            }

            c1 = raw_salt[i++];
            c2 |= (c1 >> 4) & 0xf;
            salt += b64t[c2 & 0x3f];
            c2 = (c1 & 0xf) << 2;

            c1 = raw_salt[i++];
            salt += b64t[c2 | ((c1 >> 6) & 0x3)];
            salt += b64t[c1 & 0x3f];

            idx += 4;
        }

        return salt;
    }

    std::pair<bool, std::string> is_token_expired(const std::string &token, const std::string &secret)
    {
        std::pair<bool, std::string> pair;
        try
        {
            auto decoded = jwt::decode(token);

            auto verifier = jwt::verify()
                                .allow_algorithm(jwt::algorithm::hs256{secret})
                                .with_issuer("RESTApi");

            verifier.verify(decoded); // throws if invalid

            // Get expiration claim
            auto exp_claim = decoded.get_expires_at(); // returns std::chrono::system_clock::time_point

            auto now = std::chrono::system_clock::now();

            
                pair.first = now >= exp_claim;
                pair.second = decoded.get_subject();
            return pair;
        }
        catch (const std::exception &e)
        {
            std::cerr << "Invalid token or expired: " << e.what() << "\n";
            pair.first = true;
            pair.second = "error";
            return pair;
        }
    }

}