#include <iostream>
#include <string>

// clang++ -std=c++20 -o string string.cpp

int main() {
    using namespace std::string_literals; // adds an operator ""s

    std::string name = "Blorf";
    name += ", greeble";

    std::string explicitConversion = std::string("Snarnge");
    auto literalString = "trailingS"s; // needs std namespace
    std::string space = " "s;

    std::cout << "Type of literalString is " << typeid(literalString).name() << "\n" << std::endl;

    std::cout << "splunge " << name << space << explicitConversion << space << literalString << std::endl;
} // main

