//
//  FixifyComment.h
//  fixify
//
//  Created by Aliya  on 23/09/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <parse/parse.h>
@class FixifyJob;
@class FixifyUser;
@class FixifyComment;

@interface FixifyComment : PFObject<PFSubclassing>
+ (NSString *)parseClassName;

@property (retain) NSString *commentString;

@property (retain) FixifyJob *job;

@property (retain) FixifyUser *author;

@property (retain) FixifyComment *parentComment;

@property (readonly) PFRelation *replies;

@property BOOL isPrivate ;

@end
