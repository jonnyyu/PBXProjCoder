//
//  NTArray.m
//  PBXCoder
//
//  Created by Jonny Yu on 6/3/13.
//  Copyright (c) 2013 Jonny Yu. All rights reserved.
//

#import "NTArray.h"
#import <PBXGuidToken.h>

@implementation NTArray

- (id)initWithSyntaxTree:(CPSyntaxTree *)syntaxTree
{
    self = [super init];
    if (self) {

        self.items = [[NSMutableArray alloc] init];

        NSArray* guids = [syntaxTree childAtIndex:1];
        [guids enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CPSyntaxTree *arrayItem = [obj objectAtIndex:0];
            PBXGuidToken *guid = [arrayItem valueForTag:@"guid"];
            if (guid) {
                [self.items addObject:guid];
            }
            CPIdentifierToken *text = [arrayItem valueForTag:@"text"];
            if (text) {
                [self.items addObject:[text identifier]];
            }
        }];
    }
    return self;
}

+ (id)arrayWithItems:(NSArray*)items
{
    return [[NTArray alloc] initWithItems:items];
}

- (id)initWithItems:(NSArray*)items
{
    self = [self init];
    if (self) {
        [self setItems:[NSMutableArray arrayWithArray:items]];
    }
    return self;
}

- (id)copyWithZone:(NSZone*)zone
{
    return [[NTArray alloc] initWithItems:[self items]];
}

- (NSUInteger)hash
{
    return [[self items] hash];
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[NTArray class]]) {
        return [[self items] isEqual:[(NTArray*)object items]];
    }
    return NO;
}

- (NSString *)description
{
    NSMutableString *desc = [[NSMutableString alloc] initWithString:@" NTArray: "];
    [desc appendString:@"("];
    [[self items] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [desc appendFormat:@" %@,", obj];
    }];
    [desc appendString:@")"];
    return  desc;
}
@end
