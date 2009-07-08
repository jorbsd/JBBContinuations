//
//  NSDecimalNumber+JBBAdditions.h
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/11/13.
//  Copyright 2008 Jordan Breeding. All rights reserved.
//

#import "NSNumber+JBBAdditions.h"

@interface NSDecimalNumber (JBBAdditions)

#pragma mark Class Methods

+ (id)jbb_decimalNumberWithBool:(BOOL)inValue;
+ (id)jbb_decimalNumberWithChar:(char)inValue;
+ (id)jbb_decimalNumberWithDouble:(double)inValue;
+ (id)jbb_decimalNumberWithFloat:(float)inValue;
+ (id)jbb_decimalNumberWithInt:(int)inValue;
+ (id)jbb_decimalNumberWithInteger:(NSInteger)inValue;
+ (id)jbb_decimalNumberWithLong:(long)inValue;
+ (id)jbb_decimalNumberWithLongLong:(long long)inValue;
+ (id)jbb_decimalNumberWithShort:(short)inValue;
+ (id)jbb_decimalNumberWithUnsignedChar:(unsigned char)inValue;
+ (id)jbb_decimalNumberWithUnsignedInt:(unsigned int)inValue;
+ (id)jbb_decimalNumberWithUnsignedInteger:(NSUInteger)inValue;
+ (id)jbb_decimalNumberWithUnsignedLong:(unsigned long)inValue;
+ (id)jbb_decimalNumberWithUnsignedLongLong:(unsigned long long)inValue;
+ (id)jbb_decimalNumberWithUnsignedShort:(unsigned short)inValue;
@end

