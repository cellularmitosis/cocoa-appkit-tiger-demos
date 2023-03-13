//
//  main.m
//  BlueWindowDemo2
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


@interface AppListener: NSObject
- (void)applicationWillBecomeActive;
@end

@implementation AppListener

- (void)applicationWillBecomeActive {
	NSLog(@"%@", NSStringFromSelector(_cmd));
	NSWindow* window = [[NSApplication sharedApplication] keyWindow];
	NSView* blueView = [[BlueView alloc] init];
	[window setContentView:blueView];
}

@end


int main(int argc, char *argv[])
{
	AppListener* listener = [[AppListener alloc] init];
	[[NSNotificationCenter defaultCenter]
		addObserver:listener
		selector:@selector(applicationWillBecomeActive)
		name:NSApplicationWillBecomeActiveNotification object:nil];
    return NSApplicationMain(argc,  (const char **) argv);
}
