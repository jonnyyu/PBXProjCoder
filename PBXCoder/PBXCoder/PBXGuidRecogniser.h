//
//  PBXGuidRecogniser.h
//  PBXCoder
//
//  Created by Jonny Yu on 5/31/13.
//  Copyright (c) 2013 Jonny Yu. All rights reserved.
//

#import <CoreParse/CoreParse.h>

@interface PBXGuidRecogniser : NSObject <CPTokenRecogniser>

+(id)guidRecogniser;

@end
