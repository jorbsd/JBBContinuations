//
//  JBB_C_Functions.m
//  JBBContinuations
//
//  Created by Jordan Breeding on 2008/10/19.
//  Copyright 2010 Jordan Breeding. All rights reserved.
//
//  BSD License, Use at your own risk
//

#import <string.h>

BOOL jbb_strCaseStartsWith(const char *aString, const char *aPrefix) {
    return strncasecmp(aPrefix, aString, strlen(aPrefix)) == 0;
}

BOOL jbb_strStartsWith(const char *aString, const char *aPrefix) {
    return strncmp(aPrefix, aString, strlen(aPrefix)) == 0;
}

const char* jbb_removeObjCTypeQualifiers(const char *aType) {
    // get rid of the following ObjC Type Encoding qualifiers:
    // r, n, N, o, O, R, V
    //
    // although it would be better not to hard code them they are
    // discarded by @encode(), but present in -[NSMethodSignature methodReturnType]
    // and -[NSMethodSignaure getArgumentTypeAtIndex:]

    if (jbb_strCaseStartsWith(aType, "r") || jbb_strCaseStartsWith(aType, "n") || jbb_strCaseStartsWith(aType, "o") || jbb_strStartsWith(aType, "V")) {
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

