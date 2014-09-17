//
//  FXAnnotation.h
//  fixify
//
//  Created by Aliya  on 12/09/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "FixifyJob.h"

@interface FXAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *jobName;
    
    double distance;
    NSInteger position;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) FixifyJob *job;
@property (nonatomic, strong) UIImage *jobImage;

@property double distance;
@property NSInteger position;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (NSString *)subtitle;
- (NSString *)title;

@end
