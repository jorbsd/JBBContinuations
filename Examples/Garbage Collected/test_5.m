// clang -arch i386 -arch x86_64 -fobjc-gc-only -Wl,-rpath,/Users/jordan/Build/JBBContinuations/Release -F/Users/jordan/Build/JBBContinuations/Release -o test_5 test_5.m -framework JBBContinuations -framework Cocoa

#import <Cocoa/Cocoa.h>
#import <JBBContinuations/JBBContinuations.h>

int main(int argc, char *argv[]) {
    objc_startCollectorThread();
    NSAutoreleasePool *localPool = [[NSAutoreleasePool alloc] init];

    id baseProxy = [NSString jbb_proxyWithContinuation:^(id anObject) {
        NSLog(@"base continuations");
    } errorHandler:^(NSError *anError) {
        NSLog(@"base errorHandler");
    }];

    [baseProxy stringWithCString:"this is a test" encoding:NSUTF8StringEncoding];

    [baseProxy stringWithContentsOfFile:@"/tmp/completely_fake_file.txt" encoding:NSUTF8StringEncoding error:nil];

    [baseProxy stringWithCString:"this is a test" encoding:NSUTF8StringEncoding continuation:^(id anObject) {
        NSLog(@"%@", anObject);
    }];

    __block NSString *anOutsideObject = nil;
    [baseProxy stringWithCString:"this is another test" encoding:NSUTF8StringEncoding continuation:^(id anObject) {
        anOutsideObject = anObject;
    }];
    NSLog(@"%@", anOutsideObject);

    [baseProxy stringWithContentsOfFile:@"/tmp/completely_fake_file.txt" encoding:NSUTF8StringEncoding error:nil continuation:^(id anObject) {
        NSLog(@"no error occurred");
    } errorHandler:^(NSError *anError) {
        if (anError) {
            NSLog(@"an error occurred: %@", anError);
        } else {
            NSLog(@"an error occurred");
        }
    }];

    [localPool drain];
    return 0;
}

