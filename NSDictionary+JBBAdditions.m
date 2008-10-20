//
//  NSDictionary+JBBAdditions.m
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/19.
//  Copyright 2008 Jordan Breeding. All rights reserved.
//

#import "NSDictionary+JBBAdditions.h"

#import "NSArray+JBBAdditions.h"
#import "NSNumber+JBBAdditions.h"

@implementation NSDictionary (JBBAdditions)

#pragma mark Instance Methods

- (BOOL)boolForKey:(id)keyToFind {
  id foundObject = [self objectForKey:keyToFind];
  if (foundObject && ([foundObject isKindOfClass:[NSNumber class]] || [foundObject isKindOfClass:[NSString class]])) {
    return [foundObject boolValue];
  }
  return NO;
}

- (NSDecimalNumber *)decimalNumberForKey:(id)keyToFind {
  id foundObject = [self numberForKey:keyToFind];
  if (foundObject && [foundObject isKindOfClass:[NSNumber class]]) {
    return [foundObject decimalNumberValue];
  }
  return nil;
}

- (NSArray *)dictionariesForKey:(id)keyToFind {
  id retrievedObject = [self objectForKey:keyToFind];
  if (retrievedObject && [retrievedObject isKindOfClass:[NSArray class]]) {
    return [(NSArray *)retrievedObject dictionariesWithKey:keyToFind];
  }
  return nil;
}

- (double)doubleForKey:(id)keyToFind {
  id foundObject = [self objectForKey:keyToFind];
  if (foundObject && ([foundObject isKindOfClass:[NSNumber class]] || [foundObject isKindOfClass:[NSString class]])) {
    return [foundObject doubleValue];
  }
  return (double)0;
}

- (float)floatForKey:(id)keyToFind {
  id foundObject = [self objectForKey:keyToFind];
  if (foundObject && ([foundObject isKindOfClass:[NSNumber class]] || [foundObject isKindOfClass:[NSString class]])) {
    return [foundObject floatValue];
  }
  return (float)0;
}

- (int)integerForKey:(id)keyToFind {
  id foundObject = [self objectForKey:keyToFind];
  if (foundObject && ([foundObject isKindOfClass:[NSNumber class]] || [foundObject isKindOfClass:[NSString class]])) {
    return [foundObject intValue];
  }
  return (int)0;
}

- (NSNumber *)numberForKey:(id)keyToFind {
  id foundObject = [self objectForKey:keyToFind];
  if (foundObject && [foundObject isKindOfClass:[NSNumber class]]) {
    return foundObject;
  }
  return nil;
}

- (NSString *)stringForKey:(id)keyToFind {
  id foundObject = [self objectForKey:keyToFind];
  if (foundObject && [foundObject isKindOfClass:[NSString class]]) {
    return foundObject;
  }
  return nil;
}
@end

