//
//  main.m
//  NSURLConnectionDemo
//
//  Created by Jason Pepas on 3/18/23.
//  Copyright __MyCompanyName__ 2023. All rights reserved.
//

#import <Cocoa/Cocoa.h>

const NSRect RectZero = { 0, 0, 0, 0 };
const NSPoint PointZero = { 0, 0 };

NSRect Bounds(NSRect rect) {
    return NSMakeRect(0, 0, rect.size.width, rect.size.height);
}


// MARK: - NSView (Layout)

#define ViewLeftMargin (NSViewMinXMargin)
#define ViewRightMargin (NSViewMaxXMargin)
#define ViewBottomMargin (NSViewMinYMargin)
#define ViewTopMargin (NSViewMaxYMargin)

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
    self = [super initWithFrame:NSMakeRect(0, 0, 0, 0)];
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


// MARK: - MainView

@interface MainView: NSView {
    Label* _fieldLabel;
    NSTextField* _urlField;
    NSButton* _getButton;
    NSTextView* _responseView;
}
@end

@interface MainView (Private)
- (void)didClickGET:(id)sender;
@end

@implementation MainView

- (id)initWithFrame:(NSRect)frame {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    self = [super initWithFrame:frame];
    if (self == nil) {
        return nil;
    }
    _fieldLabel = [[Label alloc] initWithString:@"URL:"];
    [self addSubview:_fieldLabel];
    [_fieldLabel yAlign:YAnchorTop to:YAnchorTop of:self margin:16]; // FIXME there's a bug in yAlign
    [_fieldLabel xAlign:XAnchorLeft to:XAnchorLeft of:self margin:16];
    [_fieldLabel setAutoresizingMask:ViewBottomMargin];

    _getButton = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 48, 36)];
    [_getButton setBezelStyle:NSMomentaryPushInButton];
    [_getButton setTitle:@"GET"];
//    [_getButton sizeToFit];
//    [_getButton setFrameSize:NSMakeSize([_getButton bounds].size.width + 64, [_getButton bounds].size.height)];
    [self addSubview:_getButton];
    [_getButton yAlign:YAnchorCenter to:YAnchorCenter of:_fieldLabel margin:16]; // FIXME there's a bug in yAlign
    [_getButton xAlign:XAnchorRight to:XAnchorRight of:self margin:16];
    [_getButton setAutoresizingMask:ViewBottomMargin|ViewLeftMargin];
    [_getButton setTarget:self];
    [_getButton setAction:@selector(didClickGET:)];
    
    _urlField = [[NSTextField alloc] initWithFrame:RectZero];
    [_urlField sizeToFit];
    [self addSubview:_urlField];
    [_urlField yAlign:YAnchorCenter to:YAnchorCenter of:_fieldLabel margin:16]; // FIXME there's a bug in yAlign
    [_urlField xAlign:XAnchorLeft to:XAnchorRight of:_fieldLabel margin:16];
    [_urlField xStretch:XAnchorRight to:XAnchorLeft of:_getButton margin:16];
    [_urlField setAutoresizingMask:ViewBottomMargin|NSViewWidthSizable];
    [_urlField setStringValue:@"http://leopard.sh/README.txt"];

    _responseView = [[NSTextView alloc] initWithFrame:NSMakeRect(0,0,300,300)];
//    [_responseView setString:@"The quick brown fox"];
    [self addSubview:_responseView];
    [_responseView yAlign:YAnchorTop to:YAnchorBottom of:_fieldLabel margin:16+22]; // BUG
    [_responseView yStretch:YAnchorBottom to:YAnchorBottom of:self margin:16];
    [_responseView xAlign:XAnchorLeft to:XAnchorLeft of:self margin:16];
//    [_responseView xStretch:XAnchorRight to:XAnchorRight of:self margin:16]; // BUG
    [_responseView setAutoresizingMask:NSViewWidthSizable|ViewBottomMargin];

//    [_responseView sizeToFit];

    return self;

//    [_responseView pinToTopEdgeOfSuperViewWithMargin:64];
//    [_responseView pinToLeftEdgeOfSuperViewWithMargin:16];
//    [_responseView pinToRightEdgeOfSuperViewWithMargin:16];
//    [_responseView pinToBottomEdgeOfSuperViewWithMargin:16];
//    [_responseView setFrame:NSMakeRect(16,
//                                       [self bounds].size.height - 16,
//                                       [self bounds].size.width - 32,
//                                       [self bounds].size.height - 32)];
    [_responseView setFrame:NSMakeRect(16,
                                       [self bounds].size.height - 16,
                                       100,
                                       100)];
//    [_responseView setAutoresizingMask:NSViewMinXMargin|NSViewMaxXMargin|NSViewMinYMargin|NSViewMinYMargin];
    [_responseView setAutoresizingMask:NSViewWidthSizable];
        
    return self;
}

- (void)dealloc {
    [_fieldLabel release];
    [_urlField release];
    [_responseView release];
    [_getButton release];
    [super dealloc];
}

- (void)didClickGET:(id)sender {
    NSString* urlString = [_urlField stringValue];
    [_responseView setString:@""];
    NSURL* url = [NSURL URLWithString:urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
}
@end

@interface MainView (NSURLConnectionDelegate)
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
@end

@implementation MainView (NSURLConnectionDelegate)
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
//    NSLog(@"didReceiveResponse: %@", response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSString* string = [[NSString alloc] initWithData:data
                                             encoding:NSASCIIStringEncoding];
//    NSLog(@"didReceiveData: %u bytes:\n", [data length]);
    printf([string UTF8String]);
    [_responseView setString:[[_responseView string] stringByAppendingString:string]];
    [string release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error);
    [_responseView setString:[NSString stringWithFormat:@"%@", error]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//    NSLog(@"connectionDidFinishLoading");
}
@end


// MARK: - AppDelegate

@interface AppDelegate: NSObject
- (void)applicationWillBecomeActive:(NSNotification *)aNotification;
@end

@implementation AppDelegate
- (void)applicationWillBecomeActive:(NSNotification *)aNotification {
    NSWindow* window = [[[NSApplication sharedApplication] windows] objectAtIndex:0];
	if ([[window contentView] isKindOfClass:[MainView class]] == NO) {
		NSView* mainView = [[MainView alloc] initWithFrame:[window frame]];
		[window setContentView:mainView];
        [mainView release];
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
