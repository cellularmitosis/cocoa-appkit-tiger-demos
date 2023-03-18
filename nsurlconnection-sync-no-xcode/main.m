#import <Foundation/Foundation.h>
#include <stdio.h>

// GET the contents of an HTTP URL and print it to stdout.

int main(int argc, char** argv) {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

	NSString* urlString = @"http://leopard.sh/README.txt";
    if (argc > 1) {
    	urlString = [NSString stringWithCString:argv[1]
								 encoding:NSASCIIStringEncoding];
    }
    NSURL* url = [NSURL URLWithString:urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];

    NSURLResponse* response = nil;
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request
										 returningResponse:&response
													 error:&error];

    int exitStatus = 0;
    if (error != nil) {
        NSLog(@"Error: %@", error);
        exitStatus = 1;
    } else if (data != nil) {
        NSString* string = [[NSString alloc] initWithData:data
												 encoding:NSASCIIStringEncoding];
        printf([string UTF8String]);
        [string release];
    }

    [pool release];
    return exitStatus;
}
