//
//  NTMetaItem.m
//  PBXCoder
//
//  Created by Jonny Yu on 6/6/13.
//  Copyright (c) 2013 Jonny Yu. All rights reserved.
//

#import "NTMetaItem.h"
#import "NTItem.h"

@implementation NTMetaItem

-(id)initWithSyntaxTree:(CPSyntaxTree *)syntaxTree
{
    self = [self init];
    if (self) {
        NTItem* item = [syntaxTree valueForTag:@"item"];
        if (item) {
            [self setItem:item];
        }
        item = [syntaxTree valueForTag:@"guidItem"];
        if (item) {
            [self setItem:item];
        }
    }
    return self;
}

-(NSUInteger)hash
{
    return [[self item] hash];
}

-(BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[NTMetaItem class]]) {
        return [[self item] isEqual:[(NTMetaItem*)object item]];
    }
    return NO;
}

-(NSString *)description
{
    return [NSMutableString stringWithFormat:@"NTMetaItem: %@", [self item]];
}

@end
