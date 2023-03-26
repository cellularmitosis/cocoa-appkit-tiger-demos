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


// MARK: - Label

@interface Label: NSTextField
- (id)initWithString:(NSString*)string;
@end

@implementation Label
- (id)initWithString:(NSString*)string {
    self = [super initWithFrame:RectZero];
    if (self == nil) {
        return nil;
    }
    [self setEditable:NO];
    [self setSelectable:NO];
    [self setBezeled:NO];
    [self setDrawsBackground:NO];
    [self setStringValue:string];
    [self sizeToFit];
    return self;
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
    Label* _fieldLabel;
    Label* _fieldLabel2;
    NSTextField* _urlField;
    ColorView* _blueView;
    ColorView* _greenView;
    ColorView* _redView;
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
    
    NSRect greenFrame = NSInsetRect(Bounds(frame), 64, 64);
    _greenView = [[ColorView alloc] initWithFrame:greenFrame];
    [_greenView setColor:[NSColor greenColor]];
    [self addSubview:_greenView];
    [_greenView setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];

    _redView = [[ColorView alloc] initWithFrame:NSMakeRect(0,0,16,16)];
    [_redView setColor:[NSColor redColor]];
    [self addSubview:_redView];

    [_redView yAlign:YAnchorCenter to:YAnchorCenter of:self margin:0];
    [_redView xAlign:XAnchorCenter to:XAnchorCenter of:self margin:0];
//    [_redView xAlign:XAnchorLeft to:XAnchorLeft of:self margin:0];
//    [_redView xAlign:XAnchorLeft to:XAnchorLeft of:_greenView margin:0];
//    [_redView xStretch:XAnchorRight to:XAnchorRight of:self margin:0];
//    [_redView xStretch:XAnchorRight to:XAnchorRight of:_greenView margin:0];
//    [_redView xStretch:XAnchorRight to:XAnchorLeft of:_greenView margin:0];
    [_redView xStretch:XAnchorLeft to:XAnchorLeft of:self margin:16];
    [_redView xStretch:XAnchorRight to:XAnchorLeft of:_greenView margin:16];
    [_redView yStretch:YAnchorTop to:YAnchorTop of:_greenView margin:16];
    [_redView yStretch:YAnchorBottom to:YAnchorBottom of:_greenView margin:16];

    
//    [_redView yAlign:YAnchorBottom to:YAnchorBottom of:self margin:32];
//    [_redView setFrameSize:NSMakeSize(64, 64)];
//    [_redView yStretch:YAnchorTop to:YAnchorTop of:self margin:32];
//    [_redView yStretch:YAnchorTop to:YAnchorTop of:_blueView margin:32];
//    [_redView yStretch:YAnchorTop to:YAnchorTop of:_greenView margin:0];
//    [_redView yStretch:YAnchorTop to:YAnchorTop of:self margin:0];

//    [_redView yAlign:YAnchorBottom to:YAnchorBottom of:_greenView margin:0];
//    [_redView yStretch:YAnchorTop to:YAnchorTop of:_greenView margin:0];
//    [_redView yAlign:YAnchorBottom to:YAnchorBottom of:self margin:16];
//    [_redView yAlign:YAnchorTop to:YAnchorTop of:self margin:0];
//    [_redView yAlign:YAnchorTop to:YAnchorTop of:self margin:16];
//    [_redView yAlign:YAnchorCenter to:YAnchorCenter of:self margin:0];
//    [_redView yAlign:YAnchorBottom to:YAnchorBottom of:_greenView margin:0];
//    [_redView yAlign:YAnchorTop to:YAnchorTop of:_greenView margin:0];
//    [_redView yAlign:YAnchorTop to:YAnchorBottom of:_greenView margin:0];
//    [_redView yAlign:YAnchorBottom to:YAnchorTop of:_greenView margin:0];
//    [_redView yAlign:YAnchorCenter to:YAnchorTop of:_greenView margin:0];
//    [_redView yAlign:YAnchorCenter to:YAnchorBottom of:_greenView margin:0];
    
    _fieldLabel = [[Label alloc] initWithString:@"URL:"];
    [self addSubview:_fieldLabel];
    [_fieldLabel yAlign:YAnchorTop to:YAnchorTop of:[_fieldLabel superview] margin:16];
    [_fieldLabel xAlign:XAnchorLeft to:XAnchorLeft of:[_fieldLabel superview] margin:16];
    [_fieldLabel setAutoresizingMask:ViewBottomMargin];

    _fieldLabel2 = [[Label alloc] initWithString:@"URL2:"];
    [_greenView addSubview:_fieldLabel2];
    [_fieldLabel2 yAlign:YAnchorTop to:YAnchorTop of:[_fieldLabel2 superview] margin:32];
    [_fieldLabel2 xAlign:XAnchorLeft to:XAnchorLeft of:[_fieldLabel2 superview] margin:0];
    [_fieldLabel2 setAutoresizingMask:ViewBottomMargin];
    
    _urlField = [[NSTextField alloc] initWithFrame:RectZero];
    [_urlField sizeToFit];
    [self addSubview:_urlField];
    [_urlField yAlign:YAnchorTop to:YAnchorTop of:[_urlField superview] margin:16];
    [_urlField xAlign:XAnchorLeft to:XAnchorRight of:_fieldLabel margin:16];
    [_urlField setAutoresizingMask:ViewBottomMargin|NSViewWidthSizable];

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
