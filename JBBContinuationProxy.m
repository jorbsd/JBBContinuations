//
//  JBBContinuationProxy
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/19.
//  Copyright 2010 Jordan Breeding. All rights reserved.
//
//  BSD License, Use at your own risk
//

// Inspired by Mike Ash: http://mikeash.com/pyblog/friday-qa-2010-02-05-error-returns-with-continuation-passing-style.html
// Code also pulled from http://github.com/erica/NSObject-Utility-Categories/blob/master/NSObject-Utilities.m

#import "JBBContinuationProxy.h"

@implementation JBBContinuationProxy
@synthesize target = mTarget;
@synthesize continuation = mContinuation;
@synthesize errorHandler = mErrorHandler;

#pragma mark Class Methods

+ (id)proxyWithTarget:(id)aTarget {
    return [[[self alloc] initWithTarget:aTarget] autorelease];
}

+ (id)proxyWithTarget:(id)aTarget continuation:(JBBContinuation)aContinuation {
    return [[[self alloc] initWithTarget:aTarget continuation:aContinuation] autorelease];
}

+ (id)proxyWithTarget:(id)aTarget errorHandler:(JBBErrorHandler)anErrorHandler {
    return [[[self alloc] initWithTarget:aTarget errorHandler:anErrorHandler] autorelease];
}

+ (id)proxyWithTarget:(id)aTarget continuation:(JBBContinuation)aContinuation errorHandler:(JBBErrorHandler)anErrorHandler {
    return [[[self alloc] initWithTarget:aTarget continuation:aContinuation errorHandler:anErrorHandler] autorelease];
}

#pragma mark Instance Methods

- (id)initWithTarget:(id)aTarget {
    return [self initWithTarget:aTarget continuation:nil errorHandler:nil];
}

- (id)initWithTarget:(id)aTarget continuation:(JBBContinuation)aContinuation {
    return [self initWithTarget:aTarget continuation:aContinuation errorHandler:nil];
}

- (id)initWithTarget:(id)aTarget errorHandler:(JBBErrorHandler)anErrorHandler {
    return [self initWithTarget:aTarget continuation:nil errorHandler:anErrorHandler];
}

- (id)initWithTarget:(id)aTarget continuation:(JBBContinuation)aContinuation errorHandler:(JBBErrorHandler)anErrorHandler {
    // we are a concrete base class based on NSProxy

    self.target = aTarget;
    self.continuation = aContinuation;
    self.errorHandler = anErrorHandler;

    return self;
}

- (void)dealloc {
    self.target = nil;
    self.continuation = nil;
    self.errorHandler = nil;

    [super dealloc];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSParameterAssert(anInvocation);

    NSAssert(self.target, @"Cannot forward invocation, target is nil");
    NSAssert1([self.target respondsToSelector:[anInvocation selector]], @"Cannot forward invocation, target does not respond to %@", NSStringFromSelector([anInvocation selector]));

    anInvocation.target = self.target;
    jbb_runInvocationWithContinuationAndErrorHandler(anInvocation, self.continuation, self.errorHandler);
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [self.target methodSignatureForSelector:aSelector];
}

@end

