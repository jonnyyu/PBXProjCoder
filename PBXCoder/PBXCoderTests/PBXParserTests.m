//
//  PBXParserTests.m
//  PBXCoder
//
//  Created by Jonny Yu on 5/31/13.
//  Copyright (c) 2013 Jonny Yu. All rights reserved.
//

#import "PBXParserTests.h"


@implementation PBXParserTests

- (void)setUp
{
    [super setUp];

    // Set-up code here.
    parser = [[PBXParser alloc] init];
}

- (CPTokenStream*)tokenise:(NSString*)text
{
    PBXTokeniser *tokeniser = [[PBXTokeniser alloc] init];
    return [tokeniser tokenise:text];
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}

- (void)testCanParseEmptyDocument
{
    

}

@end
