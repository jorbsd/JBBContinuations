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

// id and char (assumed to be BOOL) will be always be checked, the errorHandler will be run if id is nil or char/BOOL is NO
// id will be passed through untouched, all other types will be passed to continuation as NSValue with objCType set
//
// if the NSError* passed to errorHandler is nil assume that an error condition really did still occur as
// id was nil or char/BOOL was NO

#import <Foundation/Foundation.h>
#import "JBBTypes.h"

@interface JBBContinuationProxy : NSProxy {
    id mTarget;
    Continuation mContinuation;
    ErrorHandler mErrorHandler;
}

#pragma mark Class Methods

+ (id)proxy;
+ (id)proxyWithTarget:(id)aTarget;
+ (id)proxyWithTarget:(id)aTarget continuation:(Continuation)aContinuation;
+ (id)proxyWithTarget:(id)aTarget errorHandler:(ErrorHandler)anErrorHandler;
+ (id)proxyWithContinuation:(Continuation)aContinuation;
+ (id)proxyWithContinuation:(Continuation)aCOntinuation errorHandler:(ErrorHandler)anErrorHandler;
+ (id)proxyWithErrorHandler:(ErrorHandler)anErrorHandler;
+ (id)proxyWithTarget:(id)aTarget continuation:(Continuation)aContinuation errorHandler:(ErrorHandler)anErrorHandler;

#pragma mark Instance Methods

- (id)init;
- (id)initWithTarget:(id)aTarget;
- (id)initWithTarget:(id)aTarget continuation:(Continuation)aContinuation;
- (id)initWithTarget:(id)aTarget errorHandler:(ErrorHandler)anErrorHandler;
- (id)initWithContinuation:(Continuation)aContinuation;
- (id)initWithContinuation:(Continuation)aContinuation errorHandler:(ErrorHandler)anErrorHandler;
- (id)initWithErrorHandler:(ErrorHandler)anErrorHandler;
- (id)initWithTarget:(id)aTarget continuation:(Continuation)aContinuation errorHandler:(ErrorHandler)anErrorHandler;

@property (retain) id target;
@property (copy) Continuation continuation;
@property (copy) ErrorHandler errorHandler;
@end

