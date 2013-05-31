//
//  PBXTokeniser.h
//  PBXCoder
//
//  Created by Jonny Yu on 5/31/13.
//  Copyright (c) 2013 Jonny Yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreParse/CoreParse.h>

@interface PBXTokeniser : NSObject <CPTokeniserDelegate> {
    CPTokeniser *tokeniser;
}

- (CPTokenStream*)tokenise:(NSString*)text;

@end
