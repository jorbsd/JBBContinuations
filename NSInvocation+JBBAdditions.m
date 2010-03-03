//
//  NSInvocation+JBBAdditions.m
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/19.
//  Copyright 2010 Jordan Breeding. All rights reserved.
//
//  BSD License, Use at your own risk
//

// Inspired by Mike Ash: http://mikeash.com/pyblog/friday-qa-2010-02-05-error-returns-with-continuation-passing-style.html
// Code also pulled from http://github.com/erica/NSObject-Utility-Categories/blob/master/NSObject-Utilities.m

#import <string.h>
#import "NSInvocation+JBBAdditions.h"

@implementation NSInvocation (JBBAdditions)

#pragma mark Instance Methods

- (void)jbb_invokeWithContinuation:(JBBContinuation)aContinuation errorHandler:(JBBErrorHandler)anErrorHandler {
    NSMethodSignature *localMs = [self methodSignature];
    const char *returnType = jbb_removeObjCTypeQualifiers([localMs methodReturnType]);
    NSString *returnTypeString = jbb_NSStringFromCString(returnType);

    // capture NSError* locally

    NSError *anError = nil;
    NSError **anErrorPointer = &anError;
    BOOL anErrorOccurred = NO;
    BOOL anErrorPresent = NO;

    if ([NSStringFromSelector([self selector]) hasSuffix:@":error:"]) {
        [self setArgument:&anErrorPointer atIndex:[localMs numberOfArguments] - 1];
        anErrorPresent = YES;
    }

    [self invoke];

    id continuationObject = nil;

    if (anErrorPresent && [returnTypeString isEqualToString:jbb_NSStringFromCString(@encode(BOOL))]) {
        BOOL returnValue = NO;
        [self getReturnValue:&returnValue];
        if (returnValue == NO) {
            anErrorOccurred = YES;
        } else {
            continuationObject = [NSValue valueWithBytes:&returnValue objCType:returnType];
        }
    } else if ([returnTypeString isEqualToString:jbb_NSStringFromCString(@encode(id))]) {
        [self getReturnValue:&continuationObject];
        if (!continuationObject) {
            anErrorOccurred = YES;
        }
    } else {
        void *returnValue = malloc([localMs methodReturnLength]);
        continuationObject = [NSValue valueWithBytes:&returnValue objCType:returnType];
        free(returnValue);
        returnValue = NULL;
    }

    if (anErrorOccurred) {
        anErrorHandler(anError);
    } else {
        aContinuation(continuationObject);
    }
}
@end

