//
//  main.m
//  BlueViewDemo
//
//  Created by Jason Pepas on 3/17/23.
//  Copyright __MyCompanyName__ 2023. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BlueView: NSView
@end

@implementation BlueView
- (void)drawRect:(NSRect)rect {
	[[NSColor blueColor] setFill];
	NSRectFill(rect);
	[super drawRect:rect];
}
@end

@interface AppDelegate: NSObject
- (void)applicationWillBecomeActive:(NSNotification *)aNotification;
@end

@implementation AppDelegate
- (void)applicationWillBecomeActive:(NSNotification *)aNotification {
	NSLog(@"%@", NSStringFromSelector(_cmd));
	NSWindow* window = [[NSApplication sharedApplication] keyWindow];
	if ([[window contentView] isKindOfClass:[BlueView class]] == NO) {
		NSView* blueView = [[[BlueView alloc] init] autorelease];
		[window setContentView:blueView];
	}
}
@end

int main(int argc, char *argv[])
{
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	AppDelegate* delegate = [[AppDelegate alloc] init];
	[[NSApplication sharedApplication] setDelegate:delegate];
    int ret = NSApplicationMain(argc,  (const char **) argv);
	[pool release];
	return ret;
}
