//
//  JBBID3Tag.h
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/19.
//  Copyright 2008 Jordan Breeding. All rights reserved.
//

#import <tr1/memory>

#import <TagLib/mpegfile.h>

#import "NSString+JBBAdditions.h"

@interface JBBID3Tag : NSObject {
@protected
  std::auto_ptr<TagLib::MPEG::File> mpegFile;
  NSString *path_;
}

#pragma mark Properties

@property (retain) NSString *path;

#pragma mark Class Methods

+ (id)tagWithPath:(NSString *)newPath;

#pragma mark Instance Methods

- (BOOL)hasV1Tag;
- (BOOL)hasV2Tag;
- (id)initWithPath:(NSString *)newPath;
- (BOOL)removeV1Tag;
@end

