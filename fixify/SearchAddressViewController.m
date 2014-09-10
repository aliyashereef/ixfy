//
//  SearchAddressViewController.m
//  fixify
//
//  Created by Aliya  on 03/09/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "SearchAddressViewController.h"

@interface SearchAddressViewController (){
    NSUserDefaults *userDefaults;
    int searchIndex;
}

@end

@implementation SearchAddressViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    userDefaults = [NSUserDefaults standardUserDefaults];
    searchIndex = [userDefaults integerForKey:kSearchIndex];
    _recentSearch = [[NSMutableArray alloc]initWithArray:[userDefaults objectForKey:kRecentSearch]];
    [_resultsTableView reloadData];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table View delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_recentSearch count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchAddressCellID];
    NSArray *singleArray = [[NSArray alloc]initWithArray:[_recentSearch  objectAtIndex:indexPath.row]];
    cell.textLabel.text = [singleArray objectAtIndex:2];
    cell.textLabel.font = kThemeFont;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *singleArray = [[NSArray alloc]initWithArray:[_recentSearch  objectAtIndex:indexPath.row]];
    CLLocation *location = [[CLLocation alloc]initWithLatitude:[[singleArray objectAtIndex:0] floatValue] longitude:[[singleArray objectAtIndex:1] floatValue]];
    [self saveJobWithLocation:location];
}

#pragma mark - TextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.searchField) {
        [self searchAction];
    }
    return YES;
}

#pragma mark - Private functions

- (IBAction)closeButtonAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)searchAction{
    if(self.geocoder == nil){
        self.geocoder = [[CLGeocoder alloc] init];
    }
    [self.geocoder geocodeAddressString:self.searchField.text completionHandler:^(NSArray *placemarks, NSError *error){
        if(placemarks.count > 0){
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            searchIndex++;
            [_recentSearch replaceObjectAtIndex:searchIndex%5 withObject:[Utilities getArrayForLocation:placemark]];
            [userDefaults setObject:_recentSearch forKey:kRecentSearch];
            [userDefaults setInteger:searchIndex forKey:kSearchIndex];
            [userDefaults synchronize];
            [_resultsTableView reloadData];
            [self saveJobWithLocation :placemark.location];
                    }else if (error.domain == kCLErrorDomain){
            switch (error.code){
                case kCLErrorDenied:
                    [Utilities showAlertWithTitle:kError message:kLocationDenied];break;
                case kCLErrorNetwork:
                    [Utilities showAlertWithTitle:kError message:kNoNetwork];break;
                case kCLErrorGeocodeFoundNoResult:
                    [Utilities showAlertWithTitle:kError message:kNoResultsFound];break;
                default:
                    [Utilities showAlertWithTitle:kError message:error.localizedDescription];break;
            }
        }else{
            [Utilities showAlertWithTitle:kError message:error.localizedDescription];
        }
    }];
}

- (void)saveJobWithLocation :(CLLocation *)location{
    PFGeoPoint *point = [PFGeoPoint geoPointWithLocation:location];
    self.job.location = point;
    [_job saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self performSegueWithIdentifier:kSearchAddressDescription sender:self];
    }];
 
}

@end
