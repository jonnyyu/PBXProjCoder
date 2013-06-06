//
//  NTItem.m
//  PBXCoder
//
//  Created by Jonny Yu on 5/31/13.
//  Copyright (c) 2013 Jonny Yu. All rights reserved.
//

#import "NTItem.h"
#import "NTGuid.h"
#import "NTArray.h"
#import "NTGroup.h"

@implementation NTItem

+ (id)itemWithName:(NSString*)name andValue:(id)value
{
    return [[NTItem alloc] initWithName:name andValue:value];
}

- (id)initWithName:(NSString*)name andValue:(id)value
{
    self = [self init];
    if (self) {
        [self setName:name];
        [self setValue:value];
    }
    return self;
}

- (id)initWithSyntaxTree:(CPSyntaxTree*)syntaxTree
{
    self = [self init];
    if (self)
    {
        CPIdentifierToken *name = [syntaxTree valueForTag:@"name"];
        [self setName:[name identifier]];

        CPNumberToken     *num  = [syntaxTree valueForTag:@"num"];
        if (num) {
            [self setValue:[num number]];
        }

        CPIdentifierToken *identifier = [syntaxTree valueForTag:@"text"];
        if (identifier) {
            [self setValue:[identifier identifier]];
        }
        CPQuotedToken *quoted = [syntaxTree valueForTag:@"quotedText"];
        if (quoted) {
            [self setValue:[quoted content]];
        }


        NTGuid *guid = [syntaxTree valueForTag:@"guid"];
        if (guid) {
            [self setValue:guid];
        }

        NTArray* guids = [syntaxTree valueForTag:@"guids"];
        if (guids) {
            [self setValue:guids];
        }

        NTGroup* group = [syntaxTree valueForTag:@"group"];
        if (group) {
            [self setValue:group];
        }

    }
    return  self;
}

- (NSUInteger)hash
{
    return [[self name] hash];
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[NTItem class]])
    {
        NTItem *other = (NTItem*)object;
        return [[other name] isEqualToString:[self name]] && [[other value] isEqualTo:[self value]];
    }
    return NO;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"NTItem: %@ = %@", [self name], [self value]];
}

@end
