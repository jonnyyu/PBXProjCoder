//
//  PBXDocument.h
//  PBXCoder
//
//  Created by Jonny Yu on 6/7/13.
//  Copyright (c) 2013 Jonny Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBXProject : NSObject

@property (readwrite, assign, nonatomic) NSUInteger archiveVersion;
@property (readwrite, assign, nonatomic) NSUInteger objectVersion;

@end
