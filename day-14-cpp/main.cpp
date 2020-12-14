#include <cstdio>
#include <cstdint>
#include <fstream>
#include <map>
#include <string>
#include <regex>
#include <cassert>


int main() {
    std::map<uint64_t, uint64_t> mem = {};
    std::map<uint64_t, uint64_t> mem2 = {};
    uint64_t and_mask   = 0;
    uint64_t or_mask    = 0;
    uint64_t float_mask = 0;

    std::vector<uint32_t> floating_bits;
    floating_bits.reserve(36);
    std::vector<uint64_t> floating_masks;

    std::ifstream input("./input.txt");
    if (!input.good()) {
        return -1;
    }

    std::regex mem_regex(R"(mem\[(\d+)\] = (\d+))");
    std::regex mask_regex(R"(mask = ([01X]{36}))");
    std::cmatch match;

    for (std::string line; std::getline(input, line);) {
        if (std::regex_match(line.c_str(), match, mem_regex)) {
            uint64_t addr = std::stoull(match[1].str());
            uint64_t val  = std::stoull(match[2].str());

            // part 1
            mem[addr] = (val & and_mask) | or_mask;

            // part 2
            addr &= ~float_mask; // set all floating bits to 0
            addr |= or_mask;     // 1's overwrite the bit
            for (auto it : floating_masks) {
                assert(!(it & ~float_mask));
                mem2[addr | it] = val;
            }
        }
        else if (std::regex_match(line.c_str(), match, mask_regex)) {
            and_mask   = 0;
            or_mask    = 0;
            float_mask = 0;
            uint32_t float_bit = 35;
            floating_bits.clear();

            for (const char c : match[1].str()) {
                or_mask    <<= 1;
                and_mask   <<= 1;
                float_mask <<= 1;

                and_mask |= 1;  // 1 by default
                switch(c) {
                    case '0':
                        and_mask &= ~1;
                        break;
                    case '1':
                        or_mask |= 1;
                        break;
                    case 'X':
                        float_mask |= 1;
                        floating_bits.push_back(float_bit);
                        break;
                    default:
                        printf("Invalid mask character: %c", c);
                        return -2;
                }
                float_bit--;
            }

            // generate all floating bit masks
            floating_masks.clear();
            floating_masks.push_back(0);
            while (!floating_bits.empty()) {
                uint64_t new_bit = 1ULL << floating_bits.back();
                floating_bits.pop_back();
                size_t floating_masks_size = floating_masks.size();

                // generate new mask for all existing masks
                for (size_t i = 0; i < floating_masks_size; i++) {
                    floating_masks.push_back(new_bit | floating_masks[i]);
                }
            }
        }
        else {
            printf("Invalid instruction: %s", line.c_str());
            return -3;
        }
    }

    uint64_t total = 0;
    for(auto iter = mem.begin(); iter != mem.end(); ++iter)
        total += iter->second;
    printf("Part 1: %lld\n", total);

    total = 0;
    for(auto iter = mem2.begin(); iter != mem2.end(); ++iter) {
        total += iter->second;
    }
    printf("Part 2: %lld\n", total);
    return 0;
}
