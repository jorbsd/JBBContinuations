//
//  NSObject+JBBAdditions.h
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/19.
//  Copyright 2010 Jordan Breeding. All rights reserved.
//
//  BSD License, Use at your own risk
//

// Inspired by Mike Ash: http://mikeash.com/pyblog/friday-qa-2010-02-05-error-returns-with-continuation-passing-style.html
// Code also pulled from http://github.com/erica/NSObject-Utility-Categories/blob/master/NSObject-Utilities.m

// To keep the compiler from complaining we need to return id
// instead of JBBContinuationProxy*

#import <Foundation/Foundation.h>
#import "JBBTypes.h"
#import "JBBInvocationProxy.h"
#import "NSInvocation+JBBAdditions.h"

// This seems like a good place to define the macros

#if !defined(WRAP_OBJECT)
#define WRAP_MSG_SEND(anObject, ...) ([[anObject jbb_invocationProxy] __VA_ARGS__], [JBBInvocationProxy getInvocation])
#endif

void jbb_puts(id anObject);

@interface NSObject (JBBAdditions)

#pragma mark Class Methods

+ (id)jbb_continuationProxy;
+ (id)jbb_continuationProxyWithContinuation:(JBBContinuation)aContinuation;
+ (id)jbb_continuationProxyWithErrorHandler:(JBBErrorHandler)anErrorHandler;
+ (id)jbb_continuationProxyWithContinuation:(JBBContinuation)aContinuation errorHandler:(JBBErrorHandler)anErrorHandler;
+ (id)jbb_invocationProxy;

#pragma mark Instance Methods

- (id)jbb_continuationProxy;
- (id)jbb_continuationProxyWithContinuation:(JBBContinuation)aContinuation;
- (id)jbb_continuationProxyWithErrorHandler:(JBBErrorHandler)anErrorHandler;
- (id)jbb_continuationProxyWithContinuation:(JBBContinuation)aContinuation errorHandler:(JBBErrorHandler)anErrorHandler;
- (id)jbb_invocationProxy;
- (void)jbb_puts;
@end

