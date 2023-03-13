//
//  main.m
//  NSApplicationDelegateDemo
//
//  Created by Jason Pepas on 3/12/23.
//  Copyright __MyCompanyName__ 2023. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate: NSObject
//- (BOOL)application:(NSApplication *)sender delegateHandlesKey:(NSString *)key;
//- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename;
//- (void)application:(NSApplication *)sender openFiles:(NSArray *)filenames;
//- (BOOL)application:(id)sender openFileWithoutUI:(NSString *)filename;
//- (BOOL)application:(NSApplication *)theApplication openTempFile:(NSString *)filename;
//- (BOOL)application:(NSApplication *)theApplication printFile:(NSString *)filename;
//- (NSApplicationPrintReply)application:(NSApplication *)application printFiles:(NSArray *)fileNames withSettings:(NSDictionary *)printSettings showPrintPanels:(BOOL)showPrintPanels;
//- (NSError *)application:(NSApplication *)application willPresentError:(NSError *)error;
- (void)applicationDidBecomeActive:(NSNotification *)aNotification;
- (void)applicationDidChangeScreenParameters:(NSNotification *)aNotification;
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;
- (void)applicationDidHide:(NSNotification *)aNotification;
- (void)applicationDidResignActive:(NSNotification *)aNotification;
- (void)applicationDidUnhide:(NSNotification *)aNotification;
- (void)applicationDidUpdate:(NSNotification *)aNotification;
//- (NSMenu *)applicationDockMenu:(NSApplication *)sender;
//- (BOOL)applicationOpenUntitledFile:(NSApplication *)theApplication;
//- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag;
//- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender;
//- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender;
//- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication;
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
}

- (void)applicationDidChangeScreenParameters:(NSNotification *)aNotification {
	NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	NSLog(@"%@", NSStringFromSelector(_cmd));
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
}

- (void)applicationWillBecomeActive:(NSNotification *)aNotification {
	NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification {
	NSLog(@"%@", NSStringFromSelector(_cmd));
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
}

@end

int main(int argc, char *argv[]) {
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

	// Using this approach, the first delegate callback we will receive
	// is applicationWillFinishLaunching:.
	AppDelegate* delegate = [[AppDelegate alloc] init];
	[[NSApplication sharedApplication] setDelegate:delegate];
    int ret = NSApplicationMain(argc,  (const char **) argv);
    
	[pool release];
	return ret;
}
