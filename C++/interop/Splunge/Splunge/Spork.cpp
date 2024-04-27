//
//  Spork.cpp
//  Splunge
//
//  Created by Mark Dalrymple on 11/20/23.
//

#include <iostream>
#include "Splunge-Swift.h"
#include <swift/bridging.h>

void gronk(void) {
    auto blah = Splunge::Temperature::init(23);

    blah.setCelsius(42);
    std::cout << blah.getCelsius() << std::endl;
}

