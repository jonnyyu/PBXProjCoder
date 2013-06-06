//
//  NTGroup.h
//  PBXCoder
//
//  Created by Jonny Yu on 6/6/13.
//  Copyright (c) 2013 Jonny Yu. All rights reserved.
//
#pragma once

#import <Foundation/Foundation.h>
#import <CoreParse/CoreParse.h>

@interface NTGroup : NSObject <CPParseResult>

@property (readwrite, retain, nonatomic) NSMutableArray *items;

+ (id)groupWithItems:(NSArray*) items;

- (id)initWithItems:(NSArray*)items;

@end
