#import <Foundation/Foundation.h>

BOOL g_running = YES;
int g_exitStatus = 0;

@interface URLDelegate: NSObject
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
@end

@implementation URLDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse: %@", response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSString* string = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	NSLog(@"didReceiveData: %u bytes:\n%@", [data length], string);
	[string release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error);
	g_exitStatus = 1;
	g_running = NO;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
	g_running = NO;
}

@end

int main(int argc, char *argv[]) {
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
    NSURL* url = [NSURL URLWithString:@"http://leopard.sh/README.txt"];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
	
	URLDelegate* delegate = [[URLDelegate alloc] init];
    [NSURLConnection connectionWithRequest:request delegate:delegate];
	
	while (g_running) {
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
	}
    [pool release];
    return g_exitStatus;
}
