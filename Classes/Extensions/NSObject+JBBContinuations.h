//
//  NSObject+JBBContinuations.h
//  JBBContinuations
//
//  Created by Jordan Breeding on 2008/10/19.
//  Copyright 2010 Jordan Breeding. All rights reserved.
//
//  BSD License, Use at your own risk
//

// Inspired by Mike Ash: http://mikeash.com/pyblog/friday-qa-2010-02-05-error-returns-with-continuation-passing-style.html
// Code also pulled from http://github.com/erica/NSObject-Utility-Categories/blob/master/NSObject-Utilities.m

#import <Foundation/Foundation.h>
#import "JBBObjectProxy.h"

#import "JBBTypes.h"

#if !defined(WRAP_MSG_SEND)
#define WRAP_MSG_SEND(anObject, ...) ([[anObject jbb_proxyWithLocking:YES] __VA_ARGS__], [JBBObjectProxy getStoredInvocation])
#endif

@interface NSObject (JBBContinuations)

#pragma mark Class Methods

+ (id)jbb_proxy;
+ (id)jbb_proxyWithLocking:(BOOL)shouldUseLocking;
+ (id)jbb_proxyWithContinuation:(JBBContinuation)aContinuation;
+ (id)jbb_proxyWithErrorHandler:(JBBErrorHandler)anErrorHandler;
+ (id)jbb_proxyWithContinuation:(JBBContinuation)aContinuation errorHandler:(JBBErrorHandler)anErrorHandler;

#pragma mark Instance Methods

- (id)jbb_proxy;
- (id)jbb_proxyWithLocking:(BOOL)shouldUseLocking;
- (id)jbb_proxyWithContinuation:(JBBContinuation)aContinuation;
- (id)jbb_proxyWithErrorHandler:(JBBErrorHandler)anErrorHandler;
- (id)jbb_proxyWithContinuation:(JBBContinuation)aContinuation errorHandler:(JBBErrorHandler)anErrorHandler;
@end

