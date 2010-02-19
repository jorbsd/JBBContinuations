//
//  NSData+JBBAdditions.h
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/18.
//  Copyright 2008 Jordan Breeding. All rights reserved.
//
//  BSD License, Use at your own risk
//

#import <Foundation/Foundation.h>

@interface NSData (JBBAdditions)

#pragma mark Instance Methods

- (NSUInteger)jbb_murmurhash;
@end

