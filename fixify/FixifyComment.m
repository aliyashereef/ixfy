//
//  FixifyComment.m
//  fixify
//
//  Created by Aliya  on 23/09/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "FixifyComment.h"
#import <parse/PFObject+Subclass.h>

@implementation FixifyComment

@dynamic author;

@dynamic commentString;

@dynamic parentComment;

@dynamic job;

@dynamic createdAt;

@dynamic objectId;

@dynamic isPrivate;

+ (NSString *)parseClassName
{
    return @"comment";
}

@end
