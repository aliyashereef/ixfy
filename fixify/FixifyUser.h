//
//  FixifyUser.h
//  fixify
//
//  Created by Aliya  on 14/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <parse/parse.h>
#import <Parse/PFObject+Subclass.h>

@interface FixifyUser : PFUser<PFSubclassing>

@property (retain) NSString *fullName;

@property (retain) NSString *mobileNumber;

@property BOOL isTradesman;

@property (retain) PFFile *image;


@end
