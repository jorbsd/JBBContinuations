//
//  NSInvocation+JBBAdditions.h
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
#import "JBBTypes.h"

@interface NSInvocation (JBBAdditions)

#pragma mark Instance Methods

- (void)jbb_invokeWithContinuation:(JBBContinuation)aContinuation;
- (void)jbb_invokeWithErrorHandler:(JBBErrorHandler)anErrorHandler;
- (void)jbb_invokeWithContinuation:(JBBContinuation)aContinuation errorHandler:(JBBErrorHandler)anErrorHandler;
@end

