//
//  NTMetaItem.h
//  PBXCoder
//
//  Created by Jonny Yu on 6/6/13.
//  Copyright (c) 2013 Jonny Yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreParse/CoreParse.h>

@class NTItem;

@interface NTMetaItem : NSObject <CPParseResult>

@property (readwrite, retain, nonatomic) NTItem *item;

@end
