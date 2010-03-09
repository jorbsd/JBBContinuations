//
//  NSObject+JBBAdditions.m
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/19.
//  Copyright 2010 Jordan Breeding. All rights reserved.
//
//  BSD License, Use at your own risk
//

// Inspired by Mike Ash: http://mikeash.com/pyblog/friday-qa-2010-02-05-error-returns-with-continuation-passing-style.html
// Code also pulled from http://github.com/erica/NSObject-Utility-Categories/blob/master/NSObject-Utilities.m

#import "JBBTypes.h"
#import "JBBContinuationProxy.h"
#import "JBBInvocationProxy.h"
#import "NSObject+JBBAdditions.h"
#import "NSString+JBBAdditions.h"

void jbb_puts(id anObject);

@implementation NSObject (JBBAdditions)

#pragma mark Class Methods

+ (id)jbb_continuationProxy {
    return [JBBContinuationProxy proxyWithTarget:self];
}

+ (id)jbb_continuationProxyWithContinuation:(JBBContinuation)aContinuation {
    return [JBBContinuationProxy proxyWithTarget:self continuation:aContinuation];
}

+ (id)jbb_continuationProxyWithErrorHandler:(JBBErrorHandler)anErrorHandler {
    return [JBBContinuationProxy proxyWithTarget:self errorHandler:anErrorHandler];
}

+ (id)jbb_continuationProxyWithContinuation:(JBBContinuation)aContinuation errorHandler:(JBBErrorHandler)anErrorHandler {
    return [JBBContinuationProxy proxyWithTarget:self continuation:aContinuation errorHandler:anErrorHandler];
}

+ (id)jbb_invocationProxy {
    return [JBBInvocationProxy proxyWithTarget:self];
}

#pragma mark Instance Methods

- (id)jbb_continuationProxy {
    return [JBBContinuationProxy proxyWithTarget:self];
}

- (id)jbb_continuationProxyWithContinuation:(JBBContinuation)aContinuation {
    return [JBBContinuationProxy proxyWithTarget:self continuation:aContinuation];
}

- (id)jbb_continuationProxyWithErrorHandler:(JBBErrorHandler)anErrorHandler {
    return [JBBContinuationProxy proxyWithTarget:self errorHandler:anErrorHandler];
}

- (id)jbb_continuationProxyWithContinuation:(JBBContinuation)aContinuation errorHandler:(JBBErrorHandler)anErrorHandler {
    return [JBBContinuationProxy proxyWithTarget:self continuation:aContinuation errorHandler:anErrorHandler];
}

- (id)jbb_invocationProxy {
    return [JBBInvocationProxy proxyWithTarget:self];
}

- (void)jbb_puts {
    if ([[self description] hasSuffix:@"\n"]) {
        [[self description] jbb_print];
    } else {
        [[[self description] stringByAppendingString:@"\n"] jbb_print];
    }
}
@end

void jbb_puts(id anObject) {
    [anObject jbb_puts];
}

