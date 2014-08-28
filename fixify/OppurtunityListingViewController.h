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

@class CustomMapView;

@interface OppurtunityListingViewController : UIViewController<MKMapViewDelegate,UITableViewDataSource,UITableViewDelegate,SMCalloutViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *listView;
@property (weak, nonatomic) IBOutlet UIView *jobMapView;
@property (nonatomic, strong) CustomMapView *mapKitWithSMCalloutView;
@property (weak, nonatomic) IBOutlet UIView *menuView;

- (IBAction)menuButtonAction:(id)sender;
- (IBAction)signOutButtonAction:(id)sender;
- (IBAction)menuCloseButtonAction:(id)sender;
- (IBAction)profileViewButtonAction:(id)sender;

@end
