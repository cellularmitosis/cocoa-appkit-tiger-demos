//
//  main.m
//  NSAutoreleasePoolDemo
//
//  Created by Jason Pepas on 3/11/23.
//  Copyright __MyCompanyName__ 2023. All rights reserved.
//

#import <Cocoa/Cocoa.h>

int main(int argc, char *argv[])
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int ret = NSApplicationMain(argc,  (const char **) argv);
	[pool release];
	return ret;
}
