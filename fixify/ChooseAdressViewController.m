//
//  ChooseAdressViewController.m
//  fixify
//
//  Created by Aliya  on 29/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "ChooseAdressViewController.h"

@interface ChooseAdressViewController (){
    CLLocation *pinLocation;
}

@end

@implementation ChooseAdressViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [Utilities setBorderColor:kThemeBrown forView:_addressView];
    float spanX = 0.00725;
    float spanY = 0.00725;
    pinLocation = [[CLLocation alloc] initWithLatitude:_mapView.userLocation.location.coordinate.latitude longitude:_mapView.userLocation.location.coordinate.latitude];
    MKCoordinateRegion region;
    region.center.latitude = pinLocation.coordinate.latitude;
    region.center.longitude = pinLocation.coordinate.longitude;
    region.span = MKCoordinateSpanMake(spanX, spanY);
    [self.mapView setRegion:region animated:YES];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark MKMapView delegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    _mapView.centerCoordinate = userLocation.location.coordinate;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    pinLocation =
    [[CLLocation alloc] initWithLatitude:mapView.centerCoordinate.latitude
                               longitude:mapView.centerCoordinate.longitude];
    [self performSelector:@selector(delayedReverseGeocodeLocation)
               withObject:nil
               afterDelay:0.3];
}
- (void)delayedReverseGeocodeLocation {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self reverseGeocodeLocation];
}

- (void)reverseGeocodeLocation {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:pinLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if(placemarks.count){
            NSDictionary *dictionary = [[placemarks objectAtIndex:0] addressDictionary];
            self.addressLabel.text = [NSString stringWithFormat:@"%@ ,%@ ,%@ ,%@",
                                      [dictionary valueForKey:@"Street"],
                                      [dictionary valueForKey:@"City"],
                                      [dictionary valueForKey:@"State"],
                                      [dictionary valueForKey:@"ZIP"]];
            
        }
    }];
}

- (IBAction)closeButtonAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)nextButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"JOB_DESCRIPTION" sender:self];
}
@end
