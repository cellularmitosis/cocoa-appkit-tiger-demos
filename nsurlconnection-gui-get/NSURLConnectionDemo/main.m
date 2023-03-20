//
//  main.m
//  NSURLConnectionDemo
//
//  Created by Jason Pepas on 3/18/23.
//  Copyright __MyCompanyName__ 2023. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSView (Layout)
- (void)pinToTopEdgeOfSuperViewWithMargin:(float)margin;
- (void)pinToBottomEdgeOfSuperViewWithMargin:(float)margin;
- (void)pinToLeftEdgeOfSuperViewWithMargin:(float)margin;
- (void)pinToRightEdgeOfSuperViewWithMargin:(float)margin;
@end

@implementation NSView (Layout)
- (void)pinToTopEdgeOfSuperViewWithMargin:(float)margin {
    NSPoint newOrigin = NSMakePoint([self frame].origin.x,
                                    [[self superview] frame].size.height - [self bounds].size.height - margin);
    [self setFrameOrigin:newOrigin];
    [self setAutoresizingMask:([self autoresizingMask])|NSViewMinYMargin];
}

- (void)pinToBottomEdgeOfSuperViewWithMargin:(float)margin {
    NSPoint newOrigin = NSMakePoint([self frame].origin.x, margin);
    [self setFrameOrigin:newOrigin];
    [self setAutoresizingMask:([self autoresizingMask])|NSViewMaxYMargin];
}

- (void)pinToLeftEdgeOfSuperViewWithMargin:(float)margin {
    NSPoint newOrigin = NSMakePoint(margin, [self frame].origin.y);
    [self setFrameOrigin:newOrigin];
    [self setAutoresizingMask:([self autoresizingMask])|NSViewMaxXMargin];
}

- (void)pinToRightEdgeOfSuperViewWithMargin:(float)margin {
    NSPoint newOrigin = NSMakePoint([[self superview] frame].size.width - [self bounds].size.width - margin,
                                    [self frame].origin.y);
    [self setFrameOrigin:newOrigin];
    [self setAutoresizingMask:([self autoresizingMask])|NSViewMinXMargin];
}
@end

@interface Label: NSTextField
- (id)initWithString:(NSString*)string;
@end

@implementation Label
- (id)initWithString:(NSString*)string {
    self = [super init];
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

@interface MainView: NSView {
    Label* _fieldLabel;
    NSTextField* _urlField;
    NSTextView* _responseView;
    NSButton* _getButton;
}
@end

@interface MainView (Private)
- (void)didClickGET:(id)sender;
@end

@implementation MainView

- (void)drawRect:(NSRect)rect {
	[[NSColor blueColor] setFill];
	NSRectFill(rect);
	[super drawRect:rect];
}

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self == nil) {
        return nil;
    }
    _fieldLabel = [[Label alloc] initWithString:@"URL:"];
    [self addSubview:_fieldLabel];
    [_fieldLabel pinToTopEdgeOfSuperViewWithMargin:16];
    [_fieldLabel pinToLeftEdgeOfSuperViewWithMargin:16];

    _urlField = [[NSTextField alloc] init];
    [self addSubview:_urlField];

    _responseView = [[NSTextView alloc] init];
    [self addSubview:_responseView];
//    [_responseView setFrameSize:NSMakeSize(100, 100)];
    [_responseView setString:@"The quick brown fox"];
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
    
    _getButton = [[NSButton alloc] init];
    [_getButton setTarget:self];
    [_getButton setAction:@selector(didClickGET:)];
    [self addSubview:_getButton];
    
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
    NSString* urlString = @"http://leopard.sh/README.txt";
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
    [string release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//    NSLog(@"connectionDidFinishLoading");
}
@end

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

int main(int argc, char *argv[]) {
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	AppDelegate* delegate = [[AppDelegate alloc] init];
	[[NSApplication sharedApplication] setDelegate:delegate];
    int exitStatus = NSApplicationMain(argc, (const char **)argv);
	[pool release];
	return exitStatus;
}
