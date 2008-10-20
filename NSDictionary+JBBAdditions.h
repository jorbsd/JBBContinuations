//
//  NSDictionary+JBBAdditions.h
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/19.
//  Copyright 2008 Jordan Breeding. All rights reserved.
//

@interface NSDictionary (JBBAdditions)

#pragma mark Instance Methods

- (BOOL)boolForKey:(id)keyToFind;
- (NSDecimalNumber *)decimalNumberForKey:(id)keyToFind;
- (NSArray *)dictionariesForKey:(id)keyToFind;
- (float)floatForKey:(id)keyToFind;
- (int)integerForKey:(id)keyToFind;
- (NSNumber *)numberForKey:(id)keyToFind;
- (NSString *)stringForKey:(id)keyToFind;
@end

