// clang -arch i386 -arch x86_64 -Wl,-rpath,/Users/jordan/Build/JBBContinuations/Release -F/Users/jordan/Build/JBBContinuations/Release -o test_3 test_3.m -framework JBBContinuations -framework Cocoa

#import <Cocoa/Cocoa.h>
#import <JBBContinuations/JBBContinuations.h>

int main(int argc, char *argv[]) {
    NSAutoreleasePool *localPool = [[NSAutoreleasePool alloc] init];

    [[NSString jbb_proxy] stringWithCString:"this is a test" encoding:NSUTF8StringEncoding continuation:^(id anObject) {
        NSLog(@"%@", anObject);
    }];

    __block NSString *anOutsideObject = nil;
    [[NSString jbb_proxy] stringWithCString:"this is another test" encoding:NSUTF8StringEncoding continuation:^(id anObject) {
        anOutsideObject = [anObject retain];
    }];
    NSLog(@"%@", [anOutsideObject autorelease]);

    [[NSString jbb_proxy] stringWithContentsOfFile:@"/tmp/completely_fake_file.txt" encoding:NSUTF8StringEncoding error:nil continuation:^(id anObject) {
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

