//
//  NSObject+JBBAdditions.m
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/18.
//  Copyright 2008 Jordan Breeding. All rights reserved.
//

#import "NSObject+JBBAdditions.h"

#import <objc/objc-runtime.h>
#import <objc/objc-class.h>

@implementation NSObject (JBBAdditions)

#pragma mark Class Methods

+ (BOOL)loadSelector:(SEL)oldSelector asSelector:(SEL)newSelector {
  return [self loadSelector:oldSelector asSelector:newSelector onlyWhenMissing:YES];
}

+ (BOOL)loadSelector:(SEL)oldSelector asSelector:(SEL)newSelector onlyWhenMissing:(BOOL)loadWhenMissing {
  if (loadWhenMissing && [self instancesRespondToSelector:newSelector]) {
    return NO;
  }
  
  if (![self instancesRespondToSelector:oldSelector]) {
    return NO;
  }
  
  Method oldSelectorMethod = class_getInstanceMethod([self class], oldSelector);
  IMP oldSelectorImplementation = method_getImplementation(oldSelectorMethod);
  const char *oldSelectorTypes = method_getTypeEncoding(oldSelectorMethod);
  class_addMethod([self class], newSelector, oldSelectorImplementation, oldSelectorTypes);
  
  return YES;
}

+ (BOOL)swapSelector:(SEL)oldSelector withSelector:(SEL)newSelector {
  if (!([self instancesRespondToSelector:oldSelector] && [self instancesRespondToSelector:newSelector])) {
    return NO;
  }
  
  Method oldSelectorMethod = class_getInstanceMethod([self class], oldSelector);
  IMP oldSelectorImplementation = method_getImplementation(oldSelectorMethod);
  const char *oldSelectorTypes = method_getTypeEncoding(oldSelectorMethod);
  
  Method newSelectorMethod = class_getInstanceMethod([self class], newSelector);
  IMP newSelectorImplementation = method_getImplementation(newSelectorMethod);
  const char *newSelectorTypes = method_getTypeEncoding(newSelectorMethod);
  
  class_addMethod([self class], newSelector, oldSelectorImplementation, oldSelectorTypes);
  class_addMethod([self class], oldSelector, newSelectorImplementation, newSelectorTypes);
  
  return YES;
}
@end

