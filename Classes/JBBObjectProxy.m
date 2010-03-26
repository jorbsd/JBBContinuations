//
//  JBBObjectProxy.m
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

#import "JBBObjectProxy.h"
#import "JBB_C_Functions.h"
#import "JBBTypes.h"
#import "NSInvocation+JBBAdditions.h"

BOOL jbb_continuationOrErrorHandlerPresentInSEL(SEL aSelector);
BOOL jbb_continuationPresentInSEL(SEL aSelector);
BOOL jbb_errorHandlerPresentInSEL(SEL aSelector);

@interface JBBObjectProxyState : NSObject {
    SEL mBaseSelector;
    SEL mFullSelector;
    NSMethodSignature *mBaseMethodSignature;
    NSMethodSignature *mFullMethodSignature;
    BOOL mContinuationPresent;
    BOOL mErrorHandlerPresent;
}

@property (assign) SEL baseSelector;
@property (assign) SEL fullSelector;
@property (retain) NSMethodSignature *baseMethodSignature;
@property (retain) NSMethodSignature *fullMethodSignature;
@property (assign) BOOL continuationPresent;
@property (assign) BOOL errorHandlerPresent;
@end

@interface NSString (JBBObjectProxy)
- (BOOL)jbb_continuationOrErrorHandlerPresent;
- (BOOL)jbb_continuationPresent;
- (BOOL)jbb_errorHandlerPresent;
- (SEL)jbb_baseSelector;
@end

@interface JBBObjectProxy ()

#pragma mark Class Methods

+ (void)lock;
+ (void)unlock;

#pragma mark Instance Methods

- (BOOL)continuationOrErrorHandlerPresent;
- (BOOL)continuationAndErrorHandlerPresent;
- (BOOL)continuationPresent;
- (BOOL)errorHandlerPresent;
- (void)lock;
- (void)unlock;

@property (retain) id target;
@property (retain) id continuation;
@property (retain) id errorHandler;
@end

@implementation JBBObjectProxy
static dispatch_once_t initPredicate;
static dispatch_semaphore_t primaryLock;

@synthesize target = mTarget;
@synthesize continuation = mContinuation;
@synthesize errorHandler = mErrorHandler;

#pragma mark Class Methods

+ (void)initialize {
    dispatch_once(&initPredicate, ^{
        primaryLock = dispatch_semaphore_create(1);
    });
}

+ (NSInvocation *)getStoredInvocation {
    [self lock];
    NSInvocation *returnVal = [[[NSThread currentThread] threadDictionary] objectForKey:@"cachedInvocation"];
    [[[[NSThread currentThread] threadDictionary] objectForKey:@"cachedInvocationLock"] unlock];
    [self unlock];

    return returnVal;
}

+ (id)invokeWithContinuation:(JBBContinuation)aContinuation {
    return [[self getStoredInvocation] jbb_invokeWithContinuation:aContinuation];
}

+ (id)invokeWithErrorHandler:(JBBErrorHandler)anErrorHandler {
    return [[self getStoredInvocation] jbb_invokeWithErrorHandler:anErrorHandler];
}

+ (id)invokeWithContinuation:(JBBContinuation)aContinuation errorHandler:(JBBErrorHandler)anErrorHandler {
    return [[self getStoredInvocation] jbb_invokeWithContinuation:aContinuation errorHandler:anErrorHandler];
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

+ (id)proxyWithTarget:(id)aTarget continuation:(JBBContinuation)aContinuation errorHandler:(JBBErrorHandler)anErrorHandler {
    return [[[self alloc] initWithTarget:aTarget continuation:aContinuation errorHandler:anErrorHandler] autorelease];
}

+ (void)lock {
    dispatch_semaphore_wait(primaryLock, DISPATCH_TIME_FOREVER);
}

+ (void)unlock {
    dispatch_semaphore_signal(primaryLock);
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
    // we are a concrete base class, we don't call [super init]

    if (!self) {
        return nil;
    }

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

- (BOOL)continuationOrErrorHandlerPresent {
    return [self continuationPresent] || [self errorHandlerPresent];
}

- (BOOL)continuationAndErrorHandlerPresent {
    return [self continuationPresent] && [self errorHandlerPresent];
}

- (BOOL)continuationPresent {
    return self.continuation != nil;
}

- (BOOL)errorHandlerPresent {
    return self.errorHandler != nil;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    JBBObjectProxyState *proxyState = [[[NSThread currentThread] threadDictionary] objectForKey:@"proxyState"];
    NSInvocation *finalInvocation = nil;

    NSParameterAssert([anInvocation selector] == proxyState.fullSelector);
    NSParameterAssert([anInvocation methodSignature] == proxyState.fullMethodSignature);

    JBBContinuation localContinuation = self.continuation;
    JBBErrorHandler localErrorHandler = self.errorHandler;

    if (!proxyState.continuationPresent && !proxyState.errorHandlerPresent) {
        finalInvocation = anInvocation;

        if (![self continuationOrErrorHandlerPresent]) {
            [self lock];

            [finalInvocation setTarget:self.target];
            [finalInvocation retainArguments];

            // FIXME: this results in the invocation being run once right now
            //        and once when it is grabbed from the cache, this could
            //        have negative side effects

            // let the caller grab the return value with no continuations if they want to

            [finalInvocation invoke];

            [[[NSThread currentThread] threadDictionary] setObject:finalInvocation forKey:@"cachedInvocation"];
            if (![[[NSThread currentThread] threadDictionary] objectForKey:@"cachedInvocationLock"]) {
                [[[NSThread currentThread] threadDictionary] setObject:[[[NSLock alloc] init] autorelease] forKey:@"cachedInvocationLock"];
            }
            if ([[[[NSThread currentThread] threadDictionary] objectForKey:@"cachedInvocationLock"] tryLock]) {
                [self unlock];
            } else {
                [self unlock];
                [[[[NSThread currentThread] threadDictionary] objectForKey:@"cachedInvocationLock"] lock];
            }

            return;
        }
    } else {
        // build the real invocation

        finalInvocation = [NSInvocation invocationWithMethodSignature:proxyState.baseMethodSignature];
        [finalInvocation setSelector:proxyState.baseSelector];

        NSUInteger baseNumberOfArgs = [proxyState.baseMethodSignature numberOfArguments];
        NSUInteger baseMaxIndex = baseNumberOfArgs - 1;

        for (unsigned int index = 2; index < baseNumberOfArgs; index++) {
            const char *typeForArg = [proxyState.baseMethodSignature getArgumentTypeAtIndex:index];

            // handle common types

            if (jbb_areObjCTypesEqual(typeForArg, @encode(char))) {
                char arg;
                [anInvocation getArgument:&arg atIndex:index];
                [finalInvocation setArgument:&arg atIndex:index];
            } else if (jbb_areObjCTypesEqual(typeForArg, @encode(unsigned char))) {
                unsigned char arg;
                [anInvocation getArgument:&arg atIndex:index];
                [finalInvocation setArgument:&arg atIndex:index];
            } else if (jbb_areObjCTypesEqual(typeForArg, @encode(short))) {
                short arg;
                [anInvocation getArgument:&arg atIndex:index];
                [finalInvocation setArgument:&arg atIndex:index];
            } else if (jbb_areObjCTypesEqual(typeForArg, @encode(unsigned short))) {
                unsigned short arg;
                [anInvocation getArgument:&arg atIndex:index];
                [finalInvocation setArgument:&arg atIndex:index];
            } else if (jbb_areObjCTypesEqual(typeForArg, @encode(int))) {
                int arg;
                [anInvocation getArgument:&arg atIndex:index];
                [finalInvocation setArgument:&arg atIndex:index];
            } else if (jbb_areObjCTypesEqual(typeForArg, @encode(unsigned int))) {
                unsigned int arg;
                [anInvocation getArgument:&arg atIndex:index];
                [finalInvocation setArgument:&arg atIndex:index];
            } else if (jbb_areObjCTypesEqual(typeForArg, @encode(long))) {
                long arg;
                [anInvocation getArgument:&arg atIndex:index];
                [finalInvocation setArgument:&arg atIndex:index];
            } else if (jbb_areObjCTypesEqual(typeForArg, @encode(unsigned long))) {
                unsigned long arg;
                [anInvocation getArgument:&arg atIndex:index];
                [finalInvocation setArgument:&arg atIndex:index];
            } else if (jbb_areObjCTypesEqual(typeForArg, @encode(long long))) {
                long long arg;
                [anInvocation getArgument:&arg atIndex:index];
                [finalInvocation setArgument:&arg atIndex:index];
            } else if (jbb_areObjCTypesEqual(typeForArg, @encode(unsigned long long))) {
                unsigned long long arg;
                [anInvocation getArgument:&arg atIndex:index];
                [finalInvocation setArgument:&arg atIndex:index];
            } else if (jbb_areObjCTypesEqual(typeForArg, @encode(float))) {
                float arg;
                [anInvocation getArgument:&arg atIndex:index];
                [finalInvocation setArgument:&arg atIndex:index];
            } else if (jbb_areObjCTypesEqual(typeForArg, @encode(double))) {
                double arg;
                [anInvocation getArgument:&arg atIndex:index];
                [finalInvocation setArgument:&arg atIndex:index];
            } else if (jbb_areObjCTypesEqual(typeForArg, @encode(id))) {
                id arg;
                [anInvocation getArgument:&arg atIndex:index];
                [finalInvocation setArgument:&arg atIndex:index];
            } else if (jbb_areObjCTypesEqual(typeForArg, @encode(SEL))) {
                SEL arg;
                [anInvocation getArgument:&arg atIndex:index];
                [finalInvocation setArgument:&arg atIndex:index];
            } else if (jbb_areObjCTypesEqual(typeForArg, @encode(Class))) {
                Class arg;
                [anInvocation getArgument:&arg atIndex:index];
                [finalInvocation setArgument:&arg atIndex:index];
            } else if (jbb_areObjCTypesEqual(typeForArg, @encode(char *))) {
                char *arg;
                [anInvocation getArgument:&arg atIndex:index];
                [finalInvocation setArgument:&arg atIndex:index];
            } else if (jbb_areObjCTypesEqual(typeForArg, @encode(NSPoint))) {
                NSPoint arg;
                [anInvocation getArgument:&arg atIndex:index];
                [finalInvocation setArgument:&arg atIndex:index];
            } else if (jbb_areObjCTypesEqual(typeForArg, @encode(NSSize))) {
                NSSize arg;
                [anInvocation getArgument:&arg atIndex:index];
                [finalInvocation setArgument:&arg atIndex:index];
            } else if (jbb_areObjCTypesEqual(typeForArg, @encode(NSRect))) {
                NSRect arg;
                [anInvocation getArgument:&arg atIndex:index];
                [finalInvocation setArgument:&arg atIndex:index];
            } else if (jbb_areObjCTypesEqual(typeForArg, @encode(NSRange))) {
                NSRange arg;
                [anInvocation getArgument:&arg atIndex:index];
                [finalInvocation setArgument:&arg atIndex:index];
            } else if (jbb_areObjCTypesEqual(typeForArg, @encode(CGPoint))) {
                CGPoint arg;
                [anInvocation getArgument:&arg atIndex:index];
                [finalInvocation setArgument:&arg atIndex:index];
            } else if (jbb_areObjCTypesEqual(typeForArg, @encode(CGSize))) {
                CGSize arg;
                [anInvocation getArgument:&arg atIndex:index];
                [finalInvocation setArgument:&arg atIndex:index];
            } else if (jbb_areObjCTypesEqual(typeForArg, @encode(CGRect))) {
                CGRect arg;
                [anInvocation getArgument:&arg atIndex:index];
                [finalInvocation setArgument:&arg atIndex:index];
            } else if (jbb_ObjCTypeStartsWith(typeForArg, "^")) {
                // generic pointer, including function pointers

                void *arg;
                [anInvocation getArgument:&arg atIndex:index];
                [finalInvocation setArgument:&arg atIndex:index];
            } else if (jbb_ObjCTypeStartsWith(typeForArg, "@")) {
                // most likely a block, handle like a function pointer

                id arg;
                [anInvocation getArgument:&arg atIndex:index];
                [finalInvocation setArgument:&arg atIndex:index];
            } else {
                NSAssert1(false, @"Unhandled ObjC Type (%s)", typeForArg);
            }
        }

        if (proxyState.continuationPresent && proxyState.errorHandlerPresent) {
            [anInvocation getArgument:&localContinuation atIndex:baseMaxIndex + 1];
            [anInvocation getArgument:&localErrorHandler atIndex:baseMaxIndex + 2];
        } else if (proxyState.continuationPresent) {
            [anInvocation getArgument:&localContinuation atIndex:baseMaxIndex + 1];
        } else if (proxyState.errorHandlerPresent) {
            [anInvocation getArgument:&localErrorHandler atIndex:baseMaxIndex + 1];
        }
    }

    [finalInvocation setTarget:self.target];
    [finalInvocation jbb_invokeWithContinuation:localContinuation errorHandler:localErrorHandler];

    if (proxyState.continuationPresent || proxyState.errorHandlerPresent) {
        id continuationObject = nil;
        [finalInvocation getReturnValue:&continuationObject];
        [anInvocation setReturnValue:&continuationObject];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    JBBObjectProxyState *proxyState = [[[JBBObjectProxyState alloc] init] autorelease];

    if (!jbb_continuationOrErrorHandlerPresentInSEL(aSelector)) {
        proxyState.continuationPresent = NO;
        proxyState.errorHandlerPresent = NO;
        proxyState.fullSelector = aSelector;
        proxyState.baseSelector = proxyState.fullSelector;
        proxyState.baseMethodSignature = [self.target methodSignatureForSelector:proxyState.baseSelector];
        proxyState.fullMethodSignature = proxyState.baseMethodSignature;
    } else {
        proxyState.continuationPresent = jbb_continuationPresentInSEL(aSelector);
        proxyState.errorHandlerPresent = jbb_errorHandlerPresentInSEL(aSelector);
        proxyState.fullSelector = aSelector;
        proxyState.baseSelector = [NSStringFromSelector(aSelector) jbb_baseSelector];
        proxyState.baseMethodSignature = [self.target methodSignatureForSelector:proxyState.baseSelector];

        if (!proxyState.baseMethodSignature) {
            return nil;
        }

        NSMutableString *newObjCTypes = [NSMutableString string];

        [newObjCTypes appendFormat:@"%@", @"@"];

        for (unsigned int index = 0; index < [proxyState.baseMethodSignature numberOfArguments]; index++) {
            [newObjCTypes appendFormat:@"%s", [proxyState.baseMethodSignature getArgumentTypeAtIndex:index]];
        }

        if (proxyState.continuationPresent) {
            [newObjCTypes appendFormat:@"%s", @encode(JBBContinuation)];
        }
        if (proxyState.errorHandlerPresent) {
            [newObjCTypes appendFormat:@"%s", @encode(JBBErrorHandler)];
        }

        proxyState.fullMethodSignature = [NSMethodSignature signatureWithObjCTypes:[newObjCTypes cStringUsingEncoding:[NSString defaultCStringEncoding]]];
    }

    [[[NSThread currentThread] threadDictionary] setObject:proxyState forKey:@"proxyState"];

    return proxyState.fullMethodSignature;
}

- (void)lock {
    dispatch_semaphore_wait(primaryLock, DISPATCH_TIME_FOREVER);
}

- (void)unlock {
    dispatch_semaphore_signal(primaryLock);
}
@end

@implementation JBBObjectProxyState
@synthesize baseSelector = mBaseSelector;
@synthesize fullSelector = mFullSelector;
@synthesize baseMethodSignature = mBaseMethodSignature;
@synthesize fullMethodSignature = mFullMethodSignature;
@synthesize continuationPresent = mContinuationPresent;
@synthesize errorHandlerPresent = mErrorHandlerPresent;

#pragma mark Instance Methods

- (id)init {
    self = [super init];

    if (!self) {
        return nil;
    }

    return self;
}

- (void)dealloc {
    self.baseMethodSignature = nil;
    self.fullMethodSignature = nil;

    [super dealloc];
}
@end

@implementation NSString (JBBObjectProxy)
- (BOOL)jbb_continuationOrErrorHandlerPresent {
    return [self jbb_continuationPresent] || [self jbb_errorHandlerPresent];
}

- (BOOL)jbb_continuationPresent {
    return ([self hasSuffix:@"continuation:"] || [self hasSuffix:@"continuation:errorHandler:"]);
}

- (BOOL)jbb_errorHandlerPresent {
    return [self hasSuffix:@"errorHandler:"];
}

- (SEL)jbb_baseSelector {
    if (![self jbb_continuationOrErrorHandlerPresent]) {
        return NSSelectorFromString(self);
    }

    NSMutableString *baseSel = [[self mutableCopy] autorelease];

    if ([baseSel hasSuffix:@":errorHandler:"]) {
        [baseSel setString:[baseSel substringToIndex:[baseSel rangeOfString:@"errorHandler:" options:NSBackwardsSearch].location]];
    }
    if ([baseSel hasSuffix:@":continuation:"]) {
        [baseSel setString:[baseSel substringToIndex:[baseSel rangeOfString:@"continuation:" options:NSBackwardsSearch].location]];
    }

    return NSSelectorFromString(baseSel);
}
@end

BOOL jbb_continuationOrErrorHandlerPresentInSEL(SEL aSelector) {
    return [NSStringFromSelector(aSelector) jbb_continuationOrErrorHandlerPresent];
}

BOOL jbb_continuationPresentInSEL(SEL aSelector) {
    return [NSStringFromSelector(aSelector) jbb_continuationPresent];
}

BOOL jbb_errorHandlerPresentInSEL(SEL aSelector) {
    return [NSStringFromSelector(aSelector) jbb_errorHandlerPresent];
}

