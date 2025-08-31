// clang++ -std=c++20 -o literals literals.cpp
#import <iostream>

int main() {
    using namespace std;

    auto binary = 0b01101001;
    auto longBinary = 0b101'1001'001'1101;
    auto longInt = 1'231'412'213;
    double hexFloat = 0x10.1p0f;

    // uniform initialization to prevent narrowing
    long l = {1234567890123};
    long lConcise{1234567890123};

    // int blah = {3.14}; // error - narrowing away the fractional part
    // unsigned u2n = {-3}; // error - no negatives
    // ^^^ and not just literals vvv
    unsigned u3 = {3};
    int i2 = {2};
    // unsigned ur = {i2}; // error - could be negative
    // i3 = {u3};  // error - could overflow

    return 0;
}
