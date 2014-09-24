//
//  ChooseAdressViewController.m
//  fixify
//
//  Created by Aliya  on 29/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "ChooseAdressViewController.h"
#import "SearchAddressViewController.h"

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
    pinLocation = [[CLLocation alloc] initWithLatitude:_mapView.userLocation.location.coordinate.latitude longitude:_mapView.userLocation.location.coordinate.latitude];
    MKCoordinateRegion region;
    region.center.latitude = pinLocation.coordinate.latitude;
    region.center.longitude = pinLocation.coordinate.longitude;
    region.span = MKCoordinateSpanMake(kSpanX, kSpanX);
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
               afterDelay:kMapGeocodeDelay];
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
    PFGeoPoint *point = [PFGeoPoint geoPointWithLocation:pinLocation];
    self.job.location = point;
    [self performSegueWithIdentifier:@"JOB_DESCRIPTION" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"JOB_DESCRIPTION"]) {
        AddJobDescriptionViewController *addJobDescriptionView = (AddJobDescriptionViewController *)segue.destinationViewController;
        addJobDescriptionView.job = self.job;
    }else {
        SearchAddressViewController *searchAddressViewController = (SearchAddressViewController *)segue.destinationViewController;
        searchAddressViewController.job = self.job;
    }
}

@end
