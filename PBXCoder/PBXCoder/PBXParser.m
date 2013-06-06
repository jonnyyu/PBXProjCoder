//
//  PBXParser.m
//  PBXCoder
//
//  Created by Jonny Yu on 5/31/13.
//  Copyright (c) 2013 Jonny Yu. All rights reserved.
//

#import "PBXParser.h"

@implementation PBXParser

-(id)init
{
    if (self = [super init])
    {
        NSString* fileGrammar = @"NTDocument  ::= '// !$*UTF8*$!' content@<NTGroup> ; "
                                 "NTGroup   ::= '{' ( <NTMetaItem> ';' | <NTSection> )* '}' ;"
                                 "NTSection   ::= begin@'Comment' ( <NTGuidItem> ';' )* end@'Comment';"
                                 "NTMetaItem  ::= ( item@<NTItem> | guidItem@<NTGuidItem> );"
                                 "NTGuidItem  ::= guid@<NTGuid> '=' group@<NTGroup>;        "
                                 "NTItem      ::= name@'Identifier' '=' ( num@'Number' |    "
                                 "                                   text@'Identifier' |    "
                                 "                             quotedText@'QuotedText' |    "
                                 "                                       guid@<NTGuid> |    "
                                 "                                     guids@<NTArray> |    "
                                 "                                     group@<NTGroup> );   "
                                 "NTArray     ::= '(' ( <NTArrayItem> ',' )* ')';           "
                                 "NTArrayItem ::= ( guid@<NTGuid> | text@'Identifier' );    "
                                 "NTGuid      ::= guid@'Guid' comment@'Comment';            "
        ;

        NSError* err = nil;
        CPGrammar *grammar = [CPGrammar grammarWithStart:@"NTDocument" backusNaurForm:fileGrammar error:&err];

        if (grammar == nil)
            @throw [NSException exceptionWithName:@"Grammar failed" reason:[err description] userInfo:nil];


        parser = [[CPLALR1Parser alloc] initWithGrammar:grammar];
    }
    return self;
}

- (id)parse:(CPTokenStream*)tokenStream
{
    return [parser parse:tokenStream];
}

@end
