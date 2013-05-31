//
//  PBXGuidToken.m
//  PBXCoder
//
//  Created by Jonny Yu on 5/31/13.
//  Copyright (c) 2013 Jonny Yu. All rights reserved.
//

#import "PBXGuidToken.h"

@implementation PBXGuidToken

+ (id)tokenWithGuid:(NSString *)guid
{
    return [[PBXGuidToken alloc] initWithGuid:guid];
}

- (id)initWithGuid:(NSString*)guid
{
    if (self = [self init]) {
        [self setGuid:guid];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<Guid: %@>", [self guid]];
}

- (NSString *)name
{
    return @"Guid";
}

- (NSUInteger)hash
{
    return [[self guid] hash];
}

- (BOOL)isGuidToken
{
    return YES;
}

- (BOOL)isEqual:(id)object
{
    return ([object isGuidToken] &&
            [[(PBXGuidToken*)object guid] isEqualToString:[self guid]]);
}


@end

@implementation NSObject (PBXGuidToken)

- (BOOL)isGuidToken
{
    return NO;
}

@end