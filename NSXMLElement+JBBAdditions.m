//
//  NSXMLElement+JBBAdditions.m
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/19.
//  Copyright 2008 Jordan Breeding. All rights reserved.
//
//  BSD License, Use at your own risk
//

#import "NSXMLElement+JBBAdditions.h"

#import "NSArray+JBBAdditions.h"

@implementation NSXMLElement (JBBAdditions)

#pragma mark Instance Methods

- (id)jbb_elementForName:(NSString *)elementQuery {
    return [[self elementsForName:elementQuery] jbb_firstObject];
}

- (id)jbb_elementValueForName:(NSString *)elementQuery {
    id returnedObject = [self jbb_elementForName:elementQuery];
    if (returnedObject) {
        return [returnedObject objectValue];
    }
    return [NSNull null];
}
@end

