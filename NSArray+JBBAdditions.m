//
//  NSArray+JBBAdditions.m
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/18.
//  Copyright 2008 Jordan Breeding. All rights reserved.
//
//  BSD License, Use at your own risk
//

#import "NSArray+JBBAdditions.h"

@implementation NSArray (JBBAdditions)

#pragma mark Instance Methods

- (NSArray *)jbb_dictionariesWithKey:(NSString *)keyName {
    NSMutableArray *newArray = [NSMutableArray array];
    for (id objectToAdd in self) {
        [newArray addObject:[[[NSDictionary dictionaryWithObject:objectToAdd forKey:keyName] mutableCopy] autorelease]];
    }
    return newArray;
}

- (id)jbb_firstObject {
    if ([self jbb_isEmpty]) {
        return nil;
    }
    return [self objectAtIndex:0];
}

- (BOOL)jbb_isEmpty {
    return ([self count] == 0);
}
@end

