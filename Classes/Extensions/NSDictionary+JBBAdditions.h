//
//  NSDictionary+JBBAdditions.h
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/19.
//  Copyright 2008 Jordan Breeding. All rights reserved.
//
//  BSD License, Use at your own risk
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JBBAdditions)

#pragma mark Instance Methods

- (BOOL)jbb_boolForKey:(id)aKey;
- (NSDecimalNumber *)jbb_decimalNumberForKey:(id)aKey;
- (NSArray *)jbb_dictionariesForKey:(id)aKey;
- (float)jbb_floatForKey:(id)aKey;
- (int)jbb_integerForKey:(id)aKey;
- (NSNumber *)jbb_numberForKey:(id)aKey;
- (NSString *)jbb_stringForKey:(id)aKey;
@end

