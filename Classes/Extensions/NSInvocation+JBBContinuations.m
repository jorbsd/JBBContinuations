//
//  NSInvocation+JBBContinuations.m
//  JBBContinuations
//
//  Created by Jordan Breeding on 2008/10/19.
//  Copyright 2010 Jordan Breeding. All rights reserved.
//
//  BSD License, Use at your own risk
//

// Inspired by Mike Ash: http://mikeash.com/pyblog/friday-qa-2010-02-05-error-returns-with-continuation-passing-style.html
// Code also pulled from http://github.com/erica/NSObject-Utility-Categories/blob/master/NSObject-Utilities.m

#import "NSInvocation+JBBContinuations.h"

#import "JBBTypes.h"

@implementation NSInvocation (JBBContinuations)

#pragma mark Instance Methods

- (id)jbb_invokeWithContinuation:(JBBContinuation)aContinuation {
    return [self jbb_invokeWithContinuation:aContinuation errorHandler:nil];
}

- (id)jbb_invokeWithErrorHandler:(JBBErrorHandler)anErrorHandler {
    return [self jbb_invokeWithContinuation:nil errorHandler:anErrorHandler];
}

- (id)jbb_invokeWithContinuation:(JBBContinuation)aContinuation errorHandler:(JBBErrorHandler)anErrorHandler {
    NSMethodSignature *localMs = [self methodSignature];
    const char *returnType = jbb_removeObjCTypeQualifiers([localMs methodReturnType]);

    // capture NSError* locally

    NSError *anError = nil;
    NSError **anErrorPointer = &anError;
    BOOL anErrorOccurred = NO;
    BOOL anErrorPresent = NO;

    if ([NSStringFromSelector([self selector]) hasSuffix:@":error:"] && jbb_areObjCTypesEqual([localMs getArgumentTypeAtIndex:[localMs numberOfArguments] - 1], @encode(NSError **))) {
        [self setArgument:&anErrorPointer atIndex:[localMs numberOfArguments] - 1];
        anErrorPresent = YES;
    }

    [self invoke];

    id continuationObject = nil;

    if (anErrorPresent && jbb_areObjCTypesEqual(returnType, @encode(BOOL))) {
        BOOL returnValue = NO;
        [self getReturnValue:&returnValue];
        if (returnValue == NO) {
            anErrorOccurred = YES;
        }
        continuationObject = [NSValue valueWithBytes:&returnValue objCType:returnType];
    } else if (jbb_areObjCTypesEqual(returnType, @encode(id))) {
        [self getReturnValue:&continuationObject];
        if (!continuationObject) {
            anErrorOccurred = YES;
        }
    } else {
        void *returnValue = malloc([localMs methodReturnLength]);
        [self getReturnValue:&returnValue];
        continuationObject = [NSValue valueWithBytes:&returnValue objCType:returnType];
    }

    if (anErrorOccurred && anErrorHandler) {
        anErrorHandler(anError);
    } else if (aContinuation) {
        aContinuation(continuationObject);
    }

    return continuationObject;
}
@end

