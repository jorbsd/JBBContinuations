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

#import <Foundation/Foundation.h>
#import "JBBTypes.h"
#import "JBBObjectProxy.h"

#if !defined(WRAP_MSG_SEND)
#define WRAP_MSG_SEND(anObject, ...) ([[anObject jbb_proxy] __VA_ARGS__], [JBBInvocationProxy getStoredInvocation])
#endif

void jbb_puts(id anObject);

@interface NSObject (JBBAdditions)

#pragma mark Class Methods

+ (id)jbb_proxy;
+ (id)jbb_proxyWithContinuation:(JBBContinuation)aContinuation;
+ (id)jbb_proxyWithErrorHandler:(JBBErrorHandler)anErrorHandler;
+ (id)jbb_proxyWithContinuation:(JBBContinuation)aContinuation errorHandler:(JBBErrorHandler)anErrorHandler;

#pragma mark Instance Methods

- (id)jbb_proxy;
- (id)jbb_proxyWithContinuation:(JBBContinuation)aContinuation;
- (id)jbb_proxyWithErrorHandler:(JBBErrorHandler)anErrorHandler;
- (id)jbb_proxyWithContinuation:(JBBContinuation)aContinuation errorHandler:(JBBErrorHandler)anErrorHandler;
- (void)jbb_puts;
@end

