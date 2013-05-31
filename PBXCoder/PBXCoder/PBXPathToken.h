//
//  PBXPathToken.h
//  PBXCoder
//
//  Created by Jonny Yu on 5/31/13.
//  Copyright (c) 2013 Jonny Yu. All rights reserved.
//

#import <CoreParse/CoreParse.h>

@interface PBXPathToken : CPToken

@property (readwrite, copy, nonatomic) NSString *path;

+ (id)tokenWithPath:(NSString*)path;

- (id)initWithPath:(NSString*)path;

- (BOOL)isPathToken;

@end

@interface NSObject (PBXPathToken)

- (BOOL)isPathToken;

@end
