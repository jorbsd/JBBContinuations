//
//  JBBID3Tag.m
//  JBBAdditions
//
//  Created by Jordan Breeding on 2008/10/19.
//  Copyright 2008 Jordan Breeding. All rights reserved.
//

#import "JBBID3Tag.h"

#import <TagLib/mpegfile.h>
#import <TagLib/tag.h>
#import <TagLib/id3v1tag.h>
#import <TagLib/id3v2tag.h>

@interface JBBID3Tag ()

#pragma mark Instance Methods

- (void)refreshTags;
@end

@implementation JBBID3Tag

#pragma mark Properties

@synthesize path = path_;

#pragma mark Class Methods

+ (id)tagWithPath:(NSString *)newPath {
  return [[[self alloc] initWithPath:newPath] autorelease];
}

#pragma mark Instance Methods

- (void)dealloc {
  [path_ release];
  path_ = nil;
  [super dealloc];
}

- (BOOL)hasV1Tag {
  return (mpegFile->ID3v1Tag() && !(mpegFile->ID3v1Tag()->isEmpty()));
}

- (BOOL)hasV2Tag {
  return (mpegFile->ID3v2Tag() && !(mpegFile->ID3v2Tag()->isEmpty()));
}

- (id)init {
  return [self initWithPath: @""];
}

- (id)initWithPath:(NSString *)newPath {
  self = [super init];
  
  if (!self) {
    return nil;
  }
  
  path_ = [newPath retain];
  [self refreshTags];
  return self;
}

- (void)refreshTags {
  if ([[self path] isEmpty]) {
    mpegFile.reset();
  } else {
    char *pathToOpen = strdup([[self path] fileSystemRepresentation]);
    mpegFile.reset(new TagLib::MPEG::File(pathToOpen, true, TagLib::AudioProperties::Fast));
    free(pathToOpen);
  }
}

- (BOOL)removeV1Tag {
  uint32_t counter = 0;
  do {
    mpegFile->strip(TagLib::MPEG::File::ID3v1);
    usleep(10);
    [self refreshTags];
  } while ([self hasV1Tag] && (counter < 10));
  return ![self hasV1Tag];
}

- (void)setPath:(NSString *)newPath {
  if ([path_ isEqualToString:newPath]) {
    return;
  }
  [path_ autorelease];
  path_ = [newPath retain];
  [self refreshTags];
}
@end

