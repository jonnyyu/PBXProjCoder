//
//  PBXParser.h
//  PBXCoder
//
//  Created by Jonny Yu on 5/31/13.
//  Copyright (c) 2013 Jonny Yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PBXTokeniser.h"

@interface PBXParser : NSObject  {
    CPLALR1Parser *parser;
}

- (id)parse:(CPTokenStream*)tokenStream;

@end
