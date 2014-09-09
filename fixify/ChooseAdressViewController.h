//
//  ChooseAdressViewController.h
//  fixify
//
//  Created by Aliya  on 29/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "FixifyJob.h"
#import "AddJobDescriptionViewController.h"

@interface ChooseAdressViewController : UIViewController<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIView *addressView;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak,nonatomic) FixifyJob *job;

- (IBAction)closeButtonAction:(id)sender;

- (IBAction)nextButtonAction:(id)sender;

@end
