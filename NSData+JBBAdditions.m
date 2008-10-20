//
//  NSData+JBBAdditions.m
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/19.
//  Copyright 2008 Jordan Breeding. All rights reserved.
//

#import "NSData+JBBAdditions.h"

@implementation NSData (JBBAdditions)

#pragma mark Instance Methods

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

