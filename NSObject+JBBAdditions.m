//
//  NSObject+JBBAdditions.m
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/19.
//  Copyright 2008 Jordan Breeding. All rights reserved.
//

#import "NSObject+JBBAdditions.h"
#import "NSString+JBBAdditions.h"

void jbb_puts(id objectToPrint) {
  [objectToPrint jbb_puts];
}

@implementation NSObject (JBBAdditions)

#pragma mark Instance Methods

- (void)jbb_puts {
  if ([[self description] hasSuffix:@"\n"]) {
    [[self description] jbb_print];
  } else {
    [[[self description] stringByAppendingString:@"\n"] jbb_print];
  }
}
@end

