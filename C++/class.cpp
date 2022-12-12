#import <iostream>

// clang++ -std=c++20 -o class class.cpp


class complex {
public:
    complex(double rnew, double inew) : r(rnew), i{inew} {
        std::cout << "new complex " << r << " " << i << std::endl;
    }
private:
    double r, i;
};

int main() {
    auto oop = complex(1.0, 2.0);
    auto ack = complex{4.0, 7.12'1231'23};
}
