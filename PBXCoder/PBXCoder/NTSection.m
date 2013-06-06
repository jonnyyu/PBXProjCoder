//
//  NTSection.m
//  PBXCoder
//
//  Created by Jonny Yu on 6/6/13.
//  Copyright (c) 2013 Jonny Yu. All rights reserved.
//

#import "NTSection.h"

@implementation NTSection

- (id)initWithSyntaxTree:(CPSyntaxTree *)syntaxTree
{
    self = [self init];
    if (self)
    {
        CPQuotedToken *comment = [syntaxTree valueForTag:@"begin"];
        if (comment) {
            [self setStartComment:[comment content]];
        }
        comment = [syntaxTree valueForTag:@"end"];

        if (comment) {
            [self setEndComment:[comment content]];
        }

        NSArray* items = [syntaxTree childAtIndex:1];
        [self setItems:[NSMutableArray arrayWithCapacity:[items count]]];
        [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [[self items] addObject:[(NSArray*)obj objectAtIndex:0]];
        }];
    }
    return self;
}


+ (id)startComment:(NSString*)startComment endComment:(NSString*)endComment items:(NSArray*)items
{
    return [[NTSection alloc] initWithStartComment:startComment endComment:endComment items:items];
}

- (id)initWithStartComment:(NSString*)startComment endComment:(NSString*)endComment items:(NSArray*)items
{
    self = [self init];
    if (self) {
        [self setStartComment:startComment];
        [self setEndComment:endComment];
        [self setItems:[NSMutableArray arrayWithArray:items]];
    }
    return self;
}

-(NSUInteger)hash
{
    return [[self items] hash];
}

-(NSString *)description
{
    NSMutableString *desc = [NSMutableString stringWithString:@"NTSection: "];
    [desc appendFormat:@"begin=%@, end=%@, items: ", [self startComment], [self endComment]];
    [[self items] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [desc appendFormat:@"%@,", obj];
    }];
    return desc;
}

-(BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[NTSection class]]) {
        NTSection *other = (NTSection*)object;
        return [[other startComment] isEqual:[self startComment]] &&
                [[other endComment] isEqual:[self endComment]] &&
                [[other items] isEqual:[self items]];
    }
    return NO;
}

@end
