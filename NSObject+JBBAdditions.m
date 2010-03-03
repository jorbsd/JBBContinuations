//
//  NSObject+JBBAdditions.m
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/19.
//  Copyright 2010 Jordan Breeding. All rights reserved.
//
//  BSD License, Use at your own risk
//

#import "NSObject+JBBAdditions.h"
#import "NSString+JBBAdditions.h"

// Inspired by Mike Ash: http://mikeash.com/pyblog/friday-qa-2010-02-05-error-returns-with-continuation-passing-style.html
// Code also pulled from http://github.com/erica/NSObject-Utility-Categories/blob/master/NSObject-Utilities.m

NSInvocation* jbb_buildInvocation(id anObject, SEL aSelector, va_list args);
void jbb_puts(id anObject);

@implementation NSObject (JBBAdditions)

#pragma mark Class Methods

+ (NSInvocation*)jbb_invocationWithSelector:(SEL)aSelector, ... {
    NSInvocation *returnVal = nil;

    va_list args;
    va_start(args, aSelector);
    returnVal = [self jbb_invocationWithSelector:aSelector arguments:args];
    va_end(args);

    return returnVal;
}

+ (NSInvocation*)jbb_invocationWithSelector:(SEL)aSelector arguments:(va_list)args {
    return jbb_buildInvocation(self, aSelector, args);
}

#pragma mark Instance Methods

- (NSInvocation*)jbb_invocationWithSelector:(SEL)aSelector, ... {
    NSInvocation *returnVal = nil;

    va_list args;
    va_start(args, aSelector);
    returnVal = [self jbb_invocationWithSelector:aSelector arguments:args];
    va_end(args);

    return returnVal;
}

- (NSInvocation*)jbb_invocationWithSelector:(SEL)aSelector arguments:(va_list)args {
    return jbb_buildInvocation(self, aSelector, args);
}

- (void)jbb_puts {
    if ([[self description] hasSuffix:@"\n"]) {
        [[self description] jbb_print];
    } else {
        [[[self description] stringByAppendingString:@"\n"] jbb_print];
    }
}
@end

NSInvocation* jbb_buildInvocation(id anObject, SEL aSelector, va_list args) {
    if (![anObject respondsToSelector:aSelector]) {
        return nil;
    }

    NSMethodSignature *ms = [anObject methodSignatureForSelector:aSelector];
    if (!ms) {
        return nil;
    }

    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:ms];
    if (!inv) {
        return nil;
    }

    [inv setTarget:anObject];
    [inv setSelector:aSelector];

    int argCount = 2;
    int totalArgs = [ms numberOfArguments];

    while (argCount < totalArgs) {
        const char *argType = jbb_removeObjCTypeQualifiers([ms getArgumentTypeAtIndex:argCount]);
        NSString *argTypeString = jbb_NSStringFromCString(argType);

        // use @encode() where possible
        //
        // the following types are assumed to be less likely to change over time and
        // might be used in some capactiy directly:
        //
        // [array type] - an array
        // {name=type...} - a structure (we will support specific structures directly -- NSRect, ...)
        // (name=type...) - a union
        // bnum - a bitfield of num bits
        // ^type - a pointer to type
        // ? - an unknown type

        if ([argTypeString isEqualToString:jbb_NSStringFromCString(@encode(id))]) {
            id arg = va_arg(args, id);
            [inv setArgument:&arg atIndex:argCount++];
        } else if ([argTypeString isEqualToString:jbb_NSStringFromCString(@encode(char))]) {
            char arg = va_arg(args, char);
            [inv setArgument:&arg atIndex:argCount++];
        } else if ([argTypeString isEqualToString:jbb_NSStringFromCString(@encode(unsigned char))]) {
            unsigned char arg = va_arg(args, unsigned char);
            [inv setArgument:&arg atIndex:argCount++];
        } else if ([argTypeString isEqualToString:jbb_NSStringFromCString(@encode(short))]) {
            short arg = va_arg(args, short);
            [inv setArgument:&arg atIndex:argCount++];
        } else if ([argTypeString isEqualToString:jbb_NSStringFromCString(@encode(unsigned short))]) {
            unsigned short arg = va_arg(args, unsigned short);
            [inv setArgument:&arg atIndex:argCount++];
        } else if ([argTypeString isEqualToString:jbb_NSStringFromCString(@encode(int))]) {
            int arg = va_arg(args, int);
            [inv setArgument:&arg atIndex:argCount++];
        } else if ([argTypeString isEqualToString:jbb_NSStringFromCString(@encode(unsigned int))]) {
            unsigned int arg = va_arg(args, unsigned int);
            [inv setArgument:&arg atIndex:argCount++];
        } else if ([argTypeString isEqualToString:jbb_NSStringFromCString(@encode(long))]) {
            long arg = va_arg(args, long);
            [inv setArgument:&arg atIndex:argCount++];
        } else if ([argTypeString isEqualToString:jbb_NSStringFromCString(@encode(unsigned long))]) {
            unsigned long arg = va_arg(args, unsigned long);
            [inv setArgument:&arg atIndex:argCount++];
        } else if ([argTypeString isEqualToString:jbb_NSStringFromCString(@encode(long long))]) {
            long long arg = va_arg(args, long long);
            [inv setArgument:&arg atIndex:argCount++];
        } else if ([argTypeString isEqualToString:jbb_NSStringFromCString(@encode(unsigned long long))]) {
            unsigned long long arg = va_arg(args, unsigned long long);
            [inv setArgument:&arg atIndex:argCount++];
        } else if ([argTypeString isEqualToString:jbb_NSStringFromCString(@encode(float))]) {
            float arg = va_arg(args, float);
            [inv setArgument:&arg atIndex:argCount++];
        } else if ([argTypeString isEqualToString:jbb_NSStringFromCString(@encode(double))]) {
            double arg = va_arg(args, double);
            [inv setArgument:&arg atIndex:argCount++];
        } else if ([argTypeString isEqualToString:jbb_NSStringFromCString(@encode(Class))]) {
            Class arg = va_arg(args, Class);
            [inv setArgument:&arg atIndex:argCount++];
        } else if ([argTypeString isEqualToString:jbb_NSStringFromCString(@encode(SEL))]) {
            SEL arg = va_arg(args, SEL);
            [inv setArgument:&arg atIndex:argCount++];
        } else if ([argTypeString isEqualToString:jbb_NSStringFromCString(@encode(char *))]) {
            char *arg = va_arg(args, char *);
            [inv setArgument:&arg atIndex:argCount++];
        } else if ([argTypeString isEqualToString:jbb_NSStringFromCString(@encode(NSRect))]) {
            NSRect arg = va_arg(args, NSRect);
            [inv setArgument:&arg atIndex:argCount++];
        } else if ([argTypeString isEqualToString:jbb_NSStringFromCString(@encode(NSPoint))]) {
            NSPoint arg = va_arg(args, NSPoint);
            [inv setArgument:&arg atIndex:argCount++];
        } else if ([argTypeString isEqualToString:jbb_NSStringFromCString(@encode(NSSize))]) {
            NSSize arg = va_arg(args, NSSize);
            [inv setArgument:&arg atIndex:argCount++];
        } else if ([argTypeString isEqualToString:jbb_NSStringFromCString(@encode(CGRect))]) {
            CGRect arg = va_arg(args, CGRect);
            [inv setArgument:&arg atIndex:argCount++];
        } else if ([argTypeString isEqualToString:jbb_NSStringFromCString(@encode(CGPoint))]) {
            CGPoint arg = va_arg(args, CGPoint);
            [inv setArgument:&arg atIndex:argCount++];
        } else if ([argTypeString isEqualToString:jbb_NSStringFromCString(@encode(CGSize))]) {
            CGSize arg = va_arg(args, CGSize);
            [inv setArgument:&arg atIndex:argCount++];
        } else if ([argTypeString hasPrefix:@"^"]) {
            // this is a pointer, but we don't want to bother with figuring out
            // the exact type, pointers are all the same size though
            // so it should be fine
            //
            // since we just look at the beginning this will even
            // handle function pointers

            void *arg = va_arg(args, void *);
            [inv setArgument:&arg atIndex:argCount++];
        } else if ([argTypeString hasPrefix:@"@"]) {
            // before we tested for bare objects, but block are objects that
            // show up as "@?", there might be other cases in the future as well

            id arg = va_arg(args, id);
            [inv setArgument:&arg atIndex:argCount++];
        } else {
            // TODO: support more types
            //
            // we don't support the rest of the types, things like
            // bitfields, custom structs, etc.

            NSLog(@"type (%@) not supported, returning nil", argTypeString);
            return nil;
        }
    }

    if (argCount != totalArgs) {
        printf("Invocation argument count mismatch: %d expected, %d sent\n", [ms numberOfArguments], argCount);
        return nil;
    }

    return inv;
}

void jbb_puts(id anObject) {
    [anObject jbb_puts];
}

