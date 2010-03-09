//
//  JBBInvocationProxy.m
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/19.
//  Copyright 2010 Jordan Breeding. All rights reserved.
//
//  BSD License, Use at your own risk
//

// Inspired by Mike Ash: http://mikeash.com/pyblog/friday-qa-2010-02-05-error-returns-with-continuation-passing-style.html
// Code also pulled from http://github.com/erica/NSObject-Utility-Categories/blob/master/NSObject-Utilities.m

#import <dispatch/dispatch.h>
#import "JBBInvocationProxy.h"

@interface JBBInvocationProxy ()

#pragma mark Class Methods

+ (void)lock;
+ (void)unlock;

#pragma mark Instance Methods

- (void)lock;
- (void)unlock;
@end

@implementation JBBInvocationProxy
static dispatch_semaphore_t primaryLock;

@synthesize target = mTarget;

#pragma mark Class Methods

+ (void)initialize {
    primaryLock = dispatch_semaphore_create(1);
}

+ (id)proxyWithTarget:(id)aTarget {
    return [[[self alloc] initWithTarget:aTarget] autorelease];
}

+ (NSInvocation *)getInvocation {
    [self lock];
    NSInvocation *returnVal = [[[NSThread currentThread] threadDictionary] objectForKey:@"cachedInvocation"];
    [[[[NSThread currentThread] threadDictionary] objectForKey:@"cachedInvocationLock"] unlock];
    [self unlock];
    return returnVal;
}

+ (void)lock {
    dispatch_semaphore_wait(primaryLock, DISPATCH_TIME_FOREVER);
}

+ (void)unlock {
    dispatch_semaphore_signal(primaryLock);
}

#pragma mark Instance Methods

- (id)initWithTarget:(id)aTarget {
    // we are a concrete base class, we don't call [super init]

    self.target = aTarget;

    return self;
}

- (void)dealloc {
    self.target = nil;

    [super dealloc];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSParameterAssert(anInvocation);

    NSAssert(self.target, @"Cannot cache invocation, target is nil");
    NSAssert1([self.target respondsToSelector:[anInvocation selector]], @"Cannot cache invocation, target does not respond to %@", NSStringFromSelector([anInvocation selector]));

    [self lock];
    [anInvocation setTarget:self.target];
    [anInvocation retainArguments];
    [[[NSThread currentThread] threadDictionary] setObject:anInvocation forKey:@"cachedInvocation"];
    if (![[[NSThread currentThread] threadDictionary] objectForKey:@"cachedInvocationLock"]) {
        [[[NSThread currentThread] threadDictionary] setObject:[[NSLock alloc] init] forKey:@"cachedInvocationLock"];
    }
    if ([[[[NSThread currentThread] threadDictionary] objectForKey:@"cachedInvocationLock"] tryLock]) {
        [self unlock];
    } else {
        [self unlock];
        [[[[NSThread currentThread] threadDictionary] objectForKey:@"cachedInvocationLock"] lock];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [self.target methodSignatureForSelector:aSelector];
}

- (void)lock {
    dispatch_semaphore_wait(primaryLock, DISPATCH_TIME_FOREVER);
}

- (void)unlock {
    dispatch_semaphore_signal(primaryLock);
}

@end

