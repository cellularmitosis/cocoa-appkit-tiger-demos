//
//  main.m
//  BlueWindowDemo
//
//  Created by Jason Pepas on 3/12/23.
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
- (void)applicationDidBecomeActive:(NSNotification *)aNotification;
- (void)applicationDidChangeScreenParameters:(NSNotification *)aNotification;
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;
- (void)applicationDidHide:(NSNotification *)aNotification;
- (void)applicationDidResignActive:(NSNotification *)aNotification;
- (void)applicationDidUnhide:(NSNotification *)aNotification;
- (void)applicationDidUpdate:(NSNotification *)aNotification;
- (void)applicationWillBecomeActive:(NSNotification *)aNotification;
- (void)applicationWillFinishLaunching:(NSNotification *)aNotification;
- (void)applicationWillHide:(NSNotification *)aNotification;
- (void)applicationWillResignActive:(NSNotification *)aNotification;
- (void)applicationWillTerminate:(NSNotification *)aNotification;
- (void)applicationWillUnhide:(NSNotification *)aNotification;
- (void)applicationWillUpdate:(NSNotification *)aNotification;
@end

@implementation AppDelegate

- (void)applicationDidBecomeActive:(NSNotification *)aNotification {
	NSLog(@"%@", NSStringFromSelector(_cmd));
	NSWindow* window = [[NSApplication sharedApplication] keyWindow];
	if (window == nil) {
		NSLog(@"window is nil");
	} else {
		NSLog(@"window is NOT nil");
	}
}

- (void)applicationDidChangeScreenParameters:(NSNotification *)aNotification {
	NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	NSLog(@"%@", NSStringFromSelector(_cmd));
	NSWindow* window = [[NSApplication sharedApplication] keyWindow];
	if (window == nil) {
		NSLog(@"window is nil");
	} else {
		NSLog(@"window is NOT nil");
	}
}

- (void)applicationDidHide:(NSNotification *)aNotification {
	NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)applicationDidResignActive:(NSNotification *)aNotification {
	NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)applicationDidUnhide:(NSNotification *)aNotification {
	NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)applicationDidUpdate:(NSNotification *)aNotification {
	NSLog(@"%@", NSStringFromSelector(_cmd));
	NSWindow* window = [[NSApplication sharedApplication] keyWindow];
	if (window == nil) {
		NSLog(@"window is nil");
	} else {
		NSLog(@"window is NOT nil");
	}
}

- (void)applicationWillBecomeActive:(NSNotification *)aNotification {
	NSLog(@"%@", NSStringFromSelector(_cmd));
	NSWindow* window = [[NSApplication sharedApplication] keyWindow];
	if (window == nil) {
		NSLog(@"window is nil");
	} else {
		NSLog(@"window is NOT nil");
		NSView* blueView = [[BlueView alloc] init];
		[window setContentView:blueView];
	}
}

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification {
	NSLog(@"%@", NSStringFromSelector(_cmd));
	// Note: [[NSApplication sharedApplication] keyWindow] is still nil at this point.
	NSWindow* window = [[NSApplication sharedApplication] keyWindow];
	if (window == nil) {
		NSLog(@"window is nil");
	} else {
		NSLog(@"window is NOT nil");
	}
}

- (void)applicationWillHide:(NSNotification *)aNotification {
	NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)applicationWillResignActive:(NSNotification *)aNotification {
	NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)applicationWillUnhide:(NSNotification *)aNotification {
	NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)applicationWillUpdate:(NSNotification *)aNotification {
	NSLog(@"%@", NSStringFromSelector(_cmd));
	NSWindow* window = [[NSApplication sharedApplication] keyWindow];
	if (window == nil) {
		NSLog(@"window is nil");
	} else {
		NSLog(@"window is NOT nil");
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
