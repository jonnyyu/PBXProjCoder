//
//  PBXGuidRecogniser.m
//  PBXCoder
//
//  Created by Jonny Yu on 5/31/13.
//  Copyright (c) 2013 Jonny Yu. All rights reserved.
//

#import "PBXGuidRecogniser.h"
#import "PBXGuidToken.h"

@implementation PBXGuidRecogniser

+(id)guidRecogniser
{
    return [[PBXGuidRecogniser alloc] init];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    //Nothing to persist.
}

/**
 * Attempts to recognise a token at tokenPosition in tokenString.
 * 
 * If a token is successfully recognised, it should be returned, and tokenPosition advanced to after the consumed characters.
 * If no valid token is found `nil` must be returned instead, and tokenPosition left unchanged.
 * 
 * @param tokenString The string in which to recognise tokens.
 * @param tokenPosition The position at which to try to find the token.  On output, the position after the recognised token.
 * @return Returns the token recognised.
 */
- (CPToken *)recogniseTokenInString:(NSString *)tokenString currentTokenPosition:(NSUInteger *)tokenPosition
{
    NSCharacterSet *guidCharacters = [NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEF"];
    unichar firstChar = [tokenString characterAtIndex:*tokenPosition];
    if ([guidCharacters characterIsMember:firstChar])
    {
        NSString *guidString;
        NSScanner *scanner = [NSScanner scannerWithString:tokenString];
        [scanner setScanLocation:*tokenPosition];
        [scanner setCharactersToBeSkipped:nil];
        BOOL success = [scanner scanCharactersFromSet:guidCharacters intoString:&guidString];
        if (success && [guidString length] == 24) {
            *tokenPosition = [scanner scanLocation];
            return [PBXGuidToken tokenWithGuid:guidString];
        }
        return nil;
    }
    return nil;
}

@end
