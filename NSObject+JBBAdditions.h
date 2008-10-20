//
//  NSObject+JBBAdditions.h
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/18.
//  Copyright 2008 Jordan Breeding. All rights reserved.
//

@interface NSObject (JBBAdditions)

#pragma mark Class Methods

+ (BOOL)loadSelector:(SEL)oldSelector asSelector:(SEL)newSelector onlyWhenMissing:(BOOL)loadWhenMissing;
+ (BOOL)loadSelector:(SEL)oldSelector asSelector:(SEL)newSelector;
+ (BOOL)swapSelector:(SEL)oldSelector withSelector:(SEL)newSelector;
@end

