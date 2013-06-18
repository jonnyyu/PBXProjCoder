//
//  NTGuidItem.m
//  PBXCoder
//
//  Created by Jonny Yu on 6/5/13.
//  Copyright (c) 2013 Jonny Yu. All rights reserved.
//

#import "NTGuidItem.h"
#import "NTGuid.h"
#import "NTGroup.h"

@implementation NTGuidItem

+ (id)itemWithGuid:(NTGuid*)guid andValue:(id)value
{
    return [[NTGuidItem alloc] initWithGuid:guid andValue:value];
}

- (id)initWithGuid:(NTGuid*)guid andValue:(id)value
{
    self = [self init];
    if (self) {
        [self setGuid:guid];
        [self setValue:value];
    }
    return self;
}

-(id)initWithSyntaxTree:(CPSyntaxTree *)syntaxTree
{
    self = [self init];
    if (self) {
        NTGuid *guid = [syntaxTree valueForTag:@"guid"];
        if (guid) {
            [self setGuid:guid];
        }
        NTGroup *group = [syntaxTree valueForTag:@"group"];
        if (group) {
            [self setValue:group];
        }
    }
    return self;
}

-(NSString *)name
{
    return [[self guid] guid];
}

-(NSUInteger)hash
{
    return [[self guid] hash];
}

-(BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[NTGuidItem class]]) {
        NTGuidItem *other = (NTGuidItem*)object;
        return [[self guid] isEqual:[other guid]] && [[self value] isEqual:[other value]];
    }
    return NO;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"NTGuidItem<%@>: %@", [self guid], [self value]];
}

@end
