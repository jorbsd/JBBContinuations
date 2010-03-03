//
//  JBB_C_Functions.h
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/19.
//  Copyright 2010 Jordan Breeding. All rights reserved.
//
//  BSD License, Use at your own risk
//

// jbb_removeObjCTypeQualifiers(const char *aType) returns memory from
// malloc()

extern const char* jbb_removeObjCTypeQualifiers(const char *aType);
extern NSString* jbb_NSStringFromCString(const char *aString);

