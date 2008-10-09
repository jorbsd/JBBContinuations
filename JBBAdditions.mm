//
//  JBBFSAdditions.mm
//  JBBFSAdditions
//
//  Created by Jordan Breeding on 26/1/08.
//  Copyright 2008 Jordan Breeding. All rights reserved.
//

#import <objc/objc-runtime.h>
#import <objc/objc-class.h>

#import <TagLib/mpegfile.h>
#import <TagLib/tag.h>
#import <TagLib/id3v1tag.h>
#import <TagLib/id3v2tag.h>

#import "JBBAdditions.h"

@implementation NSObject (JBBAdditions)
+ (BOOL)loadSelector:(SEL)oldSelector asSelector:(SEL)newSelector onlyWhenMissing:(BOOL)loadWhenMissing {
  if (loadWhenMissing && [self instancesRespondToSelector:newSelector]) {
    return NO;
  }
  
  if (![self instancesRespondToSelector:oldSelector]) {
    return NO;
  }
  
  Method oldSelectorMethod = class_getInstanceMethod([self class], oldSelector);
  IMP oldSelectorImplementation = method_getImplementation(oldSelectorMethod);
  const char *oldSelectorTypes = method_getTypeEncoding(oldSelectorMethod);
  class_addMethod([self class], newSelector, oldSelectorImplementation, oldSelectorTypes);
  
  return YES;
}

+ (BOOL)loadSelector:(SEL)oldSelector asSelector:(SEL)newSelector {
  return([self loadSelector:oldSelector asSelector:newSelector onlyWhenMissing:YES]);
}

+ (BOOL)swapSelector:(SEL)oldSelector withSelector:(SEL)newSelector {
  if (!([self instancesRespondToSelector:oldSelector] && [self instancesRespondToSelector:newSelector])) {
    return NO;
  }
  
  Method oldSelectorMethod = class_getInstanceMethod([self class], oldSelector);
  IMP oldSelectorImplementation = method_getImplementation(oldSelectorMethod);
  const char *oldSelectorTypes = method_getTypeEncoding(oldSelectorMethod);
  
  Method newSelectorMethod = class_getInstanceMethod([self class], newSelector);
  IMP newSelectorImplementation = method_getImplementation(newSelectorMethod);
  const char *newSelectorTypes = method_getTypeEncoding(newSelectorMethod);
  
  class_addMethod([self class], newSelector, oldSelectorImplementation, oldSelectorTypes);
  class_addMethod([self class], oldSelector, newSelectorImplementation, newSelectorTypes);
  
  return YES;
}
@end

@implementation NSArray (JBBAdditions)
- (id)firstObject {
  if ([self count] == 0) {
    return nil;
  }
  return [self objectAtIndex: 0];
}

- (BOOL)isEmpty {
  return ([self count] == 0);
}

- (NSArray *)dictionariesWithKey:(NSString *)keyName {
  NSMutableArray *newArray = [NSMutableArray array];
  for (id objectToAdd in self) {
    [newArray addObject:[[NSDictionary dictionaryWithObject:objectToAdd forKey:keyName] mutableCopy]];
  }
  return newArray;
}

- (NSArray *)dictionariesWithKey:(NSString *)keyName fromKeyPath:(NSString *)keyPath {
  id retrievedObject = [self valueForKeyPath:keyPath];
  if (retrievedObject && [retrievedObject isKindOfClass:[NSArray class]]) {
    return [retrievedObject dictionariesWithKey:keyName];
  }
  return nil;
}
@end

@implementation NSDictionary (JBBAdditions)
- (NSArray *)dictionariesForKey:(NSString *)keyName {
  id retrievedObject = [self objectForKey:keyName];
  if (retrievedObject && [retrievedObject isKindOfClass:[NSArray class]]) {
    return [retrievedObject dictionariesWithKey:keyName];
  }
  return nil;
}
@end

@implementation NSString (JBBAdditions)
- (void)print {
  printf([self UTF8String]);
}

- (NSNumber *)unpack {
  if ([self lengthOfBytesUsingEncoding:NSUTF8StringEncoding] != 4) {
    return(nil);
  }
  char *localCharArray = strdup([self UTF8String]);
  int localInt;
  memmove((void *)(&localInt), (void *)localCharArray, 4);
  free(localCharArray);
  return [[[NSNumber alloc] initWithUnsignedInt:NSSwapHostIntToBig(localInt)] autorelease];
}

- (BOOL)isEmpty {
  return ([self length] == 0);
}
@end

@implementation NSValue (JBBAdditions)
- (NSString *)pack {
  char tempCharArray[20];
  [self getValue:(void *)(&tempCharArray)];
  if (strlen(tempCharArray) != 4) {
    return nil;
  }
  char localCharArray[5];
  int localInt;
  memmove((void *)(&localInt), (void *)tempCharArray, 4);
  localInt = NSSwapBigIntToHost(localInt);
  memmove((void *)localCharArray, (void *)(&localInt), 4);
  localCharArray[4] = '\0';
  return [[[NSString alloc] initWithUTF8String:localCharArray] autorelease];
}
@end

@implementation NSData (JBBAdditions)
- (NSString *)pack {
  if ([self length] != 4) {
    return nil;
  }
  char localCharArray[5];
  int localInt;
  [self getBytes:(void *)(&localInt) length:4];
  localInt = NSSwapBigIntToHost(localInt);
  memmove((void *)localCharArray, (void *)(&localInt), 4);
  localCharArray[4] = '\0';
  return [[[NSString alloc] initWithUTF8String:localCharArray] autorelease];
}
@end

@implementation NSAppleEventDescriptor (JBBAdditions)
- (NSString *)pack {
  return [[self data] pack];
}
@end

@interface JBBID3Tag ()
- (void)refreshTags;
@end

@implementation JBBID3Tag
@synthesize path = _path;

+ (id)tagWithPath:(NSString *)newPath {
  return [[[self alloc] initWithPath:newPath] autorelease];
}

- (id)init {
  return [self initWithPath: @""];
}

- (id)initWithPath:(NSString *)newPath {
  self = [super init];
  
  if (!self) {
    return nil;
  }
  
  _path = [newPath retain];
  return self;
}

- (void)dealloc {
  [_path release];
  _path = nil;
  [super dealloc];
}

- (void)closeMpegFile {
  mpegFile.reset();
}

- (void)setPath:(NSString *)newPath {
  if ([_path isEqualToString:newPath]) {
    return;
  }
  [_path autorelease];
  _path = [newPath retain];
  [self refreshTags];
}

- (void)refreshTags {
  if ([[self path] isEmpty]) {
    mpegFile.reset();
  } else {
    char *pathToOpen = strdup([[self path] fileSystemRepresentation]);
    mpegFile.reset(new TagLib::MPEG::File(pathToOpen, true, TagLib::AudioProperties::Fast));
    free(pathToOpen);
  }
}

- (BOOL)hasV1Tag {
  return (mpegFile->ID3v1Tag() && !(mpegFile->ID3v1Tag()->isEmpty()));
}

- (BOOL)hasV2Tag {
  return (mpegFile->ID3v2Tag() && !(mpegFile->ID3v2Tag()->isEmpty()));
}

- (BOOL)removeV1Tag {
  uint32_t counter = 0;
  do {
    mpegFile->strip(TagLib::MPEG::File::ID3v1);
    usleep(10);
    [self refreshTags];
  } while ([self hasV1Tag] && (counter < 10));
  return ![self hasV1Tag];
}
@end
