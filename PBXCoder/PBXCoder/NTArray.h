//
//  NTArray.h
//  PBXCoder
//
//  Created by Jonny Yu on 6/3/13.
//  Copyright (c) 2013 Jonny Yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreParse/CoreParse.h>


@interface NTArray : NSObject <CPParseResult>

@property (readwrite, retain, nonatomic) NSMutableArray* items;

+ (id)arrayWithItems:(NSArray*)items;
- (id)initWithItems:(NSArray*)items;

@end
