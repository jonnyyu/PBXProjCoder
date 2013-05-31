//
//  main.m
//  CoreParseExercise
//
//  Created by Jonny Yu on 5/30/13.
//  Copyright (c) 2013 Jonny Yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreParse/CoreParse.h>


@interface TokeniserDelegate : NSObject <CPTokeniserDelegate, CPParserDelegate>

@end

@implementation TokeniserDelegate

-(BOOL)tokeniser:(CPTokeniser *)tokeniser shouldConsumeToken:(CPToken *)token {
    return YES;
}

-(void)tokeniser:(CPTokeniser *)tokeniser requestsToken:(CPToken *)token pushedOntoStream:(CPTokenStream *)stream
{
    if (![token isWhiteSpaceToken] && ![[token name] isEqualToString:@"Comment"])
    {
        [stream pushToken:token];
    }
}

-(id)parser:(CPParser *)parser didProduceSyntaxTree:(CPSyntaxTree *)syntaxTree
{
    return [(CPKeywordToken*)[syntaxTree childAtIndex:0] keyword];
}

@end


@interface Expression : NSObject <CPParseResult>
@property (readwrite, assign, nonatomic) float value;
@end
@interface Term : NSObject <CPParseResult>
@property (readwrite, assign, nonatomic) float value;
@end
@interface Factor : NSObject <CPParseResult>
@property (readwrite, assign, nonatomic) float value;
@end

@implementation Expression
-(id)initWithSyntaxTree:(CPSyntaxTree *)syntaxTree
{
    if (self = [self init])
    {
        Term *t = [syntaxTree valueForTag:@"term"];
        Expression *e = [syntaxTree valueForTag:@"expr"];

        if (e == nil)
        {
            [self setValue:[t value]];
        }
        else
        {
            if ([[syntaxTree valueForTag:@"op"] isEqualToString:@"+"])
            {
                [self setValue:[e value] + [t value]];
            }
            else
            {
                [self setValue:[e value] - [t value]];
            }
        }
    }
    return self;
}
@end

@implementation Term

-(id)initWithSyntaxTree:(CPSyntaxTree *)syntaxTree
{
    if (self = [self init])
    {
        Factor *f = [syntaxTree valueForTag:@"fact"];
        Term   *t = [syntaxTree valueForTag:@"term"];
        if (t == nil)
        {
            [self setValue:[f value]];
        }
        else if ([[syntaxTree valueForTag:@"op"] isEqualToString:@"*"])
        {
            [self setValue:[f value] * [t value]];
        }
        else
        {
            [self setValue:[f value] / [t value]];
        }
    }
    return self;
}
@end

@implementation Factor

-(id)initWithSyntaxTree:(CPSyntaxTree *)syntaxTree
{
    if (self = [self init])
    {
        CPNumberToken *n = [syntaxTree valueForTag:@"num"];
        Expression    *e = [syntaxTree valueForTag:@"expr"];
        if (e != nil) {
            [self setValue:[e value]];
        }
        else
        {
            [self setValue:[[n number] floatValue]];
        }
    }
    return self;
}
@end


int main(int argc, const char * argv[])
{

    @autoreleasepool {

        TokeniserDelegate *delegate = [[TokeniserDelegate alloc] init];

        CPTokeniser *tokeniser = [[CPTokeniser alloc] init];
        [tokeniser addTokenRecogniser:[CPNumberRecogniser numberRecogniser]];
        [tokeniser addTokenRecogniser:[CPWhiteSpaceRecogniser whiteSpaceRecogniser]];
        [tokeniser addTokenRecogniser:[CPQuotedRecogniser quotedRecogniserWithStartQuote:@"/*" endQuote:@"*/" name:@"Comment"]];
        [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"+"]];
        [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"-"]];
        [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"*"]];
        [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"/"]];
        [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"("]];
        [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@")"]];

        tokeniser.delegate = delegate;


        NSString* expressionGrammar =
            @"Expression ::= term@<Term> | expr@<Expression> op@<AddOp> term@<Term>;"
            @"Term       ::= fact@<Factor> | fact@<Factor>   op@<MulOp> term@<Term>;"
            @"Factor     ::= num@'Number' | '(' expr@<Expression> ')';"
            @"AddOp      ::= '+' | '-';"
            @"MulOp      ::= '*' | '/';";
        NSError *error = nil;

        CPGrammar *grammar = [CPGrammar grammarWithStart:@"Expression" backusNaurForm:expressionGrammar error:&error];
        if (grammar == nil)
        {
            NSLog(@"Error creating grammar");
            NSLog(@"%@", error);
        }
        else
        {
            CPParser *parser = [CPLALR1Parser parserWithGrammar:grammar];
            [parser setDelegate:delegate];

            CPTokenStream* tokenStream = [tokeniser tokenise:@"5 + (2 * 6 + 9) * 8"];
            id result= [parser parse:tokenStream];
            NSLog(@"%@", result);

            NSLog(@"%f", [(Expression*)result value]);
        }   
    }
    return 0;
}

