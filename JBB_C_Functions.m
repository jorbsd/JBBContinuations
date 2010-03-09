//
//  JBB_C_Functions.m
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/19.
//  Copyright 2010 Jordan Breeding. All rights reserved.
//
//  BSD License, Use at your own risk
//

#import <string.h>

const char* jbb_removeObjCTypeQualifiers(const char *aType) {
    // get rid of the following ObjC Type Encoding qualifiers:
    // r, n, N, o, O, R, V
    //
    // although it would be better not to hard code them they are
    // discarded by @encode(), but present in -[NSMethodSignature methodReturnType]
    // and -[NSMethodSignaure getArgumentTypeAtIndex:]

    if ((strncasecmp("r", aType, 1) == 0) || (strncasecmp("n", aType, 1) == 0) || (strncasecmp("o", aType, 1) == 0) || (strncmp("V", aType, 1) == 0)) {
        char *newString = (char *)malloc(sizeof(aType) - 1);
        strncpy(newString, aType + 1, sizeof(aType) - 1);
        const char *returnString = jbb_removeObjCTypeQualifiers(newString);
        free(newString);
        return returnString;
    } else {
        return aType;
    }
}

NSString* jbb_NSStringFromCString(const char *aString) {
    return [NSString stringWithCString:aString encoding:NSUTF8StringEncoding];
}

void jbb_runInvocationWithContinuationAndErrorHandler(NSInvocation *anInvocation, JBBContinuation aContinuation, JBBErrorHandler anErrorHandler) {
    NSMethodSignature *ms = [anInvocation methodSignature];
    const char *returnType = jbb_removeObjCTypeQualifiers([ms methodReturnType]);

    // capture NSError* locally

    NSError *anError = nil;
    NSError **anErrorPointer = &anError;
    BOOL anErrorOccurred = NO;
    BOOL anErrorPresent = NO;

    if ([NSStringFromSelector([anInvocation selector]) hasSuffix:@":error:"] && (strcasecmp([ms getArgumentTypeAtIndex:[ms numberOfArguments] - 1], @encode(NSError **)) == 0)) {
        [anInvocation setArgument:&anErrorPointer atIndex:[ms numberOfArguments] - 1];
        anErrorPresent = YES;
    }

    [anInvocation invoke];

    id continuationObject = nil;

    if (anErrorPresent && (strcasecmp(returnType, @encode(BOOL)) == 0)) {
        BOOL returnValue = NO;
        [anInvocation getReturnValue:&returnValue];
        if (returnValue == NO) {
            anErrorOccurred = YES;
        } else {
            continuationObject = [NSValue valueWithBytes:&returnValue objCType:returnType];
        }
    } else if (strcasecmp(returnType, @encode(id)) == 0) {
        [anInvocation getReturnValue:&continuationObject];
        if (!continuationObject) {
            anErrorOccurred = YES;
        }
    } else {
        void *returnValue = malloc([ms methodReturnLength]);
        continuationObject = [NSValue valueWithBytes:&returnValue objCType:returnType];
        free(returnValue);
        returnValue = NULL;
    }

    if (anErrorOccurred && anErrorHandler) {
        anErrorHandler(anError);
    } else if (aContinuation) {
        aContinuation(continuationObject);
    }
}

