//
//  NSValue+JBBAdditions.m
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/19.
//  Copyright 2008 Jordan Breeding. All rights reserved.
//

@implementation NSValue (JBBAdditions)

#pragma mark Instance Methods

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

