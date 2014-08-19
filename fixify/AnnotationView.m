//
//  AnnotationView.m
//  fixify
//
//  Created by Aliya  on 19/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "AnnotationView.h"

@implementation AnnotationView

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title {
    if ((self = [super init])) {
        self.coordinate =coordinate;
        self.title = title;
    }
    return self;
}

@end
