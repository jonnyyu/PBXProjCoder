//
//  NTSection.h
//  PBXCoder
//
//  Created by Jonny Yu on 6/6/13.
//  Copyright (c) 2013 Jonny Yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreParse/CoreParse.h>

@interface NTSection : NSObject <CPParseResult>

@property (readwrite, retain, nonatomic) NSString *startComment;
@property (readwrite, retain, nonatomic) NSString *endComment;
@property (readwrite, retain, nonatomic) NSMutableArray *items;

+ (id)startComment:(NSString*)startComment endComment:(NSString*)endComment items:(NSArray*)items;
- (id)initWithStartComment:(NSString*)startComment endComment:(NSString*)endComment items:(NSArray*)items;

@end
