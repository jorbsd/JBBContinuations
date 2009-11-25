//
//  NSString+JBBAdditions.h
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/19.
//  Copyright 2008 Jordan Breeding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JBBAdditions)

#pragma mark Instance Methods

- (BOOL)jbb_isEmpty;
- (BOOL)jbb_makeDirectoryStructureWithError:(NSError **)localError;
- (void)jbb_print;
- (void)jbb_puts;
@end

