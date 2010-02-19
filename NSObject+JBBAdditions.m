//
//  NSObject+JBBAdditions.m
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/19.
//  Copyright 2010 Jordan Breeding. All rights reserved.
//
//  BSD License, Use at your own risk
//

#import <string.h>

#import "NSObject+JBBAdditions.h"
#import "NSString+JBBAdditions.h"

// Inspired by Mike Ash: http://mikeash.com/pyblog/friday-qa-2010-02-05-error-returns-with-continuation-passing-style.html
// Code also pulled from http://github.com/erica/NSObject-Utility-Categories/blob/master/NSObject-Utilities.m

const char* jbb_removeObjCTypeQualifiers(const char *inType);
void jbb_runSelector(id object, SEL selector, va_list args, ErrorHandler errorHandler, Continuation continuation);
NSString* jbb_NSStringFromCString(char *inString);
NSInvocation* jbb_buildInvocation(id object, SEL selector, va_list args);
void jbb_puts(id objectToPrint);

@implementation NSObject (JBBAdditions)

#pragma mark Class Methods

+ (void)jbb_errorHandler:(ErrorHandler)errorHandler continuation:(Continuation)continuation forSelectorAndArguments:(SEL)selector, ... {
    va_list args;
    va_start(args, selector);
    jbb_runSelector(self, selector, args, errorHandler, continuation);
    va_end(args);
}

#pragma mark Instance Methods

- (void)jbb_errorHandler:(ErrorHandler)errorHandler continuation:(Continuation)continuation forSelectorAndArguments:(SEL)selector, ... {
    va_list args;
    va_start(args, selector);
    jbb_runSelector(self, selector, args, errorHandler, continuation);
    va_end(args);
}

- (void)jbb_puts {
    if ([[self description] hasSuffix:@"\n"]) {
        [[self description] jbb_print];
    } else {
        [[[self description] stringByAppendingString:@"\n"] jbb_print];
    }
}
@end

const char* jbb_removeObjCTypeQualifiers(const char *inType) {
    // get rid of the following ObjC Type Encoding qualifiers:
    // r, n, N, o, O, R, V
    //
    // although it would be better not to hard code them they are
    // discarded by @encode(), but present in -[NSMethodSignature methodReturnType]
    // and -[NSMethodSignaure getArgumentTypeAtIndex:]

    if ((strncmp("r", inType, 1) == 0) || (strncmp("n", inType, 1) == 0) || (strncmp("N", inType, 1) == 0) || (strncmp("o", inType, 1) == 0) || (strncmp("O", inType, 1) == 0) || (strncmp("R", inType, 1) == 0) || (strncmp("V", inType, 1) == 0)) {
        char *newString = (char*)malloc(sizeof(inType) - 1);
        strncpy(newString, inType + 1, sizeof(inType) - 1);
        const char *returnString = jbb_removeObjCTypeQualifiers(newString);
        free(newString);
        return returnString;
    } else {
        return inType;
    }
}

void jbb_runSelector(id object, SEL selector, va_list args, ErrorHandler errorHandler, Continuation continuation) {
    NSInvocation *inv = jbb_buildInvocation(object, selector, args);
    NSMethodSignature *ms = [inv methodSignature];
    const char *returnType = jbb_removeObjCTypeQualifiers([ms methodReturnType]);
    NSString *returnTypeString = [NSString stringWithCString:returnType encoding:NSUTF8StringEncoding];

    // capture the possible NSError* locally regardless of the original value
    NSError *localError = nil;
    NSError **localErrorPointer = &localError;
    BOOL errorOccurred = NO;
    if ([NSStringFromSelector(selector) hasSuffix:@":error:"]) {
        [inv setArgument:&localErrorPointer atIndex:[ms numberOfArguments] - 1];
    }

    [inv invoke];

    // we wrap anything other than objects in an NSValue with ObjC type encoding
    // we do error checking for id == nil and (BOOL)char == NO

    id continuationObject = nil;

    if ([returnTypeString isEqualToString:jbb_NSStringFromCString(@encode(id))]) {
        [inv getReturnValue:&continuationObject];
        if (!continuationObject) {
            errorOccurred = YES;
        }
    } else if ([returnTypeString isEqualToString:jbb_NSStringFromCString(@encode(char))]) {
        // most likely a BOOL in reality

        char returnValue = NO;
        [inv getReturnValue:&returnValue];
        if ((BOOL)returnValue == NO) {
            errorOccurred = YES;
        } else {
            continuationObject = [NSValue valueWithBytes:&returnValue objCType:returnType];
        }
    } else {
        void *returnValue = malloc([ms methodReturnLength]);
        continuationObject = [NSValue valueWithBytes:&returnValue objCType:returnType];
    }

    if (errorOccurred) {
        errorHandler(localError);
    } else {
        continuation(continuationObject);
    }
}

NSString* jbb_NSStringFromCString(char *inString) {
    return [NSString stringWithCString:inString encoding:NSUTF8StringEncoding];
}

NSInvocation* jbb_buildInvocation(id object, SEL selector, va_list args) {
    if (![object respondsToSelector:selector]) {
        return nil;
    }

    NSMethodSignature *ms = [object methodSignatureForSelector:selector];
    if (!ms) {
        return nil;
    }

    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:ms];
    if (!inv) {
        return nil;
    }

    [inv setTarget:object];
    [inv setSelector:selector];

    int argCount = 2;
    int totalArgs = [ms numberOfArguments];

    while (argCount < totalArgs) {
        const char *argType = jbb_removeObjCTypeQualifiers([ms getArgumentTypeAtIndex:argCount]);
        NSString *argTypeString = [NSString stringWithCString:argType encoding:NSUTF8StringEncoding];

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

void jbb_puts(id objectToPrint) {
    [objectToPrint jbb_puts];
}

