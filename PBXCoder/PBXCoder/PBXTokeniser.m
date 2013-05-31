//
//  PBXTokeniser.m
//  PBXCoder
//
//  Created by Jonny Yu on 5/31/13.
//  Copyright (c) 2013 Jonny Yu. All rights reserved.
//

#import "PBXTokeniser.h"
#import <CoreParse/CoreParse.h>
#import "PBXGuidRecogniser.h"
#import "PBXPathRecogniser.h"


@implementation PBXTokeniser

- (id)init
{
    self = [super init];
    if (self)
    {
        tokeniser = [[CPTokeniser alloc] init];
        
        [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"// !$*UTF8*$!"]];
        [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"{"]];
        [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"}"]];
        [tokeniser addTokenRecogniser:[CPWhiteSpaceRecogniser whiteSpaceRecogniser]];
        [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@";"]];
        [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@","]];
        [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"("]];
        [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@")"]];
        [tokeniser addTokenRecogniser:[PBXGuidRecogniser guidRecogniser]];
        [tokeniser addTokenRecogniser:[CPIdentifierRecogniser identifierRecogniser]];
        [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"="]];
        [tokeniser addTokenRecogniser:[CPNumberRecogniser integerRecogniser]];
        [tokeniser addTokenRecogniser:[CPQuotedRecogniser quotedRecogniserWithStartQuote:@"/*" endQuote:@"*/" name:@"Comment"]];
        [tokeniser addTokenRecogniser:[CPQuotedRecogniser quotedRecogniserWithStartQuote:@"\"" endQuote:@"\"" name:@"QuotedText"]];
        [tokeniser addTokenRecogniser:[PBXPathRecogniser pathRecogniser]];

        [tokeniser setDelegate:self];
    }
    return self;
}

-(CPTokenStream*)tokenise:(NSString*)input {
    return [tokeniser tokenise:input];;
}

-(BOOL)tokeniser:(CPTokeniser *)tokeniser shouldConsumeToken:(CPToken *)token {
    return YES;
}

-(void)tokeniser:(CPTokeniser *)tokeniser requestsToken:(CPToken *)token pushedOntoStream:(CPTokenStream *)stream
{
    if (![token isWhiteSpaceToken])
    {
        [stream pushToken:token];
    }
}

@end
