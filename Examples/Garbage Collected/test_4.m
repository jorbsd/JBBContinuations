// clang -arch i386 -arch x86_64 -fobjc-gc-only -Wl,-rpath,/Users/jordan/Build/JBBContinuations/Release -F/Users/jordan/Build/JBBContinuations/Release -o test_4 test_4.m -framework JBBContinuations -framework Cocoa

#import <Cocoa/Cocoa.h>
#import <JBBContinuations/JBBContinuations.h>

int main(int argc, char *argv[]) {
    objc_startCollectorThread();
    NSAutoreleasePool *localPool = [[NSAutoreleasePool alloc] init];

    
    [[NSString jbb_proxyWithContinuation:^(id anObject) {
        NSLog(@"%@", anObject);
    }] stringWithCString:"this is a test" encoding:NSUTF8StringEncoding];

    __block NSString *anOutsideObject = nil;
    [[NSString jbb_proxyWithContinuation:^(id anObject) {
        anOutsideObject = anObject;
    }] stringWithCString:"this is another test" encoding:NSUTF8StringEncoding];
    NSLog(@"%@", anOutsideObject);

    [[NSString jbb_proxyWithContinuation:^(id anObject) {
        NSLog(@"no error occurred");
    } errorHandler:^(NSError *anError) {
        if (anError) {
            NSLog(@"an error occurred: %@", anError);
        } else {
            NSLog(@"an error occurred");
        }
    }] stringWithContentsOfFile:@"/tmp/completely_fake_file.txt" encoding:NSUTF8StringEncoding error:nil];

    [localPool drain];
    return 0;
}

