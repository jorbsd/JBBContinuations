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

#import <Foundation/Foundation.h>

@interface JBBInvocationProxy : NSProxy {
    id mTarget;
    SEL mBaseSelector;
    SEL mFullSelector;
    NSMethodSignature *mBaseMethodSignature;
    NSMethodSignature *mFullMethodSignature;
    BOOL mContinuationPresent;
    BOOL mErrorHandlerPresent;
}

#pragma mark Class Methods

+ (id)proxyWithTarget:(id)aTarget;

#pragma mark Instance Methods

- (id)initWithTarget:(id)aTarget;

@property (retain, readonly) id target;
@end

