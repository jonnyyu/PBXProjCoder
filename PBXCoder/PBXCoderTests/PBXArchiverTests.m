//
//  PBXCoderTests.m
//  PBXCoderTests
//
//  Created by Jonny Yu on 5/31/13.
//  Copyright (c) 2013 Jonny Yu. All rights reserved.
//

#import "PBXArchiverTests.h"
#import <PBXCoder/PBXArchiver.h>
#import <PBXCoder/PBXProject.h>
#import <PBXCoder/PBXTargetDependency.h>

@implementation PBXArchiverTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}

- (PBXUnarchiver*)unarchiverWithString:(NSString*)text
{
    return [[PBXUnarchiver alloc] initForReadingWithData:[text dataUsingEncoding:NSUTF32StringEncoding]];
}

- (void)testDecodeIntForKey
{
    ua = [self unarchiverWithString:@"// !$*UTF8*$! { archiveVersion = 567; }"];
    int a = [ua decodeIntForKey:@"archiveVersion"];
    int e = 567;

    XCTAssertEquals(a, e, @"failed to decode int");
}

- (void)testDecodeNonEmptyDictionary
{
    ua = [self unarchiverWithString:@"// !$*UTF8*$! { objects = { archiveVersion = 1; }; }"];
    NSDictionary *a = [ua decodeObjectForKey:@"objects"];
    NSDictionary *e = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:1], @"archiveVersion", nil];
    XCTAssertEqualObjects(a, e, @"failed to decode a group");
}

- (void)testDecodeAnObjectValue
{
    ua = [self unarchiverWithString:@" \
// !$*UTF8*$! \
{  \
    object = { \
      isa = PBXTargetDependency; \
      name = ARXHarness; \
    }; \
}"];

    id a = [ua decodeObjectForKey:@"object"];
    PBXTargetDependency *e = [[PBXTargetDependency alloc] init];
    [e setName:@"ARXHarness"];
    XCTAssertEqualObjects(a, e, @"failed to decode an object");
}

//- (void)testCanUnarchiveEmptyDocument
//{
//    PBXProject *a = [PBXUnarchiver unarchiveObjectFromData:[self data:@"// !$*UTF8*$! { archiveVersion = 1; }"]];
//
//    PBXProject *e = [[PBXProject alloc] init];
//    [e setArchiveVersion:1];
//    [e setObjectVersion:45];
//
//    STAssertEqualObjects(a, e, @"failed to parse empty document");
//}


@end
