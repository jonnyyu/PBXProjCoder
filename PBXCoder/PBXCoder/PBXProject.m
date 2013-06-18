//
//  PBXDocument.m
//  PBXCoder
//
//  Created by Jonny Yu on 6/7/13.
//  Copyright (c) 2013 Jonny Yu. All rights reserved.
//

#import "PBXProject.h"

@implementation PBXProject

-(BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[PBXProject class]]) {
        PBXProject *other = (PBXProject*)object;
        return [other archiveVersion]  == [self archiveVersion] &&
                [other objectVersion]   == [self objectVersion];
    }
    return NO;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"PBXDocument archiveVersion=%lu, objectVersion=%lu",
            (unsigned long)[self archiveVersion], (unsigned long)[self objectVersion]];
}


@end
