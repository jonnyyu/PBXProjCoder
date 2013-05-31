//
//  PBXTokeniserTests.m
//  PBXCoder
//
//  Created by Jonny Yu on 5/31/13.
//  Copyright (c) 2013 Jonny Yu. All rights reserved.
//

#import "PBXTokeniserTests.h"
#import <CoreParse/CoreParse.h>

#import <PBXCoder/PBXParser.h>
#import <PBXCoder/PBXGuidToken.h>

@interface PBXTokens : NSObject
@end

@implementation PBXTokens
+ (CPKeywordToken*)docHeader
{
    return [CPKeywordToken tokenWithKeyword:@"// !$*UTF8*$!"];
}
+ (CPKeywordToken*)leftBrace
{
    return [CPKeywordToken tokenWithKeyword:@"{"];
}
+ (CPKeywordToken*)rightBrace
{
    return [CPKeywordToken tokenWithKeyword:@"}"];
}
+ (CPKeywordToken*)equal
{
    return [CPKeywordToken tokenWithKeyword:@"="];
}
+ (CPKeywordToken*)number:(NSNumber*)n
{
    return [CPNumberToken tokenWithNumber:n];
}
+ (CPIdentifierToken*)identifier:(NSString*)name
{
    return [CPIdentifierToken tokenWithIdentifier:name];
}
+ (CPKeywordToken*)end
{
    return [CPKeywordToken tokenWithKeyword:@";"];
}
+ (CPToken*)comment:(NSString*)text
{
    return [CPQuotedToken content:text quotedWith:@"/*" name:@"Comment"];
}
+ (CPToken*)quotedText:(NSString*)text
{
    return [CPQuotedToken content:text quotedWith:@"\"" name:@"QuotedText"];
}
+ (CPToken*)guid:(NSString*)text
{
    return [PBXGuidToken tokenWithGuid:text];
}
+ (CPToken*)leftParentheses
{
    return [CPKeywordToken tokenWithKeyword:@"("];
}
+ (CPToken*)rightParentheses
{
    return [CPKeywordToken tokenWithKeyword:@")"];
}
+ (CPToken*)comma
{
    return [CPKeywordToken tokenWithKeyword:@","];
}
@end


@implementation PBXTokeniserTests

- (void)setUp
{
    [super setUp];

    // Set-up code here.
    tokeniser = [[PBXTokeniser alloc] init];
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}

- (void)testCanTokeniseDocHeader
{
    CPTokenStream *a = [tokeniser tokenise:@"// !$*UTF8*$!"];
    CPTokenStream *e = [CPTokenStream tokenStreamWithTokens:@[
                        [PBXTokens docHeader],
                        [CPEOFToken eof]]];

    STAssertEqualObjects(a, e, @"Failed to tokenise DocHeader correctly", nil);
}

- (void)testCanTokeniseEmptyDoc
{
    CPTokenStream *a = [tokeniser tokenise:@"// !$*UTF8*$!\n{\n}"];
    CPTokenStream *e = [CPTokenStream tokenStreamWithTokens:@[
                        [PBXTokens docHeader],
                        [PBXTokens leftBrace],
                        [PBXTokens rightBrace],
                        [CPEOFToken eof]]];

    STAssertEqualObjects(a, e, @"Failed to tokenise an empty document", nil);
}

- (void)testCanTokeniseAssignAnNumber
{
    CPTokenStream *a = [tokeniser tokenise:@"  archiveVersion = 1;\n"];
    CPTokenStream *e = [CPTokenStream tokenStreamWithTokens:@[
                        [PBXTokens identifier:@"archiveVersion"],
                        [PBXTokens equal],
                        [PBXTokens number:[NSNumber numberWithInteger:1]],
                        [PBXTokens end],
                        [CPEOFToken eof]]];

    STAssertEqualObjects(a, e, @"Failed to tokenise assign number", nil);
}

- (void)testCanTokeniseComment
{
    CPTokenStream *a = [tokeniser tokenise:@"/* This is a comment */"];
    CPTokenStream *e = [CPTokenStream tokenStreamWithTokens:@[
                        [PBXTokens comment:@" This is a comment "],
                        [CPEOFToken eof]]];

    STAssertEqualObjects(a, e, @"Failed to tokenise comment", nil);
}

- (void)testCanTokeniseAssignAnQuotedString
{
    CPTokenStream *a = [tokeniser tokenise:@"  productName = \"Build Acx\";"];
    CPTokenStream *e = [CPTokenStream tokenStreamWithTokens:@[
                        [PBXTokens identifier:@"productName"],
                        [PBXTokens equal],
                        [PBXTokens quotedText:@"Build Acx"],
                        [PBXTokens end],
                        [CPEOFToken eof]]];

    STAssertEqualObjects(a, e, @"Failed to tokenise string assignment", nil);
}

- (void)testCanTokeniseEmptyQuotedString
{
    CPTokenStream *a = [tokeniser tokenise:@"  productName = \"\";"];
    CPTokenStream *e = [CPTokenStream tokenStreamWithTokens:@[
                        [PBXTokens identifier:@"productName"],
                        [PBXTokens equal],
                        [PBXTokens quotedText:@""],
                        [PBXTokens end],
                        [CPEOFToken eof]]];

    STAssertEqualObjects(a, e, @"Failed to tokenise empty quoted string", nil);
}

- (void)testCanTokeniseGuid
{
    CPTokenStream *a = [tokeniser tokenise:@" containerPortal = 1DCBB41C12A6F38D006446DA /* ARXHarness.xcodeproj */;"];
    CPTokenStream *e = [CPTokenStream tokenStreamWithTokens:@[
                        [PBXTokens identifier:@"containerPortal"],
                        [PBXTokens equal],
                        [PBXTokens guid:@"1DCBB41C12A6F38D006446DA"],
                        [PBXTokens comment:@" ARXHarness.xcodeproj "],
                        [PBXTokens end],
                        [CPEOFToken eof]]];

    STAssertEqualObjects(a, e, @"Failed to tokenise Guid assignment", nil);
}

- (void)testCanTokenisePath
{
    CPTokenStream *a = [tokeniser tokenise:@"path = ../../../../../components/Platform/OSX/xconfigs/LLVMDebugLeopardOrLater64bits.xcconfig;"];
    CPTokenStream *e = [CPTokenStream tokenStreamWithTokens:@[
                        [PBXTokens identifier:@"path"],
                        [PBXTokens equal],
                        [PBXTokens identifier:@"../../../../../components/Platform/OSX/xconfigs/LLVMDebugLeopardOrLater64bits.xcconfig"],
                        [PBXTokens end],
                        [CPEOFToken eof]]];

    STAssertEqualObjects(a, e, @"Failed to tokenise path", nil);
}

- (void)testCanTokenisePathWithEnvironmentVariables
{
    CPTokenStream *a = [tokeniser tokenise:@"path = $UTBIN/rereg\\noptimize.bsh;"];
    CPTokenStream *e = [CPTokenStream tokenStreamWithTokens:@[
                        [PBXTokens identifier:@"path"],
                        [PBXTokens equal],
                        [PBXTokens identifier:@"$UTBIN/rereg\\noptimize.bsh"],
                        [PBXTokens end],
                        [CPEOFToken eof]]];

    STAssertEqualObjects(a, e, @"Failed to tokenise path", nil);
}

- (void)testCanTokeniseArray
{
    CPTokenStream *a = [tokeniser tokenise:@"children = (\n1DCBB41C12A6F38D006446DA /* ARXHarness.xcodeproj */,\n);"];
    CPTokenStream *e = [CPTokenStream tokenStreamWithTokens:@[
                        [PBXTokens identifier:@"children"],
                        [PBXTokens equal],
                        [PBXTokens leftParentheses],
                        [PBXTokens guid:@"1DCBB41C12A6F38D006446DA"],
                        [PBXTokens comment:@" ARXHarness.xcodeproj "],
                        [PBXTokens comma],
                        [PBXTokens rightParentheses],
                        [PBXTokens end],
                        [CPEOFToken eof]]];

    STAssertEqualObjects(a, e, @"Failed to tokenise Array", nil);
}

@end
