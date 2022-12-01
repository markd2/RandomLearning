#import <iostream>
// clang++ -std=c++20 -o conversion conversion.cpp

int main() {
    using namespace std;

    long l =  1234567890123;
    long l2 = l + 1.0f - 1.0;   // imprecise
    long l3 = l + (1.0f - 1.0); // correct

    cout << l2 << ", " << l3 << " diff " << l2 - l3 << endl;
} // main


