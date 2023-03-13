//
//  Foo.h
//  RandomApp
//
//  Created by Jason Pepas on 1/14/22.
//  Copyright 2022 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Foo : NSObject {
	IBOutlet NSTextField* textField;
}

- (IBAction)seed:(id)sender;
- (IBAction)generate:(id)sender;

@end
