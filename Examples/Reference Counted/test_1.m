// clang -arch i386 -arch x86_64 -Wl,-rpath,/Users/jordan/Build/JBBContinuations/Release -F/Users/jordan/Build/JBBContinuations/Release -o test_1 test_1.m -framework JBBContinuations -framework Cocoa

#import <Cocoa/Cocoa.h>
#import <JBBContinuations/JBBContinuations.h>

int main(int argc, char *argv[]) {
    NSAutoreleasePool *localPool = [[NSAutoreleasePool alloc] init];

    NSError *anError = nil;
    NSString *aString = nil;
    NSString *anotherString = nil;

    aString = [NSString stringWithCString:"this is a test" encoding:NSUTF8StringEncoding];
    NSLog(@"%@", aString);

    anotherString = [NSString stringWithCString:"this is another test" encoding:NSUTF8StringEncoding];
    NSLog(@"%@", anotherString);

    if (![NSString stringWithContentsOfFile:@"/tmp/completely_fake_file.txt" encoding:NSUTF8StringEncoding error:&anError]) {
        if (anError) {
            NSLog(@"an error occurred: %@", anError);
        } else {
            NSLog(@"an error occurred");
        }
    } else {
        NSLog(@"no error occurred");
    }

    [localPool drain];
    return 0;
}

