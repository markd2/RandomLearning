#import <iostream>

// clang++ -std=c++20 -o new-to-me-things new-to-me-things.cpp

int main() {
    using namespace std;
    
    if (auto x = 5) {  // scoped to the true portion
        cout << "x is " << x << endl;
    } else {
        cout << "not expecting to come in here";
    }

    auto op_code = 2;
    int x = 0, y = 0, z = 0;

    switch (op_code) {
    case 0: z = x + y; break;
    case 1: z = x - y; break;
    case 2: x = y; [[fallthrough]]; // attribute, communicate to reader it's fallthrough
    case 3: z = x * y;
    default: z = x / y;
    }

    int primes[] = {2, 3, 5, 7, 11, 13, 17};
    for (int i: primes) { // range-based for loop
        cout << i << " ";
    }
    cout << endl;

    for (int primos[] = {2, 3, 5, 7, 11, 13, 17}; int i : primes) {
        cout << i << " ";
    }
    cout << endl;

    return 0;
} // main
