#include <iostream>
#include <stdint.h>

// I'm on an M1, so this should give arm output
// clang++ rdtscp-arm.cpp -o rdtscp-arm

uint64_t __rdtscp(void * _)
{
    uint64_t val;

    /*
     * According to ARM DDI 0487F.c, from Armv8.0 to Armv8.5 inclusive, the
     * system counter is at least 56 bits wide; from Armv8.6, the counter
     * must be 64 bits wide.  So the system counter could be less than 64
     * bits wide and it is attributed with the flag 'cap_user_time_short'
     * is true.
     */
    asm volatile("mrs %0, cntvct_el0" : "=r" (val));

    return val;
}

int main()
{
    unsigned int dummy;
    unsigned long long t1 = __rdtscp(&dummy);
    std::cout << "Hello" << std::endl;

    unsigned long long t2 = __rdtscp(&dummy);
    std::cout << "Time: " << t2 - t1 << std::endl;
}
