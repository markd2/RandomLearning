//
//  main.m
//  MathsFun
//
//  Created by Mark Dalrymple on 4/12/23.
//

#import <Cocoa/Cocoa.h>

#import "matrices.h"
#import <iostream>

int main(int argc, const char * argv[]) {
    @autoreleasepool {

    }

    mat4 m4 = {
        1.0f, 0.0f, 0.0f, 0.0f,
        0.0f, 1.0f, 0.0f, 0.0f,
        0.0f, 0.0f, 1.0f, 5.0f,
        0.0f, 0.0f, 0.0f, 1.0f };

    std::cout << "element at index 11" << m4[2][3] << "\n";
    std::cout << "element at index 11" << m4._34 << "\n";
    std::cout << "element at index 11" << m4.asArray[11] << "\n";

    return NSApplicationMain(argc, argv);
}
