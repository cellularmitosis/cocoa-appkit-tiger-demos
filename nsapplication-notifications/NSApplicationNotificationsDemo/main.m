//
//  main.m
//  NSApplicationNotificationsDemo
//
//  Created by Jason Pepas on 3/12/23.
//  Copyright __MyCompanyName__ 2023. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppListener: NSObject
- (void)registerForNotifications;
@end

@implementation AppListener

- (void)didReceiveNotification:(NSNotification*)notification {
	NSLog(@"%@", [notification name]);
}

- (void)registerForNotifications {
	[[NSNotificationCenter defaultCenter]
		addObserver:self
		selector:@selector(didReceiveNotification:)
		name:NSApplicationDidBecomeActiveNotification
		object:nil];
	[[NSNotificationCenter defaultCenter]
		addObserver:self
		selector:@selector(didReceiveNotification:)
		name:NSApplicationDidChangeScreenParametersNotification
		object:nil];
	[[NSNotificationCenter defaultCenter]
		addObserver:self
		selector:@selector(didReceiveNotification:)
		name:NSApplicationDidFinishLaunchingNotification
		object:nil];
	[[NSNotificationCenter defaultCenter]
		addObserver:self
		selector:@selector(didReceiveNotification:)
		name:NSApplicationDidHideNotification
		object:nil];
	[[NSNotificationCenter defaultCenter]
		addObserver:self
		selector:@selector(didReceiveNotification:)
		name:NSApplicationDidResignActiveNotification
		object:nil];
	[[NSNotificationCenter defaultCenter]
		addObserver:self
		selector:@selector(didReceiveNotification:)
		name:NSApplicationDidUnhideNotification
		object:nil];
	[[NSNotificationCenter defaultCenter]
		addObserver:self
		selector:@selector(didReceiveNotification:)
		name:NSApplicationDidUpdateNotification
		object:nil];
	[[NSNotificationCenter defaultCenter]
		addObserver:self
		selector:@selector(didReceiveNotification:)
		name:NSApplicationWillBecomeActiveNotification
		object:nil];
	[[NSNotificationCenter defaultCenter]
		addObserver:self
		selector:@selector(didReceiveNotification:)
		name:NSApplicationWillFinishLaunchingNotification
		object:nil];
	[[NSNotificationCenter defaultCenter]
		addObserver:self
		selector:@selector(didReceiveNotification:)
		name:NSApplicationWillHideNotification
		object:nil];
	[[NSNotificationCenter defaultCenter]
		addObserver:self
		selector:@selector(didReceiveNotification:)
		name:NSApplicationWillResignActiveNotification
		object:nil];
	[[NSNotificationCenter defaultCenter]
		addObserver:self
		selector:@selector(didReceiveNotification:)
		name:NSApplicationWillTerminateNotification
		object:nil];
	[[NSNotificationCenter defaultCenter]
		addObserver:self
		selector:@selector(didReceiveNotification:)
		name:NSApplicationWillUnhideNotification
		object:nil];
	[[NSNotificationCenter defaultCenter]
		addObserver:self
		selector:@selector(didReceiveNotification:)
		name:NSApplicationWillUpdateNotification
		object:nil];
}

@end

int main(int argc, char *argv[]) {
	// Using this approach, the first notification we will receive
	// is NSApplicationWillFinishLaunchingNotification.
	AppListener* listener = [[AppListener alloc] init];
	[listener registerForNotifications];
    return NSApplicationMain(argc,  (const char **) argv);
}
