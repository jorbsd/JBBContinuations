//
//  JBBContinuationProxy.h
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/19.
//  Copyright 2010 Jordan Breeding. All rights reserved.
//
//  BSD License, Use at your own risk
//

// Inspired by Mike Ash: http://mikeash.com/pyblog/friday-qa-2010-02-05-error-returns-with-continuation-passing-style.html
// Code also pulled from http://github.com/erica/NSObject-Utility-Categories/blob/master/NSObject-Utilities.m

#import "JBBTypes.h"

@interface JBBContinuationProxy : NSProxy {
    id mTarget;
    JBBContinuation mContinuation;
    JBBErrorHandler mErrorHandler;
}

#pragma mark Class Methods

+ (id)proxyWithTarget:(id)aTarget;
+ (id)proxyWithTarget:(id)aTarget continuation:(JBBContinuation)aContinuation;
+ (id)proxyWithTarget:(id)aTarget errorHandler:(JBBErrorHandler)anErrorHandler;
+ (id)proxyWithTarget:(id)aTarget continuation:(JBBContinuation)aContinuation errorHandler:(JBBErrorHandler)anErrorHandler;

#pragma mark Instance Methods

- (id)initWithTarget:(id)aTarget;
- (id)initWithTarget:(id)aTarget continuation:(JBBContinuation)aContinuation;
- (id)initWithTarget:(id)aTarget errorHandler:(JBBErrorHandler)anErrorHandler;
- (id)initWithTarget:(id)aTarget continuation:(JBBContinuation)aContinuation errorHandler:(JBBErrorHandler)anErrorHandler;

@property (retain) id target;
@property (copy) JBBContinuation continuation;
@property (copy) JBBErrorHandler errorHandler;
@end

