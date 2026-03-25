// AppDelegate.m - the, uh, app delegate.

#import "AppDelegate.h"
#import <AppKit/AppKit.h>


@interface ClickableImageView: NSImageView
@end // ClickableImageView


@implementation ClickableImageView

- (void) mouseDown: (NSEvent *) event {
    [self sendAction: self.action  to: nil];
} // mouseDown

@end // ClickableImageView


@interface AppDelegate ()

@property (strong) IBOutlet NSWindow *window;

@property (strong) IBOutlet ClickableImageView *segment0;
@property (strong) IBOutlet ClickableImageView *segment1;
@property (strong) IBOutlet ClickableImageView *segment2;
@property (strong) IBOutlet ClickableImageView *segment3;
@property (strong) IBOutlet ClickableImageView *segment4;
@property (strong) IBOutlet ClickableImageView *segment5;
@property (strong) IBOutlet ClickableImageView *segment6;

@property (strong) IBOutlet NSTextField *hexLabel;

@property (assign) char segmentMask;
@end// extension


@implementation AppDelegate

- (void) applicationDidFinishLaunching: (NSNotification *) aNotification {
    self.segmentMask = 1 << 7;  // Kim Notes has the high be always set.
    [self updateUI];
} // applicationDidFinishLunching


- (BOOL) applicationSupportsSecureRestorableState: (NSApplication *) app {
    return YES;
} // applicationSupportsSecureRestorableState


- (IBAction) segmentClicked: (ClickableImageView *) sender {
    NSInteger clickedMask = 1 << sender.tag;

    if (self.segmentMask & clickedMask) { // is on, turn off
        self.segmentMask &= ~clickedMask;
    } else { // is off, turn on
        self.segmentMask |= clickedMask;
    }
    [self updateUI];
} // segmentClicked


- (void) updateUI {
    self.hexLabel.stringValue = [NSString stringWithFormat: @"%02X",
                                          (unsigned char)self.segmentMask];

    NSImage *horizOn = [NSImage imageNamed: @"horizontal-on"];
    NSImage *vertOn = [NSImage imageNamed: @"vertical-on"];
    NSImage *horizOff = [NSImage imageNamed: @"horizontal-off"];
    NSImage *vertOff = [NSImage imageNamed: @"vertical-off"];

    self.segment0.image = (self.segmentMask & (1 << 0)) ? horizOn : horizOff;
    self.segment1.image = (self.segmentMask & (1 << 1)) ? vertOn : vertOff;
    self.segment2.image = (self.segmentMask & (1 << 2)) ? vertOn : vertOff;
    self.segment3.image = (self.segmentMask & (1 << 3)) ? horizOn : horizOff;
    self.segment4.image = (self.segmentMask & (1 << 4)) ? vertOn : vertOff;
    self.segment5.image = (self.segmentMask & (1 << 5)) ? vertOn : vertOff;
    self.segment6.image = (self.segmentMask & (1 << 6)) ? horizOn : horizOff;
} // updateUI

@end // AppDelegate
