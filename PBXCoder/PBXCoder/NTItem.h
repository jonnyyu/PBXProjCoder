//
//  NTItem.h
//  PBXCoder
//
//  Created by Jonny Yu on 5/31/13.
//  Copyright (c) 2013 Jonny Yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreParse/CoreParse.h>

@interface NTItem : NSObject <CPParseResult>

@property (readwrite, copy, nonatomic) NSString *name;
@property (readwrite, copy, nonatomic) id        value;

+ (id)itemWithName:(NSString*)name andValue:(id)value;
- (id)initWithName:(NSString*)name andValue:(id)value;

@end
