
#pragma once

#import <swift/bridging>

class HappyFunCplusplus {
public:
    HappyFunCplusplus(bool printInvocation);
    double happyfun(double value) const;
private:
    bool printInvocation;
};

