//
//  NSObject+JBBAdditions.h
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/19.
//  Copyright 2008 Jordan Breeding. All rights reserved.
//

#import <Foundation/Foundation.h>

void jbb_puts(id);

@interface NSObject (JBBAdditions)

#pragma mark Instance Methods

- (void)jbb_puts;
@end

