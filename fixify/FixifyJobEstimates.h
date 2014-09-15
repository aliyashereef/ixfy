//
//  FixifyJobEstimates.h
//  fixify
//
//  Created by Aliya  on 12/09/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <parse/parse.h>
@class FixifyUser;
@class FixifyJob;

@interface FixifyJobEstimates : PFObject<PFSubclassing>
+ (NSString *)parseClassName;

@property (retain) NSNumber *amount;
@property (retain) FixifyJob *job;
@property (retain) FixifyUser *owner;
@property (retain) NSString *jobDescription;
@property (retain) NSDate *estimateTime;

@end
