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
        NSString* fileGrammar = @"";
        

        NSError* err = nil;
        CPGrammar *grammar = [CPGrammar grammarWithStart:@"Document" backusNaurForm:fileGrammar error:&err];

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
