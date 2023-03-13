//
//  Foo.m
//  RandomApp
//
//  Created by Jason Pepas on 1/14/22.
//  Copyright 2022 __MyCompanyName__. All rights reserved.
//

#import "Foo.h"


@implementation Foo

- (void)awakeFromNib {
	[textField setStringValue:@""];
}

- (IBAction)generate:(id)sender {
	// Generate a number between 1 and 100 inclusive.
	int generated;
	generated = (random() % 100) + 1;
	NSLog(@"generated = %d", generated);
	
	// Ask the text field to change what it is displaying.
	[textField setIntValue:generated];
}

- (IBAction)seed:(id)sender {
	// Seed the random number generator with the time.
	srandom(time(NULL));
	[textField setStringValue:@"Generator seeded"];
}

@end
