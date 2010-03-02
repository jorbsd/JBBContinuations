//
//  NSInvocation+JBBAdditions.m
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/19.
//  Copyright 2010 Jordan Breeding. All rights reserved.
//
//  BSD License, Use at your own risk
//

#import <string.h>

#import "NSInvocation+JBBAdditions.h"

// Inspired by Mike Ash: http://mikeash.com/pyblog/friday-qa-2010-02-05-error-returns-with-continuation-passing-style.html
// Code also pulled from http://github.com/erica/NSObject-Utility-Categories/blob/master/NSObject-Utilities.m

@implementation NSInvocation (JBBAdditions)

#pragma mark Instance Methods

- (void)jbb_invokeWithContinuation:(Continuation)continuation andErrorHandler:(ErrorHandler)errorHandler {
    NSMethodSignature *localMs = [self methodSignature];
    const char *returnType = jbb_removeObjCTypeQualifiers([localMs methodReturnType]);
    NSString *returnTypeString = jbb_NSStringFromCString(returnType);

    // capture the possible NSError* locally regardless of the original value
    NSError *localError = nil;
    NSError **localErrorPointer = &localError;
    BOOL errorOccurred = NO;
    if ([NSStringFromSelector([self selector]) hasSuffix:@":error:"]) {
        [self setArgument:&localErrorPointer atIndex:[localMs numberOfArguments] - 1];
    }

    [self invoke];

    // we wrap anything other than objects in an NSValue with ObjC type encoding
    // we do error checking for id == nil and (BOOL)char == NO

    id continuationObject = nil;

    if ([returnTypeString isEqualToString:jbb_NSStringFromCString(@encode(id))]) {
        [self getReturnValue:&continuationObject];
        if (!continuationObject) {
            errorOccurred = YES;
        }
    } else if ([returnTypeString isEqualToString:jbb_NSStringFromCString(@encode(char))]) {
        // most likely a BOOL in reality

        char returnValue = NO;
        [self getReturnValue:&returnValue];
        if ((BOOL)returnValue == NO) {
            errorOccurred = YES;
        } else {
            continuationObject = [NSValue valueWithBytes:&returnValue objCType:returnType];
        }
    } else {
        void *returnValue = malloc([localMs methodReturnLength]);
        continuationObject = [NSValue valueWithBytes:&returnValue objCType:returnType];
    }

    if (errorOccurred) {
        errorHandler(localError);
    } else {
        continuation(continuationObject);
    }
}
@end

