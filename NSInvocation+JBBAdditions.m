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

- (void)jbb_invokeWithContinuation:(JBBContinuation)aContinuation {
    [self jbb_invokeWithContinuation:aContinuation errorHandler:nil];
}

- (void)jbb_invokeWithErrorHandler:(JBBErrorHandler)anErrorHandler {
    [self jbb_invokeWithContinuation:nil errorHandler:anErrorHandler];
}

- (void)jbb_invokeWithContinuation:(JBBContinuation)aContinuation errorHandler:(JBBErrorHandler)anErrorHandler {
    jbb_runInvocationWithContinuationAndErrorHandler(self, aContinuation, anErrorHandler);
}
@end

