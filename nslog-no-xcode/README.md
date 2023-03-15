# NSLog demo, without Xcode 

This is a demo of using NSLog, but without involving Cocoa and Xcode.

```
$ gcc -Wall -framework Foundation main.m
$ ./a.out 
2023-03-11 09:48:55.464 a.out[5091:10b] Hello, world!
```

To ensure compatibility with G3's running Tiger:

```
$ gcc -Wall -framework Foundation -mmacosx-version-min=10.4 -mcpu=750 main.m
```
