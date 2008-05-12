//
//  JBBFSAdditions.mm
//  JBBFSAdditions
//
//  Created by Jordan Breeding on 26/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "JBBAdditionsPrivate.h"
#import <taglib/mpegfile.h>
#import <taglib/tag.h>
#import <objc/objc-runtime.h>
#import <objc/objc-class.h>

//void NSPrintf(NSString *formatString, ...)
//{
//    va_list args;
//    va_start(args, formatString);
//    id tempString = [[NSString alloc] initWithFormat: formatString arguments: args];
//    va_end(args);
//    printf([tempString UTF8String]);
//    [tempString release];
//}

@implementation NSObject (jbb)
+(BOOL) loadSelector: (SEL) oldSelector asSelector: (SEL) newSelector onlyWhenMissing: (BOOL) loadWhenMissing
{
    if (loadWhenMissing && [self instancesRespondToSelector: newSelector])
        return(NO);
    
    if (![self instancesRespondToSelector: oldSelector])
        return(NO);
    
    Method oldSelectorMethod = class_getInstanceMethod([self class], oldSelector);
    IMP oldSelectorImplementation = method_getImplementation(oldSelectorMethod);
    const char *oldSelectorTypes = method_getTypeEncoding(oldSelectorMethod);
    class_addMethod([self class], newSelector, oldSelectorImplementation, oldSelectorTypes);
    
    return(YES);
}
+(BOOL) loadSelector: (SEL) oldSelector asSelector: (SEL) newSelector
{
    return([self loadSelector: oldSelector asSelector: newSelector onlyWhenMissing: YES]);
}
+(BOOL) swapSelector: (SEL) oldSelector withSelector: (SEL) newSelector
{
    if (!([self instancesRespondToSelector: oldSelector] && [self instancesRespondToSelector: newSelector]))
        return(NO);
    
    Method oldSelectorMethod = class_getInstanceMethod([self class], oldSelector);
    IMP oldSelectorImplementation = method_getImplementation(oldSelectorMethod);
    const char *oldSelectorTypes = method_getTypeEncoding(oldSelectorMethod);
    
    Method newSelectorMethod = class_getInstanceMethod([self class], newSelector);
    IMP newSelectorImplementation = method_getImplementation(newSelectorMethod);
    const char *newSelectorTypes = method_getTypeEncoding(newSelectorMethod);
    
    class_addMethod([self class], newSelector, oldSelectorImplementation, oldSelectorTypes);
    class_addMethod([self class], oldSelector, newSelectorImplementation, newSelectorTypes);
    
    return(YES);
}
@end

@implementation NSArray (utils)
-(id) firstObject {
    if ([self count] == 0)
        return(nil);
    return([self objectAtIndex: 0]);
}
-(BOOL) isEmpty {
    return([self count] == 0);
}
-(NSArray*) dictionariesWithKey: (NSString*) keyName
{
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity: [self count]];
    for (id objectToAdd in self) {
        [newArray addObject: [[NSDictionary dictionaryWithObject: objectToAdd forKey: keyName] mutableCopy]];
    }
    return([newArray autorelease]);
}
-(NSArray*) dictionariesWithKey: (NSString*) keyName fromKeyPath: (NSString*) keyPath
{
    id retrievedObject = [self valueForKeyPath: keyPath];
    if (retrievedObject && [retrievedObject isKindOfClass: [NSArray class]]) {
        return([retrievedObject dictionariesWithKey: keyName]);
    }
    return(nil);
}
@end

@implementation NSDictionary (utils)
-(NSArray*) dictionariesForKey: (NSString*) keyName
{
    id retrievedObject = [self objectForKey: keyName];
    if (retrievedObject && [retrievedObject isKindOfClass: [NSArray class]]) {
        return([retrievedObject dictionariesWithKey: keyName]);
    }
    return(nil);
}
@end

@implementation NSString (utils)
-(void) print
{
    printf([self UTF8String]);
}
-(NSNumber*) unpack
{
    if ([self lengthOfBytesUsingEncoding: NSUTF8StringEncoding] != 4) {
        return(nil);
    }
    const char *localCharArray = [self UTF8String];
    int localInt;
    memmove((void*)(&localInt), (void*)localCharArray, 4);
    return([[[NSNumber alloc] initWithUnsignedInt: NSSwapHostIntToBig(localInt)] autorelease]);
}
@end

@implementation NSValue (utils)
-(NSString*) pack
{
    char tempCharArray[20];
    [self getValue: (void*)(&tempCharArray)];
    if (strlen(tempCharArray) != 4) {
        return(nil);
    }
    char localCharArray[5];
    int localInt;
    memmove((void*)(&localInt), (void*)tempCharArray, 4);
    localInt = NSSwapBigIntToHost(localInt);
    memmove((void*)localCharArray, (void*)(&localInt), 4);
    localCharArray[4] = '\0';
    return([[[NSString alloc] initWithUTF8String: localCharArray] autorelease]);
}
@end

@implementation NSData (utils)
-(NSString*) pack
{
    if ([self length] != 4) {
        return(nil);
    }
    char localCharArray[5];
    int localInt;
    [self getBytes: (void*)(&localInt) length: 4];
    localInt = NSSwapBigIntToHost(localInt);
    memmove((void*)localCharArray, (void*)(&localInt), 4);
    localCharArray[4] = '\0';
    return([[[NSString alloc] initWithUTF8String: localCharArray] autorelease]);
}
@end

@implementation NSAppleEventDescriptor (utils)
-(NSString*) pack
{
    return([[self data] pack]);
}
@end

@implementation JBBID3Tag
@synthesize _filePath;

+(id) tagWithPath: (NSString*) newFilePath
{
    return([[[self alloc] initWithPath: newFilePath] autorelease]);
}

-(id) init
{
    return([self initWithPath: @""]);
}
-(id) initWithPath: (NSString*) newFilePath
{
    if (![super init]) {
        return(nil);
    }
    
    self.filePath = newFilePath;
    return(self);
}
-(void) setFilePath: (NSString*) newFilePath
{
    if (_filePath == newFilePath) {
        return;
    }
    _filePath = [newFilePath copy];
    if (_mpegFile) {
        [self closeFile];
    }
    _mpegFile = new TagLib::MPEG::File([newFilePath UTF8String]);
}
-(BOOL) hasV1Tag
{
    return(_mpegFile->ID3v1Tag() != nil);
}

-(BOOL) hasV2Tag
{
    return(_mpegFile->ID3v2Tag() != nil);
}

-(BOOL) removeV1Tag
{
    return(_mpegFile->strip(TagLib::MPEG::File::ID3v1));
}

-(void) closeFile
{
    delete _mpegFile;
    _mpegFile = nil;
}
@end
