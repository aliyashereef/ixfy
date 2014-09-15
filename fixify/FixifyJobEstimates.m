//
//  FixifyJobEstimates.m
//  fixify
//
//  Created by Aliya  on 12/09/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//
#import <parse/PFObject+Subclass.h>
#import "FixifyJobEstimates.h"

@implementation FixifyJobEstimates

@dynamic owner;

@dynamic createdAt;

@dynamic amount;

@dynamic job;

@dynamic objectId;

@dynamic estimateTime;

@dynamic jobDescription;

+ (NSString *)parseClassName
{
    return @"Estimates";
}

@end
