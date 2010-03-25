//
//  NSNumber+JBBAdditions.m
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/11/13.
//  Copyright 2008 Jordan Breeding. All rights reserved.
//
//  BSD License, Use at your own risk
//

@implementation NSNumber (JBBAdditions)

#pragma mark Instance Methods

- (NSDecimalNumber *)jbb_decimalNumberValue {
    return [NSDecimalNumber decimalNumberWithString:[self stringValue]];
}
@end

