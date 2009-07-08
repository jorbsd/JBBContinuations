//
//  NSDictionary+JBBAdditions.h
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/19.
//  Copyright 2008 Jordan Breeding. All rights reserved.
//

@interface NSDictionary (JBBAdditions)

#pragma mark Instance Methods

- (BOOL)jbb_boolForKey:(id)keyToFind;
- (NSDecimalNumber *)jbb_decimalNumberForKey:(id)keyToFind;
- (NSArray *)jbb_dictionariesForKey:(id)keyToFind;
- (float)jbb_floatForKey:(id)keyToFind;
- (int)jbb_integerForKey:(id)keyToFind;
- (NSNumber *)jbb_numberForKey:(id)keyToFind;
- (NSString *)jbb_stringForKey:(id)keyToFind;
@end

