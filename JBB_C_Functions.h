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

extern const char* jbb_removeObjCTypeQualifiers(const char *aType);

#if defined(__OBJC__)
extern NSString* jbb_NSStringFromCString(const char *aString);
extern void jbb_runInvocationWithContinuationAndErrorHandler(NSInvocation *anInvocation, JBBContinuation aContinuation, JBBErrorHandler anErrorHandler);
#endif

