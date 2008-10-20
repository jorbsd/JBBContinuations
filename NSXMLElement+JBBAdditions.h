//
//  NSXMLElement+JBBAdditions.h
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/19.
//  Copyright 2008 Jordan Breeding. All rights reserved.
//

@interface NSXMLElement (JBBAdditions)

#pragma mark Instance Methods

- (id)elementForName:(NSString *)elementQuery;
- (id)elementValueForName:(NSString *)elementQuery;
@end

