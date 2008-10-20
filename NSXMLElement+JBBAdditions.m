//
//  NSXMLElement+JBBAdditions.m
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/19.
//  Copyright 2008 Jordan Breeding. All rights reserved.
//

#import "NSXMLElement+JBBAdditions.h"

#import "NSArray+JBBAdditions.h"

@implementation NSXMLElement (JBBAdditions)

#pragma mark Instance Methods

- (id)elementForName:(NSString *)elementQuery {
  return [[self elementsForName: elementQuery] firstObject];
}

- (id)elementValueForName:(NSString *)elementQuery {
  id returnedObject = [self elementForName: elementQuery];
  if (returnedObject) {
    return [returnedObject objectValue];
  }
  return [NSNull null];
}
@end

