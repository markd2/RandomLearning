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
@property (strong) NSMutableArray *windowControllers;
@end // extension

@implementation AppDelegate

- (void) applicationDidFinishLaunching: (NSNotification *) aNotification {
    self.windowControllers = [NSMutableArray new];

    [self showProjections: nil];
} // applicationDidFinishLaunching


- (void) showViewControllerNamed: (NSString *) vcClassName {
    Class clas = NSClassFromString(vcClassName);
    if (clas == Nil) {
        NSString *swiftClassName = [@"MathsFun." stringByAppendingString: vcClassName];
        clas = NSClassFromString(swiftClassName);
    }
    assert(clas);
    id wc = [[clas alloc] initWithWindowNibName: vcClassName];
    [wc showWindow: self];

    [self.windowControllers addObject: wc];

} // showViewControllerNamed


- (IBAction) showProjections: (NSButton *) sender {
    [self showViewControllerNamed: @"Projections"];
} // showProjections

@end // AppDelegate
