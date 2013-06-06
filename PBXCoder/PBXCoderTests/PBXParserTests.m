//
//  PBXParserTests.m
//  PBXCoder
//
//  Created by Jonny Yu on 5/31/13.
//  Copyright (c) 2013 Jonny Yu. All rights reserved.
//

#import "PBXParserTests.h"
#import <PBXCoder/NTDocument.h>
#import <PBXCoder/NTItem.h>
#import <PBXCoder/NTArray.h>
#import <PBXCoder/NTGuid.h>
#import <PBXCoder/NTGuidItem.h>
#import <PBXCoder/NTSection.h>

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
    NTDocument *a = [parser parse:[self tokenise:@"// !$*UTF8*$!{}"]];
    NTDocument *e = [[NTDocument alloc] initWithItems:@[]];

    STAssertEqualObjects(a,e,@"failed to parse empty document ", nil);
}

- (void)testCanParseAssignInteger
{
    NTDocument *a = [parser parse:[self tokenise:@"// !$*UTF8*$!{ archiveVersion = 1;}"]];
    NTDocument *e = [[NTDocument alloc] initWithItems:@[
                     [NTItem itemWithName:@"archiveVersion" andValue:[NSNumber numberWithInteger:1]]
                     ]];

    STAssertEqualObjects(a, e, @"failed to parse single assign integer", nil);
}

- (void)testCanParseAssignText
{
    NTDocument *a = [parser parse:[self tokenise:@"// !$*UTF8*$!{ isa = PBXAggregateTarget; }"]];
    NTDocument *e = [[NTDocument alloc] initWithItems:@[
                     [NTItem itemWithName:@"isa" andValue:@"PBXAggregateTarget"]]];

    STAssertEqualObjects(a, e, @"failed to parse single assign text", nil);
}

- (void)testCanParseAssignQuotedText
{
    NTDocument *a = [parser parse:[self tokenise:@"// !$*UTF8*$!{ name = \"Working Subset\"; }"]];
    NTDocument *e = [[NTDocument alloc] initWithItems:@[
                     [NTItem itemWithName:@"name" andValue:@"Working Subset"]]];

    STAssertEqualObjects(a, e, @"failed to parse assign quoted text", nil);
}

- (void)testCanParseAssignGuid
{
    NTDocument *a = [parser parse:[self tokenise:@"// !$*UTF8*$!{ containerPortal = C24F41A1126C139500B13AF3 /* Components.xcodeproj */; }"]];
    NTDocument *e = [[NTDocument alloc] initWithItems:@[
                     [NTItem itemWithName:@"containerPortal" andValue:[NTGuid guid:@"C24F41A1126C139500B13AF3" withComment:@" Components.xcodeproj "]]]];

    STAssertEqualObjects(a, e, @"failed to parse assign quoted text", nil);
}

- (void)testCanParseMultiItems
{
    NTDocument *a = [parser parse:[self tokenise:@"// !$*UTF8*$!{ archiveVersion = 1; objectVersion = 45; }"]];
    NTDocument *e = [[NTDocument alloc] initWithItems:@[
                     [NTItem itemWithName:@"archiveVersion" andValue:[NSNumber numberWithInteger:1]],
                     [NTItem itemWithName:@"objectVersion" andValue:[NSNumber numberWithInteger:45]]
                     ]];

    STAssertEqualObjects(a, e, @"failed to parse single assign integer", nil);
}

- (void)testCanParseGuidArray
{
    NTDocument *a = [parser parse:[self tokenise:@"// !$*UTF8*$!{ dependencies = (C24F41AC126C13B400B13AF3 /* PBXTargetDependency */,\n"
                                                                                @"C2BF933D12766F31002D05BB /* PBXTargetDependency */,\n); }"]];
    NTDocument *e = [[NTDocument alloc] initWithItems:@[
                     [NTItem itemWithName:@"dependencies"
                                 andValue:[NTArray arrayWithItems:@[
                                           [NTGuid guid:@"C24F41AC126C13B400B13AF3" withComment:@" PBXTargetDependency "],
                                           [NTGuid guid:@"C2BF933D12766F31002D05BB" withComment:@" PBXTargetDependency "]
                                          ]]
                      ]]];

    STAssertEqualObjects(a, e, @"failed to parse guid array");
}

- (void)testCanParseEmptyArray
{
    NTDocument *a = [parser parse:[self tokenise:@"// !$*UTF8*$!{ dependencies = (); }"]];
    NTDocument *e = [[NTDocument alloc] initWithItems:@[
                     [NTItem itemWithName:@"dependencies" andValue:[NTArray arrayWithItems:@[]]]]];

    STAssertEqualObjects(a, e, @"failed to parse empty array");
}

- (void)testCanParseNestGroup
{
    NTDocument *a = [parser parse:[self tokenise:@"// !$*UTF8*$! { classes = { objectVersion = 45; }; }"]];

    NTGroup     *g = [NTGroup groupWithItems:@[
                      [NTItem itemWithName:@"objectVersion" andValue:[NSNumber numberWithInteger:45]]]];
    NTDocument *e = [[NTDocument alloc] initWithItems:@[
                     [NTItem itemWithName:@"classes" andValue:g]]];


    STAssertEqualObjects(a, e, @"failed to parse nested group");
}

- (void)testCanParsePath
{
    NTDocument *a = [parser parse:[self tokenise:@"// !$*UTF8*$!{ path = ../../testdev/testdev.xcodeproj; }"]];
    NTDocument *e = [[NTDocument alloc] initWithItems:@[
                     [NTItem itemWithName:@"path" andValue:@"../../testdev/testdev.xcodeproj" ]]];

    STAssertEqualObjects(a, e, @"failed to parse path");
}

- (void)testCanParseSection
{
    NTDocument *a = [parser parse:[self tokenise:@" \
// !$*UTF8*$! {  \
    objects = { \
        /* Begin PBXTargetDependency section */   \
            1DCBBA3512A6F908006446DA /* PBXTargetDependency */ = { \
                name = ARXHarness; \
            }; \
        /* End PBXTargetDependency section */  \
    }; \
}"]];

    NTDocument *e = [[NTDocument alloc] initWithItems:@[
                       [NTItem itemWithName:@"objects" andValue:[NTGroup groupWithItems:@[
                           [NTSection startComment:@" Begin PBXTargetDependency section "
                                        endComment:@" End PBXTargetDependency section "
                                             items:@[
                               [NTGuidItem itemWithGuid:[NTGuid guid:@"1DCBBA3512A6F908006446DA" withComment:@" PBXTargetDependency "]
                                               andValue:[NTGroup groupWithItems:@[[NTItem itemWithName:@"name" andValue:@"ARXHarness"],]]],]],]]],]];
    STAssertEqualObjects(a, e, @"failed to parse section");
}

- (void)testCanParseSectionMixed
{
     NTDocument *a = [parser parse:[self tokenise:@" \
// !$*UTF8*$! {  \
objectVersion = 45; \
/* Begin PBXTargetDependency section */   \
    1DCBBA3512A6F908006446DA /* PBXTargetDependency */ = { \
        name = ARXHarness; \
    }; \
/* End PBXTargetDependency section */  \
archiveVersion = 1; \
}"]];

    NTDocument *e = [[NTDocument alloc] initWithItems:@[
                       [NTItem itemWithName:@"objectVersion" andValue:[NSNumber numberWithInteger:45]],
                       [NTSection startComment:@" Begin PBXTargetDependency section "
                                               endComment:@" End PBXTargetDependency section "
                                                    items:@[
                            [NTGuidItem itemWithGuid:[NTGuid guid:@"1DCBBA3512A6F908006446DA" withComment:@" PBXTargetDependency "]
                                            andValue:[NTGroup groupWithItems:@[
                                [NTItem itemWithName:@"name" andValue:@"ARXHarness"]]]]]],
                       [NTItem itemWithName:@"archiveVersion" andValue:[NSNumber numberWithInteger:1]]
                     ]];
    STAssertEqualObjects(a, e, @"failed to parse mixed section");
}

- (void)testCanParseTextArray
{
    NTDocument *a = [parser parse:[self tokenise:@"// !$*UTF8*$! { knownRegions = (English,Japanese,French,German,); }"]];
    NTDocument *e = [[NTDocument alloc] initWithItems:@[
                     [NTItem itemWithName:@"knownRegions" andValue:[NTArray arrayWithItems:@[
                      @"English", @"Japanese", @"French", @"German"]]]]];

    STAssertEqualObjects(a, e, @"failed to parse text array");
}

- (void)testCanParseReferenceItem
{
    NTDocument *a = [parser parse:[self tokenise:@"// !$*UTF8*$! { C26D495910F1E3D200BD5833 /* Debug */ = { name = Debug; }; }"]];
    NTDocument *e = [[NTDocument alloc] initWithItems:@[
                     [NTGuidItem itemWithGuid:[NTGuid guid:@"C26D495910F1E3D200BD5833" withComment:@" Debug "]
                                     andValue:[NTGroup groupWithItems:@[[NTItem itemWithName:@"name" andValue:@"Debug"]]]]]];
    STAssertEqualObjects(a, e, @"failed to parse reference item");
}
@end
