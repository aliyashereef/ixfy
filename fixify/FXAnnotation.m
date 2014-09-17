//
//  FXAnnotation.m
//  fixify
//
//  Created by Aliya  on 12/09/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "FXAnnotation.h"

@implementation FXAnnotation
@synthesize coordinate, distance, position;

- (NSString *)subtitle{
    return @"";
}
- (NSString *)title{
    return @"title";
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)cordinate{
    coordinate = cordinate;
    return self;
}
 
@end