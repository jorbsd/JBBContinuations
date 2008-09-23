//
//  JBBFSAdditions.h
//  JBBFSAdditions
//
//  Created by Jordan Breeding on 26/1/08.
//  Copyright 2008 Jordan Breeding. All rights reserved.
//

@interface NSObject (jbb)
+(BOOL) loadSelector: (SEL)oldSelector asSelector: (SEL)newSelector onlyWhenMissing: (BOOL)loadWhenMissing;
+(BOOL) loadSelector: (SEL)oldSelector asSelector: (SEL)newSelector;
+(BOOL) swapSelector: (SEL)oldSelector withSelector: (SEL)newSelector;
@end

@interface NSArray (utils)
-(id) firstObject;
-(BOOL) isEmpty;
-(NSArray*) dictionariesWithKey: (NSString*)keyName;
-(NSArray*) dictionariesWithKey: (NSString*)keyName fromKeyPath: (NSString*)keyPath;
@end

@interface NSDictionary (utils)
-(NSArray*) dictionariesForKey: (NSString*)keyName;
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

//make the compiler happy for public use of the Framework
namespace TagLib {
    namespace MPEG {
        class File;
    }
}

@interface JBBID3Tag : NSObject {
@protected
    NSString *filePath;
    TagLib::MPEG::File *mpegFile;
}

@property (retain) NSString *filePath;
+(id) tagWithPath: (NSString*)newFilePath;

-(id) init;
-(id) initWithPath: (NSString*)newFilePath;
-(void) dealloc;
-(void) finalize;

-(BOOL) hasV1Tag;
-(BOOL) hasV2Tag;
-(BOOL) removeV1Tag;
@end
