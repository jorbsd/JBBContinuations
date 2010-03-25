//
//  NSObject+JBBAdditions.m
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/19.
//  Copyright 2010 Jordan Breeding. All rights reserved.
//
//  BSD License, Use at your own risk
//

// Inspired by Mike Ash: http://mikeash.com/pyblog/friday-qa-2010-02-05-error-returns-with-continuation-passing-style.html
// Code also pulled from http://github.com/erica/NSObject-Utility-Categories/blob/master/NSObject-Utilities.m

#import "JBBObjectProxy.h"
#import "JBBTypes.h"
#import "NSObject+JBBAdditions.h"
#import "NSString+JBBAdditions.h"

void jbb_puts(id anObject);

@implementation NSObject (JBBAdditions)

#pragma mark Class Methods

+ (id)jbb_proxy {
    return [JBBObjectProxy proxyWithTarget:self];
}

+ (id)jbb_proxyWithContinuation:(JBBContinuation)aContinuation {
    return [JBBObjectProxy proxyWithTarget:self continuation:aContinuation];
}

+ (id)jbb_proxyWithErrorHandler:(JBBErrorHandler)anErrorHandler {
    return [JBBObjectProxy proxyWithTarget:self errorHandler:anErrorHandler];
}

+ (id)jbb_proxyWithContinuation:(JBBContinuation)aContinuation errorHandler:(JBBErrorHandler)anErrorHandler {
    return [JBBObjectProxy proxyWithTarget:self continuation:aContinuation errorHandler:anErrorHandler];
}


#pragma mark Instance Methods

- (id)jbb_proxy {
    return [JBBObjectProxy proxyWithTarget:self];
}

- (id)jbb_proxyWithContinuation:(JBBContinuation)aContinuation {
    return [JBBObjectProxy proxyWithTarget:self continuation:aContinuation];
}

- (id)jbb_proxyWithErrorHandler:(JBBErrorHandler)anErrorHandler {
    return [JBBObjectProxy proxyWithTarget:self errorHandler:anErrorHandler];
}

- (id)jbb_proxyWithContinuation:(JBBContinuation)aContinuation errorHandler:(JBBErrorHandler)anErrorHandler {
    return [JBBObjectProxy proxyWithTarget:self continuation:aContinuation errorHandler:anErrorHandler];
}

- (void)jbb_puts {
    if ([[self description] hasSuffix:@"\n"]) {
        [[self description] jbb_print];
    } else {
        [[[self description] stringByAppendingString:@"\n"] jbb_print];
    }
}
@end

void jbb_puts(id anObject) {
    [anObject jbb_puts];
}

