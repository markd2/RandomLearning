
#include "HappyFun.hpp"

#include "HappyFun.hpp"
#include <HappyFunTime/HappyFunTime-Swift.h>
#include <iostream>

HappyFunCplusplus::HappyFunCplusplus(bool printInvocation) : printInvocation(printInvocation) {}

double HappyFunCplusplus::happyfun(double value) const {
    // Print the value if applicable.
    if (printInvocation)
        std::cout << "[c++] happyfun(" << value << ")\n";
    
    // Handle the base case of the recursion.
    if (value <= 1.0)
        return 1.0;
        
    // Create the Swift `HappyFunCalculator` structure and invoke its `happyfun` method.
    auto swiftCalculator = HappyFunTime::FunHappy::init(printInvocation);
    return swiftCalculator.happyfun(value - 1.0) + swiftCalculator.happyfun(value - 2.0);
}
