//
//  main.m
//  NSURLConnectionDemo
//
//  Created by Jason Pepas on 3/15/23.
//  Copyright __MyCompanyName__ 2023. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface URLDelegate: NSObject
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
@end

@implementation URLDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"Response: %@", response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSLog(@"Data: %u bytes:", [data length]);
	NSString* string = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	[string autorelease];
	NSLog(@"%@", string);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error: %@", error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"DidFinish");
}

@end

int main(int argc, char *argv[]) {
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
    NSURL* url = [NSURL URLWithString:@"http://leopard.sh"];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];

	URLDelegate* delegate = [[URLDelegate alloc] init];
    [NSURLConnection connectionWithRequest:request delegate:delegate];

	int ret = NSApplicationMain(argc, (const char**)argv);
    [pool release];
    return ret;
}
