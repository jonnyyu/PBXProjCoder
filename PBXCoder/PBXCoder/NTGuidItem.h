//
//  NTGuidItem.h
//  PBXCoder
//
//  Created by Jonny Yu on 6/5/13.
//  Copyright (c) 2013 Jonny Yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreParse/CoreParse.h>

@class NTGuid;

@interface NTGuidItem : NSObject <CPParseResult>

@property (readwrite, retain, nonatomic) NTGuid *guid;
@property (readwrite, retain, nonatomic) id      value;

+ (id)itemWithGuid:(NTGuid*)guid andValue:(id)value;
- (id)initWithGuid:(NTGuid*)guid andValue:(id)value;

@end
