//
//  main.m
//  LayoutDemo2
//
//  Created by Jason Pepas on 3/20/23.
//  Copyright __MyCompanyName__ 2023. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define ViewLeftMargin (NSViewMinXMargin)
#define ViewRightMargin (NSViewMaxXMargin)
#define ViewBottomMargin (NSViewMinYMargin)
#define ViewTopMargin (NSViewMaxYMargin)

const NSRect RectZero = { 0, 0, 0, 0 };
const NSPoint PointZero = { 0, 0 };

NSRect Bounds(NSRect rect) {
    return NSMakeRect(0, 0, rect.size.width, rect.size.height);
}

enum {
    YAnchorTop=100,
    YAnchorCenter,
    YAnchorBottom,
};
typedef int YAnchor;

enum {
    XAnchorLeft=200,
    XAnchorCenter,
    XAnchorRight,
};
typedef int XAnchor;

@interface NSView (Layout)
- (void)yAlign:(YAnchor)anchor to:(YAnchor)otherAnchor of:(NSView*)otherView margin:(float)margin;
- (void)xAlign:(XAnchor)anchor to:(XAnchor)otherAnchor of:(NSView*)otherView margin:(float)margin;
- (void)yStretch:(YAnchor)anchor to:(YAnchor)otherAnchor of:(NSView*)otherView margin:(float)margin;
- (void)xStretch:(XAnchor)anchor to:(XAnchor)otherAnchor of:(NSView*)otherView margin:(float)margin;
@end

@implementation NSView (Layout)

- (void)yAlign:(YAnchor)anchor to:(YAnchor)otherAnchor of:(NSView*)otherView margin:(float)margin {
    NSPoint relativeOffset = [[self superview] convertPoint:PointZero fromView:otherView];
    float newY = 0 + relativeOffset.y;
    if (anchor == YAnchorBottom) {
        newY += margin;
    } else if (anchor == YAnchorTop) {
        newY -= [self bounds].size.height;
        newY -= margin;
    } else if (anchor == YAnchorCenter) {
        newY -= [self bounds].size.height / 2;
        newY -= margin;
    }
    if (otherAnchor == YAnchorTop) {
        newY += [otherView bounds].size.height;
    } else if (otherAnchor == YAnchorCenter) {
        newY += [otherView bounds].size.height / 2;
    }
    [self setFrameOrigin:NSMakePoint([self frame].origin.x, newY)];
}

- (void)xAlign:(XAnchor)anchor to:(XAnchor)otherAnchor of:(NSView*)otherView margin:(float)margin {
    NSPoint relativeOffset = [[self superview] convertPoint:PointZero fromView:otherView];
    float newX = 0 + relativeOffset.x;
    if (anchor == XAnchorLeft) {
        newX += margin;
    } else if (anchor == XAnchorRight) {
        newX -= [self bounds].size.width;
        newX -= margin;
    } else if (anchor == XAnchorCenter) {
        newX -= [self bounds].size.width / 2;
        newX -= margin;
    }
    if (otherAnchor == XAnchorRight) {
        newX += [otherView bounds].size.width;
    } else if (otherAnchor == XAnchorCenter) {
        newX += [otherView bounds].size.width / 2;
    }
    [self setFrameOrigin:NSMakePoint(newX, [self frame].origin.y)];
}

- (void)yStretch:(YAnchor)anchor to:(YAnchor)otherAnchor of:(NSView*)otherView margin:(float)margin {
    if (anchor == YAnchorBottom) {
        float oldY = [self frame].origin.y;
        [self yAlign:anchor to:otherAnchor of:otherView margin:margin];
        float newY = [self frame].origin.y;
        float deltaHeight = oldY - newY;
        float newHeight = [self bounds].size.height + deltaHeight;
        [self setFrameSize:NSMakeSize([self bounds].size.width, newHeight)];
    } else if (anchor == YAnchorCenter) {
        [[NSException exceptionWithName:@"NotImplemented" reason:@"yStretch using YAnchorCenter has not been implemented" userInfo:nil] raise];
    } else if (anchor == YAnchorTop) {
        NSPoint relativeOffset = [self convertPoint:PointZero fromView:otherView];
        float newHeight = relativeOffset.y;
        newHeight -= margin;
        if (otherAnchor == YAnchorTop) {
            newHeight += [otherView bounds].size.height;
        } else if (otherAnchor == YAnchorCenter) {
            newHeight += [otherView bounds].size.height / 2;
        }
        [self setFrameSize:NSMakeSize([self bounds].size.width, newHeight)];
    }
}

- (void)xStretch:(XAnchor)anchor to:(XAnchor)otherAnchor of:(NSView*)otherView margin:(float)margin {
    if (anchor == XAnchorLeft) {
        float oldX = [self frame].origin.x;
        [self xAlign:anchor to:otherAnchor of:otherView margin:margin];
        float newX = [self frame].origin.x;
        float deltaWidth = oldX - newX;
        float newWidth = [self bounds].size.width + deltaWidth;
        [self setFrameSize:NSMakeSize(newWidth, [self bounds].size.height)];
    } else if (anchor == XAnchorCenter) {
        [[NSException exceptionWithName:@"NotImplemented" reason:@"xStretch using XAnchorCenter has not been implemented" userInfo:nil] raise];
    } else if (anchor == XAnchorRight) {
        NSPoint relativeOffset = [self convertPoint:PointZero fromView:otherView];
        float newWidth = relativeOffset.x;
        newWidth -= margin;
        if (otherAnchor == XAnchorRight) {
            newWidth += [otherView bounds].size.width;
        } else if (otherAnchor == XAnchorCenter) {
            newWidth += [otherView bounds].size.width / 2;
        }
        [self setFrameSize:NSMakeSize(newWidth, [self bounds].size.height)];
    }
}

@end


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
    ColorView* _ulView; // upper-left
    ColorView* _clView; // center-left
    ColorView* _llView; // lower-left
    ColorView* _ucView; // upper-center
    ColorView* _ccView; // center-center
    ColorView* _lcView; // lower-center
    ColorView* _urView; // upper-right
    ColorView* _crView; // center-right
    ColorView* _lrView; // lower-right
}
@end

@implementation MainView
- (id)initWithFrame:(NSRect)frame {
    NSLog(@"%@, frame: %@", NSStringFromSelector(_cmd), NSStringFromRect(frame));
    self = [super initWithFrame:frame];
    if (self == nil) {
        return nil;
    }

    _blueView = [[ColorView alloc] initWithFrame:Bounds(frame)];
    [_blueView setColor:[NSColor blueColor]];
    [self addSubview:_blueView];
    [_blueView setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    
    NSRect greenFrame = NSInsetRect(Bounds(frame), 32, 32);
    _greenView = [[ColorView alloc] initWithFrame:greenFrame];
    [_greenView setColor:[NSColor greenColor]];
    [self addSubview:_greenView];
    [_greenView setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];

    _ulView = [[ColorView alloc] initWithFrame:NSMakeRect(0, 0, 32, 32)];
    [_ulView setColor:[NSColor redColor]];
    [self addSubview:_ulView];
    [_ulView yAlign:YAnchorTop to:YAnchorTop of:_greenView margin:16];
    [_ulView xAlign:XAnchorLeft to:XAnchorLeft of:_greenView margin:16];
    [_ulView setAutoresizingMask:ViewBottomMargin];

    _urView = [[ColorView alloc] initWithFrame:NSMakeRect(0, 0, 32, 32)];
    [_urView setColor:[NSColor redColor]];
    [self addSubview:_urView];
    [_urView yAlign:YAnchorTop to:YAnchorTop of:_greenView margin:16];
    [_urView xAlign:XAnchorRight to:XAnchorRight of:_greenView margin:16];
    [_urView setAutoresizingMask:ViewBottomMargin|ViewLeftMargin];
    
    _llView = [[ColorView alloc] initWithFrame:NSMakeRect(0, 0, 32, 32)];
    [_llView setColor:[NSColor redColor]];
    [self addSubview:_llView];
    [_llView yAlign:YAnchorBottom to:YAnchorBottom of:_greenView margin:16];
    [_llView xAlign:XAnchorLeft to:XAnchorLeft of:_greenView margin:16];
    [_llView setAutoresizingMask:ViewTopMargin];

    _lrView = [[ColorView alloc] initWithFrame:NSMakeRect(0, 0, 32, 32)];
    [_lrView setColor:[NSColor redColor]];
    [self addSubview:_lrView];
    [_lrView yAlign:YAnchorBottom to:YAnchorBottom of:_greenView margin:16];
    [_lrView xAlign:XAnchorRight to:XAnchorRight of:_greenView margin:16];
    [_lrView setAutoresizingMask:ViewTopMargin|ViewLeftMargin];
    
    _clView = [[ColorView alloc] initWithFrame:NSMakeRect(0, 0, 32, 32)];
    [_clView setColor:[NSColor yellowColor]];
    [self addSubview:_clView];
    [_clView yAlign:YAnchorTop to:YAnchorBottom of:_ulView margin:16];
    [_clView yStretch:YAnchorBottom to:YAnchorTop of:_llView margin:16];
    [_clView xAlign:XAnchorLeft to:XAnchorLeft of:_greenView margin:16];
    [_clView setAutoresizingMask:NSViewHeightSizable];

    _crView = [[ColorView alloc] initWithFrame:NSMakeRect(0, 0, 32, 32)];
    [_crView setColor:[NSColor yellowColor]];
    [self addSubview:_crView];
    [_crView yAlign:YAnchorTop to:YAnchorBottom of:_urView margin:16];
    [_crView yStretch:YAnchorBottom to:YAnchorTop of:_lrView margin:16];
    [_crView xAlign:XAnchorRight to:XAnchorRight of:_greenView margin:16];
    [_crView setAutoresizingMask:NSViewHeightSizable|ViewLeftMargin];
    
    _ucView = [[ColorView alloc] initWithFrame:NSMakeRect(0, 0, 32, 32)];
    [_ucView setColor:[NSColor cyanColor]];
    [self addSubview:_ucView];
    [_ucView yAlign:YAnchorTop to:YAnchorTop of:_greenView margin:16];
    [_ucView xAlign:XAnchorLeft to:XAnchorRight of:_ulView margin:16];
    [_ucView xStretch:XAnchorRight to:XAnchorLeft of:_urView margin:16];
    [_ucView setAutoresizingMask:ViewBottomMargin|NSViewWidthSizable];

    _lcView = [[ColorView alloc] initWithFrame:NSMakeRect(0, 0, 32, 32)];
    [_lcView setColor:[NSColor cyanColor]];
    [self addSubview:_lcView];
    [_lcView yAlign:YAnchorBottom to:YAnchorBottom of:_greenView margin:16];
    [_lcView xAlign:XAnchorLeft to:XAnchorRight of:_llView margin:16];
    [_lcView xStretch:XAnchorRight to:XAnchorLeft of:_lrView margin:16];
    [_lcView setAutoresizingMask:NSViewWidthSizable];

    _ccView = [[ColorView alloc] initWithFrame:NSMakeRect(0, 0, 32, 32)];
    [_ccView setColor:[NSColor magentaColor]];
    [self addSubview:_ccView];
    [_ccView yAlign:YAnchorTop to:YAnchorBottom of:_ucView margin:16];
    [_ccView yStretch:YAnchorBottom to:YAnchorTop of:_lcView margin:16];
    [_ccView xAlign:XAnchorLeft to:XAnchorRight of:_clView margin:16];
    [_ccView xStretch:XAnchorRight to:XAnchorLeft of:_crView margin:16];
    [_ccView setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];

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
