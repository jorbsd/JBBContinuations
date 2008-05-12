//
//  JBBFSAdditions.h
//  JBBFSAdditions
//
//  Created by Jordan Breeding on 26/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <taglib/mpegfile.h>
#import <taglib/tag.h>

void NSPrintf(NSString *formatString, ...);

@interface NSObject (jbb)
+(BOOL) loadSelector: (SEL) oldSelector asSelector: (SEL) newSelector onlyWhenMissing: (BOOL) loadWhenMissing;
+(BOOL) loadSelector: (SEL) oldSelector asSelector: (SEL) newSelector;
+(BOOL) swapSelector: (SEL) oldSelector withSelector: (SEL) newSelector;
@end

@interface NSArray (utils)
-(id) firstObject;
-(BOOL) isEmpty;
-(NSArray*) dictionariesWithKey: (NSString*) keyName;
-(NSArray*) dictionariesWithKey: (NSString*) keyName fromKeyPath: (NSString*) keyPath;
@end

@interface NSDictionary (utils)
-(NSArray*) dictionariesForKey: (NSString*) keyName;
@end

@interface NSString (utils)
-(void) print;
-(NSNumber*) unpack;
@end

@interface NSValue (utils)
-(NSString*) pack;
@end

@interface NSData (utils)
-(NSString*) pack;
@end

@interface NSAppleEventDescriptor (utils)
-(NSString*) pack;
@end

@interface JBBID3Tag : NSObject {
    @protected
    NSString *_filePath;
    TagLib::MPEG::File *_mpegFile;
}
    
@property(readwrite, copy, getter=filePath, setter=setFilePath) NSString *_filePath;
+(id) tagWithPath: (NSString*) newFilePath;

-(id) init;
-(id) initWithPath: (NSString*) newFilePath;
-(BOOL) hasV1Tag;
-(BOOL) hasV2Tag;
-(BOOL) removeV1Tag;
-(void) closeFile;
@end
