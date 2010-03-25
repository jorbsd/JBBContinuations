//
//  NSDecimalNumber+JBBAdditions.h
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/11/13.
//  Copyright 2008 Jordan Breeding. All rights reserved.
//
//  BSD License, Use at your own risk
//

#import <Foundation/Foundation.h>
#import "NSNumber+JBBAdditions.h"

@interface NSDecimalNumber (JBBAdditions)

#pragma mark Class Methods

+ (id)jbb_decimalNumberWithBool:(BOOL)aValue;
+ (id)jbb_decimalNumberWithChar:(char)aValue;
+ (id)jbb_decimalNumberWithDouble:(double)aValue;
+ (id)jbb_decimalNumberWithFloat:(float)aValue;
+ (id)jbb_decimalNumberWithInt:(int)aValue;
+ (id)jbb_decimalNumberWithInteger:(NSInteger)aValue;
+ (id)jbb_decimalNumberWithLong:(long)aValue;
+ (id)jbb_decimalNumberWithLongLong:(long long)aValue;
+ (id)jbb_decimalNumberWithShort:(short)aValue;
+ (id)jbb_decimalNumberWithUnsignedChar:(unsigned char)aValue;
+ (id)jbb_decimalNumberWithUnsignedInt:(unsigned int)aValue;
+ (id)jbb_decimalNumberWithUnsignedInteger:(NSUInteger)aValue;
+ (id)jbb_decimalNumberWithUnsignedLong:(unsigned long)aValue;
+ (id)jbb_decimalNumberWithUnsignedLongLong:(unsigned long long)aValue;
+ (id)jbb_decimalNumberWithUnsignedShort:(unsigned short)aValue;
@end

