//
//  NSImage+JBBAdditions.m
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/20.
//  Copyright 2008 Jordan Breeding. All rights reserved.
//
//  BSD License, Use at your own risk
//

#import "NSImage+JBBAdditions.h"

@implementation NSImage (JBBAdditions)

#pragma mark Class Methods

+ (id)jbb_imageOfFile:(NSString *)aFile {
    return [[[NSImage alloc] initWithContentsOfFile:aFile] autorelease];
}

+ (id)jbb_imageOfFileReference:(NSString *)aFile {
    return [[[NSImage alloc] initByReferencingFile:aFile] autorelease];
}
@end

