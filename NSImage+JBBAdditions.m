//
//  NSImage+JBBAdditions.m
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/20.
//  Copyright 2008 Jordan Breeding. All rights reserved.
//

#import "NSImage+JBBAdditions.h"

@implementation NSImage (JBBAdditions)

#pragma mark Class Methods

+ (id)jbb_imageOfFile:(NSString *)fileToRead {
  return [[NSImage alloc] initWithContentsOfFile:fileToRead];
}

+ (id)jbb_imageOfFileReference:(NSString *)fileToRead {
  return [[NSImage alloc] initByReferencingFile:fileToRead];
}
@end

