//
//  AppDelegate.m
//  MathsFun
//
//  Created by Mark Dalrymple on 4/12/23.
//

#import "AppDelegate.h"

#import "vectors.h"

#import <iostream>

@interface AppDelegate ()

@property (strong) IBOutlet NSWindow *window;
@end // extension

@implementation AppDelegate

- (void) applicationDidFinishLaunching: (NSNotification *) aNotification {
    vec3 right = { 1.0f, 0.0f, 0.3f };
    std::cout << "oop " << right.x << std::endl;
    std::cout << "ack " << right[1] << std::endl;
    std::cout << "blah " << right.asArray[2] << std::endl;
} // applicationDidFinishLaunching


- (void) applicationWillTerminate: (NSNotification *) aNotification {
    // Insert code here to tear down your application
}


- (BOOL) applicationSupportsSecureRestorableState: (NSApplication *) app {
    return YES;
}

@end // AppDelegate
