//
//  NTContent.m
//  PBXCoder
//
//  Created by Jonny Yu on 6/6/13.
//  Copyright (c) 2013 Jonny Yu. All rights reserved.
//

#import "NTGroup.h"
#import "NTMetaItem.h"
#import "NTSection.h"

@implementation NTGroup
-(id)initWithSyntaxTree:(CPSyntaxTree *)syntaxTree
{
    if (self) {

        [self setItems:[NSMutableArray arrayWithCapacity:[[syntaxTree children] count]]];

        NSArray* items = [syntaxTree childAtIndex:1];
        [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[NSArray class]]) {
                id t = [(NSArray*)obj objectAtIndex:0];
                if ([t isKindOfClass:[NTMetaItem class]])
                {
                    [[self items] addObject:[(NTMetaItem*)t item]];
                }
                if ([t isKindOfClass:[NTSection class]])
                {
                    [[self items] addObject:t];
                }
            }
        } ];
    }
    return self;
}

+ (id)groupWithItems:(NSArray *)items
{
    return [[NTGroup alloc] initWithItems:items];
}

- (id)initWithItems:(NSArray*)items
{
    self = [self init];
    if (self) {
        self.items = [NSMutableArray arrayWithArray:items];
    }
    return self;
}

- (id)copyWithZone:(NSZone*)zone
{
    return [[NTGroup alloc] initWithItems:[self items]];
}

-(NSUInteger)hash
{
    return [[self items] hash];
}

-(BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[NTGroup class]]) {
        return [[self items] isEqual:[(NTGroup*)object items]];
    }
    return NO;
}

-(NSString *)description
{
    NSMutableString* desc = [NSMutableString stringWithString:@"NTContent: "];
    [[self items] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [desc appendFormat:@" %@,", obj];
    }];
    return desc;
}

@end
