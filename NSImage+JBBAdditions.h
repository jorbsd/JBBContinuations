//
//  NSImage+JBBAdditions.h
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/20.
//  Copyright 2008 Jordan Breeding. All rights reserved.
//

@interface NSImage (JBBAdditions)

#pragma mark Class Methods

+ (id)jbb_imageOfFile:(NSString *)fileToRead;
+ (id)jbb_imageOfFileReference:(NSString *)fileToRead;
@end

