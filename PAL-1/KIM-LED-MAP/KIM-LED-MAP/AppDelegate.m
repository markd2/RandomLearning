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

@property (assign) char segmentMask;
@end// extension


@implementation AppDelegate

- (BOOL) applicationSupportsSecureRestorableState: (NSApplication *) app {
    return YES;
} // applicationSupportsSecureRestorableState


- (IBAction) segmentClicked: (ClickableImageView *) sender {
    NSLog(@"OOGIE");
} // segmentClicked

@end // AppDelegate
