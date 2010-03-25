//
//  NSDecimalNumber+JBBAdditions.m
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/11/13.
//  Copyright 2008 Jordan Breeding. All rights reserved.
//
//  BSD License, Use at your own risk
//

#import "NSNumber+JBBAdditions.h"

@implementation NSDecimalNumber (JBBAdditions)

#pragma mark Class Methods

+ (id)jbb_decimalNumberWithBool:(BOOL)aValue {
    return [[NSNumber numberWithBool:aValue] jbb_decimalNumberValue];
}

+ (id)jbb_decimalNumberWithChar:(char)aValue {
    return [[NSNumber numberWithChar:aValue] jbb_decimalNumberValue];
}

+ (id)jbb_decimalNumberWithDouble:(double)aValue {
    return [[NSNumber numberWithDouble:aValue] jbb_decimalNumberValue];
}

+ (id)jbb_decimalNumberWithFloat:(float)aValue {
    return [[NSNumber numberWithFloat:aValue] jbb_decimalNumberValue];
}

+ (id)jbb_decimalNumberWithInt:(int)aValue {
    return [[NSNumber numberWithInt:aValue] jbb_decimalNumberValue];
}

+ (id)jbb_decimalNumberWithInteger:(NSInteger)aValue {
    return [[NSNumber numberWithInteger:aValue] jbb_decimalNumberValue];
}

+ (id)jbb_decimalNumberWithLong:(long)aValue {
    return [[NSNumber numberWithLong:aValue] jbb_decimalNumberValue];
}

+ (id)jbb_decimalNumberWithLongLong:(long long)aValue {
    return [[NSNumber numberWithLongLong:aValue] jbb_decimalNumberValue];
}

+ (id)jbb_decimalNumberWithShort:(short)aValue {
    return [[NSNumber numberWithShort:aValue] jbb_decimalNumberValue];
}

+ (id)jbb_decimalNumberWithUnsignedChar:(unsigned char)aValue {
    return [[NSNumber numberWithUnsignedChar:aValue] jbb_decimalNumberValue];
}

+ (id)jbb_decimalNumberWithUnsignedInt:(unsigned int)aValue {
    return [[NSNumber numberWithUnsignedInt:aValue] jbb_decimalNumberValue];
}

+ (id)jbb_decimalNumberWithUnsignedInteger:(NSUInteger)aValue {
    return [[NSNumber numberWithUnsignedInteger:aValue] jbb_decimalNumberValue];
}

+ (id)jbb_decimalNumberWithUnsignedLong:(unsigned long)aValue {
    return [[NSNumber numberWithUnsignedLong:aValue] jbb_decimalNumberValue];
}

+ (id)jbb_decimalNumberWithUnsignedLongLong:(unsigned long long)aValue {
    return [[NSNumber numberWithUnsignedLongLong:aValue] jbb_decimalNumberValue];
}

+ (id)jbb_decimalNumberWithUnsignedShort:(unsigned short)aValue {
    return [[NSNumber numberWithUnsignedShort:aValue] jbb_decimalNumberValue];
}
@end

