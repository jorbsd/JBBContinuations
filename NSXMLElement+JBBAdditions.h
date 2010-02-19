//
//  NSXMLElement+JBBAdditions.h
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/19.
//  Copyright 2008 Jordan Breeding. All rights reserved.
//
//  BSD License, Use at your own risk
//

#import <Foundation/Foundation.h>

@interface NSXMLElement (JBBAdditions)

#pragma mark Instance Methods

- (id)jbb_elementForName:(NSString *)elementQuery;
- (id)jbb_elementValueForName:(NSString *)elementQuery;
@end

