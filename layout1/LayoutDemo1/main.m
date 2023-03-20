//
//  main.m
//  LayoutDemo1
//
//  Created by Jason Pepas on 3/19/23.
//  Copyright __MyCompanyName__ 2023. All rights reserved.
//

#import <Cocoa/Cocoa.h>


NSRect Bounds(NSRect rect) {
    return NSMakeRect(0, 0, rect.size.width, rect.size.height);
}


// MARK: - ColorView

@interface ColorView: NSView {
    NSColor* _color;
}
- (NSColor*)color;
- (void)setColor:(NSColor*)color;
@end

@implementation ColorView
- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self == nil) {
        return nil;
    }
    [self setColor:[NSColor whiteColor]];
    return self;
}

- (NSColor*)color {
    return _color;
}

- (void)setColor:(NSColor*)newColor {
    [_color release];
    _color = newColor;
    [_color retain];
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)rect {
	[_color setFill];
	NSRectFill(rect);
	[super drawRect:rect];
}
@end


// MARK: - MainView

@interface MainView: NSView {
    ColorView* _blueView;
    ColorView* _greenView;
}
@end

@implementation MainView
- (id)initWithFrame:(NSRect)frame {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    self = [super initWithFrame:frame];
    if (self == nil) {
        return nil;
    }

    _blueView = [[ColorView alloc] initWithFrame:Bounds(frame)];
    [_blueView setColor:[NSColor blueColor]];
    [self addSubview:_blueView];
    [_blueView setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];

    NSRect greenFrame = NSInsetRect(Bounds(frame), 16, 16);
    _greenView = [[ColorView alloc] initWithFrame:greenFrame];
    [_greenView setColor:[NSColor greenColor]];
    [self addSubview:_greenView];
    [_greenView setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];

    return self;
}
@end


// MARK: - AppDelegate

@interface AppDelegate: NSObject
- (void)applicationWillBecomeActive:(NSNotification *)aNotification;
@end

@implementation AppDelegate
- (void)applicationWillBecomeActive:(NSNotification *)aNotification {
	NSLog(@"%@", NSStringFromSelector(_cmd));
	NSWindow* window = [[[NSApplication sharedApplication] windows] objectAtIndex:0];
	if ([[window contentView] isKindOfClass:[MainView class]] == NO) {
		MainView* mainView = [[MainView alloc] initWithFrame:[[window contentView] frame]];
		[window setContentView:mainView];
	}
}
@end


// MARK: - main

int main(int argc, char *argv[]) {
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	AppDelegate* delegate = [[AppDelegate alloc] init];
	[[NSApplication sharedApplication] setDelegate:delegate];
    int exitStatus = NSApplicationMain(argc, (const char **)argv);
	[pool release];
	return exitStatus;
}
