//
//  NSDecimalNumber+JBBAdditions.m
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/11/13.
//  Copyright 2008 Jordan Breeding. All rights reserved.
//

#import "NSNumber+JBBAdditions.h"

@implementation NSDecimalNumber (JBBAdditions)

#pragma mark Class Methods

+ (id)jbb_decimalNumberWithBool:(BOOL)inValue {
  return [[NSNumber numberWithBool:inValue] jbb_decimalNumberValue];
}

+ (id)jbb_decimalNumberWithChar:(char)inValue {
  return [[NSNumber numberWithChar:inValue] jbb_decimalNumberValue];
}

+ (id)jbb_decimalNumberWithDouble:(double)inValue {
  return [[NSNumber numberWithDouble:inValue] jbb_decimalNumberValue];
}

+ (id)jbb_decimalNumberWithFloat:(float)inValue {
  return [[NSNumber numberWithFloat:inValue] jbb_decimalNumberValue];
}

+ (id)jbb_decimalNumberWithInt:(int)inValue {
  return [[NSNumber numberWithInt:inValue] jbb_decimalNumberValue];
}

+ (id)jbb_decimalNumberWithInteger:(NSInteger)inValue {
  return [[NSNumber numberWithInteger:inValue] jbb_decimalNumberValue];
}

+ (id)jbb_decimalNumberWithLong:(long)inValue {
  return [[NSNumber numberWithLong:inValue] jbb_decimalNumberValue];
}

+ (id)jbb_decimalNumberWithLongLong:(long long)inValue {
  return [[NSNumber numberWithLongLong:inValue] jbb_decimalNumberValue];
}

+ (id)jbb_decimalNumberWithShort:(short)inValue {
  return [[NSNumber numberWithShort:inValue] jbb_decimalNumberValue];
}

+ (id)jbb_decimalNumberWithUnsignedChar:(unsigned char)inValue {
  return [[NSNumber numberWithUnsignedChar:inValue] jbb_decimalNumberValue];
}

+ (id)jbb_decimalNumberWithUnsignedInt:(unsigned int)inValue {
  return [[NSNumber numberWithUnsignedInt:inValue] jbb_decimalNumberValue];
}

+ (id)jbb_decimalNumberWithUnsignedInteger:(NSUInteger)inValue {
  return [[NSNumber numberWithUnsignedInteger:inValue] jbb_decimalNumberValue];
}

+ (id)jbb_decimalNumberWithUnsignedLong:(unsigned long)inValue {
  return [[NSNumber numberWithUnsignedLong:inValue] jbb_decimalNumberValue];
}

+ (id)jbb_decimalNumberWithUnsignedLongLong:(unsigned long long)inValue {
  return [[NSNumber numberWithUnsignedLongLong:inValue] jbb_decimalNumberValue];
}

+ (id)jbb_decimalNumberWithUnsignedShort:(unsigned short)inValue {
  return [[NSNumber numberWithUnsignedShort:inValue] jbb_decimalNumberValue];
}
@end

