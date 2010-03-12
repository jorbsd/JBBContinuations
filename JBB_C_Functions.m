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

BOOL jbb_areObjCTypesEqual(const char *lhs, const char *rhs) {
    const char *newLhs = jbb_removeObjCTypeQualifiers(lhs);
    const char *newRhs = jbb_removeObjCTypeQualifiers(rhs);

    return strcmp(newLhs, newRhs) == 0;
}

BOOL jbb_ObjCTypeStartsWith(const char *objCType, const char *targetChar) {
    const char *newObjCType = jbb_removeObjCTypeQualifiers(objCType);

    return strncmp(newObjCType, targetChar, 1);
}

