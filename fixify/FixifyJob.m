//
//  FixifyJob.m
//  fixify
//
//  Created by Aliya  on 29/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "FixifyJob.h"
#import <parse/PFObject+Subclass.h>

@implementation FixifyJob

@dynamic location;

@dynamic imageArray;

@dynamic createdAt;

@dynamic jobDescription;

@dynamic category;

@dynamic owner;

@dynamic objectId;

@dynamic estimates;

+ (NSString *)parseClassName
{
    return @"Job";
}

@end
