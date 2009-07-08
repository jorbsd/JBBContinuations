//
//  NSString+JBBAdditions.h
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/19.
//  Copyright 2008 Jordan Breeding. All rights reserved.
//

@interface NSString (JBBAdditions)

#pragma mark Instance Methods

- (BOOL)jbb_isEmpty;
- (BOOL)jbb_makeDirectoryStructureWithError:(NSError **)localError;
- (void)jbb_print;
@end

