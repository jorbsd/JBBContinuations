//
//  NSString+JBBAdditions.m
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/19.
//  Copyright 2008 Jordan Breeding. All rights reserved.
//

#import "NSString+JBBAdditions.h"

@implementation NSString (JBBAdditions)

#pragma mark Instance Methods

- (BOOL)isEmpty {
  return ([self length] == 0);
}

- (BOOL)makeDirectoryStructureWithError:(NSError **)localError {
  NSString *localString = [self stringByDeletingLastPathComponent];
  
  if (![[NSFileManager defaultManager] createDirectoryAtPath:localString withIntermediateDirectories:YES
                                                  attributes:nil error:&localError]) {
    return NO;
  }
  
  return YES;
}

- (void)print {
  printf([self UTF8String]);
}

- (NSNumber *)unpack {
  if ([self lengthOfBytesUsingEncoding:NSUTF8StringEncoding] != 4) {
    return nil;
  }
  char *localCharArray = strdup([self UTF8String]);
  int localInt;
  memmove((void *)(&localInt), (void *)localCharArray, 4);
  free(localCharArray);
  return [[[NSNumber alloc] initWithUnsignedInt:NSSwapHostIntToBig(localInt)] autorelease];
}
@end

