//
//  PBXPathToken.m
//  PBXCoder
//
//  Created by Jonny Yu on 5/31/13.
//  Copyright (c) 2013 Jonny Yu. All rights reserved.
//

#import "PBXPathToken.h"

@implementation PBXPathToken

+ (id)tokenWithPath:(NSString*)path
{
    return [[PBXPathToken alloc] initWithPath:path];
}

- (id)initWithPath:(NSString*)path
{
    if (self = [self init])
    {
        [self setPath:path];
    }
    return self;
}

- (BOOL)isPathToken
{
    return YES;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<Path: %@>", [self path]];
}

- (NSString *)name
{
    return @"Path";
}

- (NSUInteger)hash
{
    return [[self path] hash];
}


- (BOOL)isEqual:(id)object
{
    return ([object isPathToken] &&
            [[(PBXPathToken*)object path] isEqualToString:[self path]]);
}

@end

@implementation NSObject (PBXPathToken)

- (BOOL)isPathToken
{
    return NO;
}

@end