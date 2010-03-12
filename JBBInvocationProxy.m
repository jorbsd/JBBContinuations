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

#import "JBBInvocationProxy.h"
#import "JBBTypes.h"

@interface JBBInvocationProxy ()
@property (retain) id target;
@property (assign) SEL baseSelector;
@property (assign) SEL fullSelector;
@property (retain) NSMethodSignature *baseMethodSignature;
@property (retain) NSMethodSignature *fullMethodSignature;
@property (assign) BOOL continuationPresent;
@property (assign) BOOL errorHandlerPresent;
@end

@implementation JBBInvocationProxy
@synthesize target = mTarget;
@synthesize baseSelector = mBaseSelector;
@synthesize fullSelector = mFullSelector;
@synthesize baseMethodSignature = mBaseMethodSignature;
@synthesize fullMethodSignature = mFullMethodSignature;
@synthesize continuationPresent = mContinuationPresent;
@synthesize errorHandlerPresent = mErrorHandlerPresent;

#pragma mark Class Methods

+ (id)proxyWithTarget:(id)aTarget {
    return [[[self alloc] initWithTarget:aTarget] autorelease];
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

- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSString *aSelectorString = NSStringFromSelector(aSelector);

    if ([aSelectorString hasSuffix:@"continuation:"] || [aSelectorString hasSuffix:@"errorHandler:"] || [aSelectorString hasSuffix:@"continuation:errorHandler:"]) {
        return self;
    }

    return self.target;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSParameterAssert([anInvocation selector] == self.fullSelector);
    NSParameterAssert([anInvocation methodSignature] == self.fullMethodSignature);

    // build the real invocation

    NSInvocation *theRealInvocation = [NSInvocation invocationWithMethodSignature:self.baseMethodSignature];
    [theRealInvocation setSelector:self.baseSelector];
    [theRealInvocation setTarget:self.target];

    NSUInteger baseNumberOfArgs = [self.baseMethodSignature numberOfArguments];
    NSUInteger baseMaxIndex = baseNumberOfArgs - 1;

    for (unsigned int index = 2; index < baseNumberOfArgs; index++) {
        const char *typeForArg = [self.baseMethodSignature getArgumentTypeAtIndex:index];

        // handle common types

        if (jbb_areObjCTypesEqual(typeForArg, @encode(char))) {
            char arg;
            [anInvocation getArgument:&arg atIndex:index];
            [theRealInvocation setArgument:&arg atIndex:index];
        } else if (jbb_areObjCTypesEqual(typeForArg, @encode(unsigned char))) {
            unsigned char arg;
            [anInvocation getArgument:&arg atIndex:index];
            [theRealInvocation setArgument:&arg atIndex:index];
        } else if (jbb_areObjCTypesEqual(typeForArg, @encode(short))) {
            short arg;
            [anInvocation getArgument:&arg atIndex:index];
            [theRealInvocation setArgument:&arg atIndex:index];
        } else if (jbb_areObjCTypesEqual(typeForArg, @encode(unsigned short))) {
            unsigned short arg;
            [anInvocation getArgument:&arg atIndex:index];
            [theRealInvocation setArgument:&arg atIndex:index];
        } else if (jbb_areObjCTypesEqual(typeForArg, @encode(int))) {
            int arg;
            [anInvocation getArgument:&arg atIndex:index];
            [theRealInvocation setArgument:&arg atIndex:index];
        } else if (jbb_areObjCTypesEqual(typeForArg, @encode(unsigned int))) {
            unsigned int arg;
            [anInvocation getArgument:&arg atIndex:index];
            [theRealInvocation setArgument:&arg atIndex:index];
        } else if (jbb_areObjCTypesEqual(typeForArg, @encode(long))) {
            long arg;
            [anInvocation getArgument:&arg atIndex:index];
            [theRealInvocation setArgument:&arg atIndex:index];
        } else if (jbb_areObjCTypesEqual(typeForArg, @encode(unsigned long))) {
            unsigned long arg;
            [anInvocation getArgument:&arg atIndex:index];
            [theRealInvocation setArgument:&arg atIndex:index];
        } else if (jbb_areObjCTypesEqual(typeForArg, @encode(long long))) {
            long long arg;
            [anInvocation getArgument:&arg atIndex:index];
            [theRealInvocation setArgument:&arg atIndex:index];
        } else if (jbb_areObjCTypesEqual(typeForArg, @encode(unsigned long long))) {
            unsigned long long arg;
            [anInvocation getArgument:&arg atIndex:index];
            [theRealInvocation setArgument:&arg atIndex:index];
        } else if (jbb_areObjCTypesEqual(typeForArg, @encode(float))) {
            float arg;
            [anInvocation getArgument:&arg atIndex:index];
            [theRealInvocation setArgument:&arg atIndex:index];
        } else if (jbb_areObjCTypesEqual(typeForArg, @encode(double))) {
            double arg;
            [anInvocation getArgument:&arg atIndex:index];
            [theRealInvocation setArgument:&arg atIndex:index];
        } else if (jbb_areObjCTypesEqual(typeForArg, @encode(id))) {
            id arg;
            [anInvocation getArgument:&arg atIndex:index];
            [theRealInvocation setArgument:&arg atIndex:index];
        } else if (jbb_areObjCTypesEqual(typeForArg, @encode(SEL))) {
            SEL arg;
            [anInvocation getArgument:&arg atIndex:index];
            [theRealInvocation setArgument:&arg atIndex:index];
        } else if (jbb_areObjCTypesEqual(typeForArg, @encode(Class))) {
            Class arg;
            [anInvocation getArgument:&arg atIndex:index];
            [theRealInvocation setArgument:&arg atIndex:index];
        } else if (jbb_areObjCTypesEqual(typeForArg, @encode(char *))) {
            char *arg;
            [anInvocation getArgument:&arg atIndex:index];
            [theRealInvocation setArgument:&arg atIndex:index];
        } else if (jbb_areObjCTypesEqual(typeForArg, @encode(NSPoint))) {
            NSPoint arg;
            [anInvocation getArgument:&arg atIndex:index];
            [theRealInvocation setArgument:&arg atIndex:index];
        } else if (jbb_areObjCTypesEqual(typeForArg, @encode(NSSize))) {
            NSSize arg;
            [anInvocation getArgument:&arg atIndex:index];
            [theRealInvocation setArgument:&arg atIndex:index];
        } else if (jbb_areObjCTypesEqual(typeForArg, @encode(NSRect))) {
            NSRect arg;
            [anInvocation getArgument:&arg atIndex:index];
            [theRealInvocation setArgument:&arg atIndex:index];
        } else if (jbb_areObjCTypesEqual(typeForArg, @encode(NSRange))) {
            NSRange arg;
            [anInvocation getArgument:&arg atIndex:index];
            [theRealInvocation setArgument:&arg atIndex:index];
        } else if (jbb_areObjCTypesEqual(typeForArg, @encode(CGPoint))) {
            CGPoint arg;
            [anInvocation getArgument:&arg atIndex:index];
            [theRealInvocation setArgument:&arg atIndex:index];
        } else if (jbb_areObjCTypesEqual(typeForArg, @encode(CGSize))) {
            CGSize arg;
            [anInvocation getArgument:&arg atIndex:index];
            [theRealInvocation setArgument:&arg atIndex:index];
        } else if (jbb_areObjCTypesEqual(typeForArg, @encode(CGRect))) {
            CGRect arg;
            [anInvocation getArgument:&arg atIndex:index];
            [theRealInvocation setArgument:&arg atIndex:index];
        } else if (jbb_ObjCTypeStartsWith(typeForArg, "^")) {
            // generic pointer, including function pointers

            void *arg;
            [anInvocation getArgument:&arg atIndex:index];
            [theRealInvocation setArgument:&arg atIndex:index];
        } else if (jbb_ObjCTypeStartsWith(typeForArg, "@")) {
            // most likely a block, handle like a function pointer

            id arg;
            [anInvocation getArgument:&arg atIndex:index];
            [theRealInvocation setArgument:&arg atIndex:index];
        } else {
            NSAssert1(false, @"Unhandled ObjC Type (%s)", typeForArg);
        }
    }

    const char *returnType = [self.baseMethodSignature methodReturnType];

    // capture NSError* locally
 
    NSError *anError = nil;
    NSError **anErrorPointer = &anError;
    BOOL anErrorOccurred = NO;
    BOOL anErrorPresent = NO;
 
    if ([NSStringFromSelector(self.baseSelector) hasSuffix:@":error:"] && jbb_areObjCTypesEqual([self.baseMethodSignature getArgumentTypeAtIndex:baseMaxIndex], @encode(NSError **))) {
        [theRealInvocation setArgument:&anErrorPointer atIndex:baseMaxIndex];
        anErrorPresent = YES;
    }
 
    [theRealInvocation invoke];
 
    id continuationObject = nil;
 
    if (anErrorPresent && jbb_areObjCTypesEqual(returnType, @encode(BOOL))) {
        BOOL returnValue = NO;
        [theRealInvocation getReturnValue:&returnValue];
        //[anInvocation setReturnValue:&returnValue];
        if (returnValue == NO) {
            anErrorOccurred = YES;
        } else {
            continuationObject = [NSValue valueWithBytes:&returnValue objCType:returnType];
        }
    } else if (jbb_areObjCTypesEqual(returnType, @encode(id))) {
        [theRealInvocation getReturnValue:&continuationObject];
        //[anInvocation setReturnValue:&continuationObject];
        if (!continuationObject) {
            anErrorOccurred = YES;
        }
    } else {
        void *returnValue = malloc([self.baseMethodSignature methodReturnLength]);
        [theRealInvocation getReturnValue:&returnValue];
        //[anInvocation setReturnValue:&returnValue];
        continuationObject = [NSValue valueWithBytes:&returnValue objCType:returnType];
    }
    [anInvocation setReturnValue:&continuationObject];
 
    JBBContinuation aContinuation = nil;
    JBBErrorHandler anErrorHandler = nil;

    if (self.continuationPresent && self.errorHandlerPresent) {
        [anInvocation getArgument:&aContinuation atIndex:baseMaxIndex + 1];
        [anInvocation getArgument:&anErrorHandler atIndex:baseMaxIndex + 2];
    } else if (self.continuationPresent) {
        [anInvocation getArgument:&aContinuation atIndex:baseMaxIndex + 1];
    } else if (self.errorHandlerPresent) {
        [anInvocation getArgument:&anErrorHandler atIndex:baseMaxIndex + 1];
    }
    
    if (anErrorOccurred && anErrorHandler) {
        anErrorHandler(anError);
    } else if (aContinuation) {
        aContinuation(continuationObject);
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    // we require either a bare message <message> or one of the following:
    //   <message> continuation:
    //   <message> errorHandler:
    //   <message> continuation: errorHandler:
    //
    // example selectors:
    //   stringWithCString:encoding:
    //   stringWithCString:encoding:continuation:
    //   stringWithCString:encoding:errorHandler:
    //   stringWithCString:encoding:continuation:errorHandler:

    self.fullSelector = aSelector;

    BOOL continuationPresent = NO;
    BOOL errorHandlerPresent = NO;
    NSString *aSelectorString = NSStringFromSelector(aSelector);

    if ([aSelectorString isEqualToString:@"continuation:"] || [aSelectorString isEqualToString:@"errorHandler:"] || [aSelectorString isEqualToString:@"continuation:errorHandler:"]) {
        return nil;
    }

    NSMutableString *baseSelectorString = [aSelectorString mutableCopy];

    if ([baseSelectorString hasSuffix:@":errorHandler:"]) {
        [baseSelectorString setString:[baseSelectorString substringToIndex:[baseSelectorString rangeOfString:@"errorHandler:" options:NSBackwardsSearch].location]];
        errorHandlerPresent = YES;
        self.errorHandlerPresent = errorHandlerPresent;
    }
    if ([baseSelectorString hasSuffix:@":continuation:"]) {
        [baseSelectorString setString:[baseSelectorString substringToIndex:[baseSelectorString rangeOfString:@"continuation:" options:NSBackwardsSearch].location]];
        continuationPresent = YES;
        self.continuationPresent = continuationPresent;
    }

    self.baseSelector = NSSelectorFromString(baseSelectorString);
    NSMethodSignature *origSignature = [self.target methodSignatureForSelector:NSSelectorFromString(baseSelectorString)];
    self.baseMethodSignature = origSignature;

    if (!origSignature) {
        return nil;
    }

    NSMutableString *newSignatureObjCTypes = [NSMutableString string];

//    [newSignatureObjCTypes appendFormat:@"%s", [origSignature methodReturnType]];
    [newSignatureObjCTypes appendFormat:@"%s", "@"];

    for (unsigned int index = 0; index < [origSignature numberOfArguments]; index++) {
        [newSignatureObjCTypes appendFormat:@"%s", [origSignature getArgumentTypeAtIndex:index]];
    }

    if (continuationPresent) {
        [newSignatureObjCTypes appendFormat:@"%s", @encode(JBBContinuation)];
    }
    if (errorHandlerPresent) {
        [newSignatureObjCTypes appendFormat:@"%s", @encode(JBBErrorHandler)];
    }

    NSMethodSignature *newSignature = [NSMethodSignature signatureWithObjCTypes:[newSignatureObjCTypes cStringUsingEncoding:[NSString defaultCStringEncoding]]];
    self.fullMethodSignature = newSignature;

    [baseSelectorString release];

    return newSignature;
}
@end

