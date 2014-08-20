//
//  OppurtunityListingViewController.h
//  fixify
//
//  Created by Aliya  on 19/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SMCalloutView.h"

@interface OppurtunityListingViewController : UIViewController<MKMapViewDelegate,UITableViewDataSource,UITableViewDelegate,SMCalloutViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *listView;
@property (weak, nonatomic) IBOutlet UIView *jobMapView;

@end
