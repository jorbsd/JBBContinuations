//
//  NSArray+JBBAdditions.m
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/18.
//  Copyright 2008 Jordan Breeding. All rights reserved.
//

#import "NSArray+JBBAdditions.h"

@implementation NSArray (JBBAdditions)

#pragma mark Instance Methods

- (NSArray *)dictionariesWithKey:(NSString *)keyName {
  NSMutableArray *newArray = [NSMutableArray array];
  for (id objectToAdd in self) {
    [newArray addObject:[[NSDictionary dictionaryWithObject:objectToAdd forKey:keyName] mutableCopy]];
  }
  return newArray;
}

- (id)firstObject {
  if ([self isEmpty]) {
    return nil;
  }
  return [self objectAtIndex:0];
}

- (BOOL)isEmpty {
  return ([self count] == 0);
}
@end

