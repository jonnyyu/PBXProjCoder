//
//  PBXCoder.m
//  PBXCoder
//
//  Created by Jonny Yu on 5/31/13.
//  Copyright (c) 2013 Jonny Yu. All rights reserved.
//

#import "PBXArchiver.h"
#import "PBXParser.h"
#import "NTDocument.h"
#import "NTItem.h"

@implementation PBXArchiver

@end

@interface PBXSubUnarchiver : NSCoder {
    NSArray *_items;
}

-(id)initWithSubItems:(NSArray*)items;

@end

@implementation PBXSubUnarchiver

-(id)initWithSubItems:(NSArray *)items
{
    self = [self init];
    if (self) {
        _items = items;
    }
    return self;
}

@end

@implementation PBXUnarchiver

+(id)unarchiveObjectFromData:(NSData*)data
{
    PBXUnarchiver *unarchiver = [[PBXUnarchiver alloc] initForReadingWithData:data];
    id obj = [unarchiver decodeObjectForKey:@"rootObject"];
    return obj;
}

+(id)unarchiveObjectFromFile:(NSString*)path
{
    return [PBXUnarchiver unarchiveObjectFromData:[NSData dataWithContentsOfFile:path]];
}

-(id)initForReadingWithData:(NSData*)data
{
    if (self = [self init]) {
        _data = data;

        NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF32StringEncoding];
        PBXTokeniser *tokeniser = [[PBXTokeniser alloc] init];
        PBXParser *parser = [[PBXParser alloc] init];
        _doc = [parser parse:[tokeniser tokenise:text]];

        NTItem *archiveVersion = [_doc itemWithName:@"archiveVersion"];
        NTItem *objectVersion  = [_doc itemWithName:@"objectVersion"];

        _archiveVersion = [[archiveVersion value] intValue];
        _objectVersion  = [[objectVersion value] intValue];
    }
    return self;
}

-(NSDictionary*)dictionaryFromGroup:(NTGroup*)group
{
    __block NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:[[group items] count]];
    [[group items] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NTItem* item = (NTItem*)obj;
        [dict setValue:[item value] forKey:[item name]];
    }];
    return dict;
}

-(id)decodeItem:(NTItem*)item
{
    if (![[item value] isGroup])
        return [item value];

    NTGroup *group = [item value];
    NTItem *classItem = [group itemWithName:@"isa"];
    id obj;
    if (classItem) {
        Class cls = NSClassFromString([classItem value]);
        obj = [[cls alloc] initWithCoder:self];
        return obj;
    }
    else {
        return [self dictionaryFromGroup:group];
    }
}

// So there're two situations:
// 1. when I met a { } that doesn't have 'isa' attribute, I should fill a NSDictionary
// 2. when I met a { } that has a 'isa' attribute, I should init that object.
// 3. when filling each attribute, need repeat the step 1 or 2.

-(id)decodeObjectForKey:(NSString *)key
{
    NTItem *item = [_doc itemWithName:key];
    return item ? [self decodeItem:item] : nil;
}


-(int)decodeIntForKey:(NSString*)key
{
    NTItem* item = [_doc itemWithName:key];
    if (item) {
        return [[item value] intValue];
    }
    //FIXME:find which exception should be thrown.
    return NSNotFound;
}

@end
