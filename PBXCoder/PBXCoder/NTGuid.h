//
//  NTGuid.h
//  PBXCoder
//
//  Created by Jonny Yu on 6/3/13.
//  Copyright (c) 2013 Jonny Yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreParse/CoreParse.h>

@interface NTGuid : NSObject <CPParseResult>

@property (readwrite, copy, nonatomic) NSString* guid;
@property (readwrite, copy, nonatomic) NSString* comment;

+ (id)guid:(NSString*)guid withComment:(NSString*)comment;
- (id)initWithGuid:(NSString*)guid withComment:(NSString*)comment;

@end
