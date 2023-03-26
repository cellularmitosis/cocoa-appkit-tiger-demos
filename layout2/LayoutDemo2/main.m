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
    VLayoutAnchorTop=100,
    VLayoutAnchorCenter,
    VLayoutAnchorBottom,
};
typedef int VLayoutAnchor;

enum {
    HLayoutAnchorLeft=200,
    HLayoutAnchorCenter,
    HLayoutAnchorRight,
};
typedef int HLayoutAnchor;

@interface NSView (Layout)
- (void)vAlign:(VLayoutAnchor)anchor to:(VLayoutAnchor)otherAnchor of:(NSView*)otherView margin:(float)margin;
- (void)hAlign:(HLayoutAnchor)anchor to:(HLayoutAnchor)otherAnchor of:(NSView*)otherView margin:(float)margin;
@end

@implementation NSView (Layout)

- (void)vAlign:(VLayoutAnchor)anchor to:(VLayoutAnchor)otherAnchor of:(NSView*)otherView margin:(float)margin {
    NSPoint relativeOffset = [[self superview] convertPoint:PointZero fromView:otherView];
    float newY = 0 + relativeOffset.y;
    if (anchor == VLayoutAnchorBottom) {
        newY += margin;
    } else if (anchor == VLayoutAnchorTop) {
        newY -= margin;
        newY -= [self bounds].size.height;
    } else if (anchor == VLayoutAnchorCenter) {
        newY -= margin;
        newY -= [self bounds].size.height / 2;
    }
    if (otherAnchor == VLayoutAnchorTop) {
        newY += [otherView bounds].size.height;
    } else if (otherAnchor == VLayoutAnchorCenter) {
        newY += [otherView bounds].size.height / 2;
    }
    [self setFrameOrigin:NSMakePoint([self frame].origin.x, newY)];
}

- (void)hAlign:(HLayoutAnchor)anchor to:(HLayoutAnchor)otherAnchor of:(NSView*)otherView margin:(float)margin {
    NSPoint relativeOffset = [[self superview] convertPoint:PointZero fromView:otherView];
    float newX = 0 + relativeOffset.x;
    if (anchor == HLayoutAnchorLeft) {
        newX += margin;
    } else if (anchor == HLayoutAnchorRight) {
        newX -= margin;
        newX -= [self bounds].size.width;
    } else if (anchor == HLayoutAnchorCenter) {
        newX -= margin;
        newX -= [self bounds].size.width / 2;
    }
    if (otherAnchor == HLayoutAnchorRight) {
        newX += [otherView bounds].size.width;
    } else if (otherAnchor == HLayoutAnchorCenter) {
        newX += [otherView bounds].size.width / 2;
    }
    NSLog(@"relativeOffset.x: %f, newX: %f", relativeOffset.x, newX);
    [self setFrameOrigin:NSMakePoint(newX, [self frame].origin.y)];
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

    _redView = [[ColorView alloc] initWithFrame:NSMakeRect(0,0,16,16)];
    [_redView setColor:[NSColor redColor]];
    [self addSubview:_redView];
    [_redView vAlign:VLayoutAnchorBottom to:VLayoutAnchorBottom of:self margin:0];
    [_redView vAlign:VLayoutAnchorBottom to:VLayoutAnchorBottom of:self margin:0];
    [_redView vAlign:VLayoutAnchorBottom to:VLayoutAnchorBottom of:self margin:16];
    [_redView vAlign:VLayoutAnchorBottom to:VLayoutAnchorBottom of:self margin:16];
    [_redView vAlign:VLayoutAnchorTop to:VLayoutAnchorTop of:self margin:0];
    [_redView vAlign:VLayoutAnchorTop to:VLayoutAnchorTop of:self margin:0];
    [_redView vAlign:VLayoutAnchorTop to:VLayoutAnchorTop of:self margin:16];
    [_redView vAlign:VLayoutAnchorTop to:VLayoutAnchorTop of:self margin:16];
    [_redView vAlign:VLayoutAnchorCenter to:VLayoutAnchorCenter of:self margin:0];
    [_redView vAlign:VLayoutAnchorCenter to:VLayoutAnchorCenter of:self margin:0];
    [_redView vAlign:VLayoutAnchorBottom to:VLayoutAnchorBottom of:_greenView margin:0];
    [_redView vAlign:VLayoutAnchorTop to:VLayoutAnchorTop of:_greenView margin:0];
    [_redView vAlign:VLayoutAnchorTop to:VLayoutAnchorBottom of:_greenView margin:0];
    [_redView vAlign:VLayoutAnchorBottom to:VLayoutAnchorTop of:_greenView margin:0];
    [_redView vAlign:VLayoutAnchorCenter to:VLayoutAnchorTop of:_greenView margin:0];
    [_redView vAlign:VLayoutAnchorCenter to:VLayoutAnchorBottom of:_greenView margin:0];
    
    _fieldLabel = [[Label alloc] initWithString:@"URL:"];
    [self addSubview:_fieldLabel];
    [_fieldLabel vAlign:VLayoutAnchorTop to:VLayoutAnchorTop of:[_fieldLabel superview] margin:16];
    [_fieldLabel hAlign:HLayoutAnchorLeft to:HLayoutAnchorLeft of:[_fieldLabel superview] margin:16];
    [_fieldLabel setAutoresizingMask:ViewBottomMargin];

    _fieldLabel2 = [[Label alloc] initWithString:@"URL2:"];
    [_greenView addSubview:_fieldLabel2];
    [_fieldLabel2 vAlign:VLayoutAnchorTop to:VLayoutAnchorTop of:[_fieldLabel2 superview] margin:32];
    [_fieldLabel2 hAlign:HLayoutAnchorLeft to:HLayoutAnchorLeft of:[_fieldLabel2 superview] margin:0];
    [_fieldLabel2 setAutoresizingMask:ViewBottomMargin];
    
    _urlField = [[NSTextField alloc] initWithFrame:RectZero];
    [_urlField sizeToFit];
    [self addSubview:_urlField];
    [_urlField vAlign:VLayoutAnchorTop to:VLayoutAnchorTop of:[_urlField superview] margin:16];
    [_urlField hAlign:HLayoutAnchorLeft to:HLayoutAnchorRight of:_fieldLabel margin:16];
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
