//
//  NSArray+JBBAdditions.h
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/18.
//  Copyright 2008 Jordan Breeding. All rights reserved.
//

@interface NSArray (JBBAdditions)

#pragma mark Instance Methods

- (NSArray *)dictionariesWithKey:(NSString *)keyName;
- (id)firstObject;
- (BOOL)isEmpty;
@end

