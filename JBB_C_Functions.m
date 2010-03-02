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

NSString* jbb_NSStringFromCString(const char *inString) {
    return [NSString stringWithCString:inString encoding:NSUTF8StringEncoding];
}

