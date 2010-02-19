//
//  NSString+JBBAdditions.m
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/19.
//  Copyright 2008 Jordan Breeding. All rights reserved.
//
//  BSD License, Use at your own risk
//

#import "NSString+JBBAdditions.h"

@implementation NSString (JBBAdditions)

#pragma mark Instance Methods

- (BOOL)jbb_isEmpty {
    return [self length] == 0;
}

- (BOOL)jbb_makeDirectoryStructureWithError:(NSError **)localError {
    NSString *localString = [self stringByDeletingLastPathComponent];

    if (![[NSFileManager defaultManager] createDirectoryAtPath:localString withIntermediateDirectories:YES attributes:nil error:localError]) {
        return NO;
    }

    return YES;
}

- (void)jbb_print {
    printf("%s", [self UTF8String]);
}

- (OSType)jbb_OSType {
    return UTGetOSTypeFromString((CFStringRef)self);
}
@end

