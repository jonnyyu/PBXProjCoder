//
//  PBXGuidToken.h
//  PBXCoder
//
//  Created by Jonny Yu on 5/31/13.
//  Copyright (c) 2013 Jonny Yu. All rights reserved.
//

#import <CoreParse/CoreParse.h>

@interface PBXGuidToken : CPToken

@property (readwrite, copy, nonatomic) NSString* guid;

+ (id)tokenWithGuid:(NSString*)guid;

- (id)initWithGuid:(NSString*)guid;

- (BOOL)isGuidToken;

@end

@interface NSObject (PBXGuidToken)

- (BOOL)isGuidToken;

@end
