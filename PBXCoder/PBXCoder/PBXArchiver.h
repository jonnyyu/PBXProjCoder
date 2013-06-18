//
//  PBXCoder.h
//  PBXCoder
//
//  Created by Jonny Yu on 5/31/13.
//  Copyright (c) 2013 Jonny Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBXArchiver : NSCoder

@end

@interface PBXUnarchiver : NSCoder {
    id _data;
    id _doc;
    int _archiveVersion;
    int _objectVersion;
}

-(id)initForReadingWithData:(NSData*)data;

+(id)unarchiveObjectFromData:(NSData*)data;
+(id)unarchiveObjectFromFile:(NSString*)path;

-(int)decodeIntForKey:(NSString*)key;

@end
