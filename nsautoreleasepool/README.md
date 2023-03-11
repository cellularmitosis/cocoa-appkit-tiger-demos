# NSAutoreleasePool

Trivial example of using NSAutoreleasePool.

```objc
int main(int argc, char *argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int ret = NSApplicationMain(argc,  (const char **) argv);
    [pool release];
    return ret;
}
```
