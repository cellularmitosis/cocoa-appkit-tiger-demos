#import <Foundation/Foundation.h>

int main(int argc, char** argv) {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

    NSURL* url = [NSURL URLWithString:@"http://leopard.sh"];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];

    NSURLResponse* response = nil;
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"sent request");

    int ret = 0;
    if (error != nil) {
        NSLog(@"Error: %@", error);
        ret = 1;
    } else if (data != nil) {
        NSLog(@"Retrieved %u bytes of data:", [data length]);
        NSString* string = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        [string autorelease];
        NSLog(@"%@", string);
    }

    [pool release];
    return ret;
}
