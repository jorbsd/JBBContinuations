//
//  JBB_C_Functions.h
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/19.
//  Copyright 2010 Jordan Breeding. All rights reserved.
//
//  BSD License, Use at your own risk
//

#import "JBBTypes.h"

#if defined(__OBJC__)
extern const char* jbb_removeObjCTypeQualifiers(const char *aType);
extern NSString* jbb_NSStringFromCString(const char *aString);
extern BOOL jbb_areObjCTypesEqual(const char *lhs, const char *rhs);
extern BOOL jbb_ObjCTypeStartsWith(const char *objCType, const char *targetChar);
#endif

