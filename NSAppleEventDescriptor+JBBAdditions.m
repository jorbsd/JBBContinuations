//
//  NSAppleEventDescriptor+JBBAdditions.m
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/19.
//  Copyright 2008 Jordan Breeding. All rights reserved.
//

#import "NSAppleEventDescriptor+JBBAdditions.h"

#import "NSData+JBBAdditions.h"

@implementation NSAppleEventDescriptor (JBBAdditions)

#pragma mark Instance Methods

- (NSString *)pack {
  return [[self data] pack];
}
@end
