//
//  NSDictionary+JBBAdditions.m
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/19.
//  Copyright 2008 Jordan Breeding. All rights reserved.
//
//  BSD License, Use at your own risk
//

#import "NSDictionary+JBBAdditions.h"
#import "NSArray+JBBAdditions.h"

@implementation NSDictionary (JBBAdditions)

#pragma mark Instance Methods

- (BOOL)jbb_boolForKey:(id)aKey {
    id foundObject = [self objectForKey:aKey];
    if (foundObject && ([foundObject isKindOfClass:[NSNumber class]] || [foundObject isKindOfClass:[NSString class]])) {
        return [foundObject boolValue];
    }
    return NO;
}

- (NSDecimalNumber *)jbb_decimalNumberForKey:(id)aKey {
    id foundObject = [self objectForKey:aKey];
    if (foundObject && [foundObject isKindOfClass:[NSDecimalNumber class]]) {
        return foundObject;
    } else if (foundObject && [foundObject isKindOfClass:[NSNumber class]]) {
        return [NSDecimalNumber decimalNumberWithString:[foundObject stringValue]];
    }
    return nil;
}

- (NSArray *)jbb_dictionariesForKey:(id)aKey {
    id retrievedObject = [self objectForKey:aKey];
    if (retrievedObject && [retrievedObject isKindOfClass:[NSArray class]]) {
        return [(NSArray *)retrievedObject jbb_dictionariesWithKey:aKey];
    }
    return nil;
}

- (double)jbb_doubleForKey:(id)aKey {
    id foundObject = [self objectForKey:aKey];
    if (foundObject && ([foundObject isKindOfClass:[NSNumber class]] || [foundObject isKindOfClass:[NSString class]])) {
        return [foundObject doubleValue];
    }
    return (double)0;
}

- (float)jbb_floatForKey:(id)aKey {
    id foundObject = [self objectForKey:aKey];
    if (foundObject && ([foundObject isKindOfClass:[NSNumber class]] || [foundObject isKindOfClass:[NSString class]])) {
        return [foundObject floatValue];
    }
    return (float)0;
}

- (int)jbb_integerForKey:(id)aKey {
    id foundObject = [self objectForKey:aKey];
    if (foundObject && ([foundObject isKindOfClass:[NSNumber class]] || [foundObject isKindOfClass:[NSString class]])) {
        return [foundObject intValue];
    }
    return (int)0;
}

- (NSNumber *)jbb_numberForKey:(id)aKey {
    id foundObject = [self objectForKey:aKey];
    if (foundObject && [foundObject isKindOfClass:[NSNumber class]]) {
        return foundObject;
    }
    return nil;
}

- (NSString *)jbb_stringForKey:(id)aKey {
    id foundObject = [self objectForKey:aKey];
    if (foundObject && [foundObject isKindOfClass:[NSString class]]) {
        return foundObject;
    }
    return nil;
}
@end

