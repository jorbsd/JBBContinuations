//
//  NSNumber+JBBAdditions.m
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/19.
//  Copyright 2008 Jordan Breeding. All rights reserved.
//

#import "NSNumber+JBBAdditions.h"

@implementation NSNumber (JBBAdditions)

#pragma mark Instance Methods

- (NSDecimalNumber *)decimalNumberValue {
  return [NSDecimalNumber decimalNumberWithDecimal: [self decimalValue]];
}
@end

