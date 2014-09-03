//
//  FixifyJob.h
//  fixify
//
//  Created by Aliya  on 29/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <parse/parse.h>
@class FixifyUser;

@interface FixifyJob : PFObject<PFSubclassing>
+ (NSString *)parseClassName;

@property (retain) NSString *jobDescription;

@property NSInteger category;

@property (retain) NSArray *imageArray;

@property (retain) FixifyUser *owner;

@property (retain) PFGeoPoint *location;

@property (retain) NSArray *estimates;

@end
