//
//  NTGuid.m
//  PBXCoder
//
//  Created by Jonny Yu on 6/3/13.
//  Copyright (c) 2013 Jonny Yu. All rights reserved.
//

#import "NTGuid.h"
#import <PBXGuidToken.h>

@implementation NTGuid

+ (id)guid:(NSString*)guid withComment:(NSString*)comment
{
    return [[NTGuid alloc] initWithGuid:guid withComment:comment];
}

- (id)initWithGuid:(NSString*)guid withComment:(NSString*)comment
{
    self = [self init];
    if (self) {
        [self setGuid:guid];
        [self setComment:comment];
    }
    return self;
}

- (id)initWithSyntaxTree:(CPSyntaxTree *)syntaxTree
{
    self = [self init];
    if (self) {
        PBXGuidToken *guidToken = [syntaxTree valueForTag:@"guid"];
        if (guidToken) {
            [self setGuid:[guidToken guid]];
        }

        CPQuotedToken *comment = [syntaxTree valueForTag:@"comment"];
        if (comment) {
            [self setComment:[comment content]];
        }
    }
    return self;
}

-(id)copyWithZone:(NSZone*)zone
{
    return [[NTGuid alloc] initWithGuid:[self guid] withComment:[self comment]];
}

-(NSUInteger)hash
{
    return [[self guid] hash];
}

-(BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[self class]])
    {
        return [[self guid] isEqual:[(NTGuid*)object guid]];
    }
    return NO;
}

@end
