//
//  JBBInvocationProxy.h
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/19.
//  Copyright 2010 Jordan Breeding. All rights reserved.
//
//  BSD License, Use at your own risk
//

// Inspired by Mike Ash: http://mikeash.com/pyblog/friday-qa-2010-02-05-error-returns-with-continuation-passing-style.html
// Code also pulled from http://github.com/erica/NSObject-Utility-Categories/blob/master/NSObject-Utilities.m

// This class uses a NSProxy to cache NSInvocation* per thread and target

#import <Foundation/Foundation.h>
#import "JBBTypes.h"

@interface JBBInvocationProxy : NSProxy {
    id mTarget;
}

#pragma mark Class Methods

+ (void)invokeWithContinuation:(JBBContinuation)aContinuation;
+ (void)invokeWithErroHandler:(JBBErrorHandler)anErrorHandler;
+ (void)invokeWithContinuation:(JBBContinuation)aContinuation errorHandler:(JBBErrorHandler)anErrorHandler;
+ (id)proxyWithTarget:(id)aTarget;
+ (NSInvocation *)getInvocation;

#pragma mark Instance Methods

- (id)initWithTarget:(id)aTarget;

@property (retain) id target;
@end

