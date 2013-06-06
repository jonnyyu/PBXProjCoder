//
//  PBXNTGroup.m
//  PBXCoder
//
//  Created by Jonny Yu on 5/31/13.
//  Copyright (c) 2013 Jonny Yu. All rights reserved.
//

#import "NTDocument.h"
#import "NTGroup.h"

@implementation NTDocument

- (id)initWithItems:(NSArray*)items
{
    self = [self init];
    if (self) {
        [self setItems:[NSMutableArray arrayWithArray:items]];
    }
    return self;
}

- (id)initWithSyntaxTree:(CPSyntaxTree*)syntaxTree
{
    self = [self init];
    if (self) {
        NTGroup *content = [syntaxTree valueForTag:@"content"];
        [self setItems:[content items]];
    }
    return self;
}

-(NSUInteger)hash
{
    return [[self items] hash];
}

- (BOOL)isEqual:(id)object
{
    if ([self isKindOfClass:[NTDocument class]]) {
        return [[(NTDocument*)object items] isEqualToArray:[self items]];
    }
    return NO;
}

- (NSString *)description
{
    int count = (int)[[self items] count];
    NSMutableString *desc = [NSMutableString stringWithFormat:@"NTDocument(%d)", count];
    [[self items] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [desc appendFormat:@", [%@]", [obj description]];
    }];
    return desc;
}

@end
