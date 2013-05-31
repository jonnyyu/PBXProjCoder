//
//  PBXPathRecogniser.m
//  PBXCoder
//
//  Created by Jonny Yu on 5/31/13.
//  Copyright (c) 2013 Jonny Yu. All rights reserved.
//

#import "PBXPathRecogniser.h"

@implementation PBXPathRecogniser

+ (id)pathRecogniser
{
    return [[PBXPathRecogniser alloc] init];
}

- (id)init
{
    NSMutableCharacterSet* filePathCharacters = [[NSMutableCharacterSet alloc] init];
    [filePathCharacters addCharactersInString:@"./\\$"];
    [filePathCharacters formUnionWithCharacterSet:[NSCharacterSet alphanumericCharacterSet]];
    self = [super initWithInitialCharacters:filePathCharacters identifierCharacters:filePathCharacters];
    return self;
}

@end
