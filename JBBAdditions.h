//
//  JBBFSAdditions.h
//  JBBFSAdditions
//
//  Created by Jordan Breeding on 26/1/08.
//  Copyright 2008 Jordan Breeding. All rights reserved.
//

#import <tr1/memory>

@interface NSObject (JBBAdditions)
+ (BOOL)loadSelector:(SEL)oldSelector asSelector:(SEL)newSelector onlyWhenMissing:(BOOL)loadWhenMissing;

+ (BOOL)loadSelector:(SEL)oldSelector asSelector:(SEL)newSelector;

+ (BOOL)swapSelector:(SEL)oldSelector withSelector:(SEL)newSelector;
@end

@interface NSArray (JBBAdditions)
- (id)firstObject;

- (BOOL)isEmpty;

- (NSArray *)dictionariesWithKey:(NSString *)keyName;

- (NSArray *)dictionariesWithKey:(NSString *)keyName fromKeyPath:(NSString *)keyPath;
@end

@interface NSDictionary (JBBAdditions)
- (NSArray *)dictionariesForKey:(NSString *)keyName;
@end

@interface NSString (JBBAdditions)
- (void)print;

- (NSNumber *)unpack;

- (BOOL)isEmpty;
@end

@interface NSValue (JBBAdditions)
- (NSString *)pack;
@end

@interface NSData (JBBAdditions)
- (NSString *)pack;
@end

@interface NSAppleEventDescriptor (JBBAdditions)
- (NSString *)pack;
@end

namespace TagLib {
  namespace MPEG {
    class File;
  }
}

@interface JBBID3Tag : NSObject {
 @protected
  std::tr1::shared_ptr<TagLib::MPEG::File> mpegFile;
  NSString *_path;
}

@property (retain) NSString *path;

+ (id)tagWithPath:(NSString *)newPath;

- (id)init;

- (id)initWithPath:(NSString *)newPath;

- (void)dealloc;

- (BOOL)hasV1Tag;

- (BOOL)hasV2Tag;

- (BOOL)removeV1Tag;
@end
