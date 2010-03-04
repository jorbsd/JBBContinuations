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

+ (id)proxy {
    return [[[self alloc] init] autorelease];
}

+ (id)proxyWithTarget:(id)aTarget {
    return [[[self alloc] initWithTarget:aTarget] autorelease];
}

+ (id)proxyWithTarget:(id)aTarget continuation:(JBBContinuation)aContinuation {
    return [[[self alloc] initWithTarget:aTarget continuation:aContinuation] autorelease];
}

+ (id)proxyWithTarget:(id)aTarget errorHandler:(JBBErrorHandler)anErrorHandler {
    return [[[self alloc] initWithTarget:aTarget errorHandler:anErrorHandler] autorelease];
}

+ (id)proxyWithContinuation:(JBBContinuation)aContinuation {
    return [[[self alloc] initWithContinuation:aContinuation] autorelease];
}

+ (id)proxyWithContinuation:(JBBContinuation)aContinuation errorHandler:(JBBErrorHandler)anErrorHandler {
    return [[[self alloc] initWithContinuation:aContinuation errorHandler:anErrorHandler] autorelease];
}

+ (id)proxyWithErrorHandler:(JBBErrorHandler)anErrorHandler {
    return [[[self alloc] initWithErrorHandler:anErrorHandler] autorelease];
}

+ (id)proxyWithTarget:(id)aTarget continuation:(JBBContinuation)aContinuation errorHandler:(JBBErrorHandler)anErrorHandler {
    return [[[self alloc] initWithTarget:aTarget continuation:aContinuation errorHandler:anErrorHandler] autorelease];
}

#pragma mark Instance Methods

- (id)init {
    return [self initWithTarget:nil continuation:nil errorHandler:nil];
}

- (id)initWithTarget:(id)aTarget {
    return [self initWithTarget:aTarget continuation:nil errorHandler:nil];
}

- (id)initWithTarget:(id)aTarget continuation:(JBBContinuation)aContinuation {
    return [self initWithTarget:aTarget continuation:aContinuation errorHandler:nil];
}

- (id)initWithTarget:(id)aTarget errorHandler:(JBBErrorHandler)anErrorHandler {
    return [self initWithTarget:aTarget continuation:nil errorHandler:anErrorHandler];
}

- (id)initWithContinuation:(JBBContinuation)aContinuation {
    return [self initWithTarget:nil continuation:aContinuation errorHandler:nil];
}

- (id)initWithContinuation:(JBBContinuation)aContinuation errorHandler:(JBBErrorHandler)anErrorHandler {
    return [self initWithTarget:nil continuation:aContinuation errorHandler:anErrorHandler];
}

- (id)initWithErrorHandler:(JBBErrorHandler)anErrorHandler {
    return [self initWithTarget:nil continuation:nil errorHandler:anErrorHandler];
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

    NSMethodSignature *ms = [anInvocation methodSignature];
    const char *returnType = jbb_removeObjCTypeQualifiers([ms methodReturnType]);
    NSString *returnTypeString = jbb_NSStringFromCString(returnType);

    // capture NSError* locally

    NSError *anError = nil;
    NSError **anErrorPointer = &anError;
    BOOL anErrorOccurred = NO;
    BOOL anErrorPresent = NO;

    if ([NSStringFromSelector([anInvocation selector]) hasSuffix:@":error:"]) {
        [anInvocation setArgument:&anErrorPointer atIndex:[ms numberOfArguments] - 1];
        anErrorPresent = YES;
    }

    [anInvocation invokeWithTarget:self.target];

    id continuationObject = nil;

    if (anErrorPresent && [returnTypeString isEqualToString:jbb_NSStringFromCString(@encode(BOOL))]) {
        BOOL returnValue = NO;
        [anInvocation getReturnValue:&returnValue];
        if (returnValue == NO) {
            anErrorOccurred = YES;
        } else {
            continuationObject = [NSValue valueWithBytes:&returnValue objCType:returnType];
        }
    } else if ([returnTypeString isEqualToString:jbb_NSStringFromCString(@encode(id))]) {
        [anInvocation getReturnValue:&continuationObject];
        if (!continuationObject) {
            anErrorOccurred = YES;
        }
    } else {
        void *returnValue = malloc([ms methodReturnLength]);
        continuationObject = [NSValue valueWithBytes:&returnValue objCType:returnType];
        free(returnValue);
        returnValue = NULL;
    }

    JBBContinuation aContinuation = self.continuation;
    JBBErrorHandler anErrorHandler = self.errorHandler;

    if (anErrorOccurred && anErrorHandler) {
        anErrorHandler(anError);
    } else if (aContinuation) {
        aContinuation(continuationObject);
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSParameterAssert(aSelector);

    if (!self.target) {
        return nil;
    }

    return [self.target methodSignatureForSelector:aSelector];
}

@end

