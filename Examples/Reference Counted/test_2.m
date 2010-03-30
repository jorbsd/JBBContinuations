// clang -arch i386 -arch x86_64 -Wl,-rpath,/Users/jordan/Build/JBBContinuations/Release -F/Users/jordan/Build/JBBContinuations/Release -o test_2 test_2.m -framework JBBContinuations -framework Cocoa

#import <Cocoa/Cocoa.h>
#import <JBBContinuations/JBBContinuations.h>

int main(int argc, char *argv[]) {
    NSAutoreleasePool *localPool = [[NSAutoreleasePool alloc] init];

    [WRAP_MSG_SEND(NSString, stringWithCString:"this is a test" encoding:NSUTF8StringEncoding) jbb_invokeWithContinuation:^(id anObject) {
        NSLog(@"%@", anObject);
    }];

    __block NSString *anOutsideObject = nil;
    [WRAP_MSG_SEND(NSString, stringWithCString:"this is another test" encoding:NSUTF8StringEncoding) jbb_invokeWithContinuation:^(id anObject) {
        anOutsideObject = [anObject retain];
    }];
    NSLog(@"%@", [anOutsideObject autorelease]);

    [WRAP_MSG_SEND(NSString, stringWithContentsOfFile:@"/tmp/completely_fake_file.txt" encoding:NSUTF8StringEncoding error:nil) jbb_invokeWithContinuation:^(id anObject) {
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

