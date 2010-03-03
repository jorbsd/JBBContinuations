//
//  NSArray+JBBAdditions.h
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/18.
//  Copyright 2008 Jordan Breeding. All rights reserved.
//
//  BSD License, Use at your own risk
//

#import <Foundation/Foundation.h>

@interface NSArray (JBBAdditions)

#pragma mark Instance Methods

- (NSArray *)jbb_dictionariesWithKey:(NSString *)aKey;
- (id)jbb_firstObject;
- (BOOL)jbb_isEmpty;
@end

