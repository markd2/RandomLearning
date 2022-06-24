#include <iostream>
#include <x86intrin.h>

// clang++ -arch x86_64 rdtscp.cpp -o rdtscp

int main()
{
    unsigned int dummy;
    unsigned long long t1 = __rdtscp(&dummy);
    std::cout << "Hello" << std::endl;

    unsigned long long t2 = __rdtscp(&dummy);
    std::cout << "Time: " << t2 - t1 << std::endl;
}
