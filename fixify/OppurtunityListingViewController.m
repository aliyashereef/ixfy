//
//  OppurtunityListingViewController.m
//  fixify
//
//  Created by Aliya  on 19/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "OppurtunityListingViewController.h"
#import "HMSegmentedControl.h"
#import "JobOppurtunityCellTableViewCell.h"
#import "SMCalloutView.h"

@interface OppurtunityListingViewController ()
{
    HMSegmentedControl *segmentedControl;
    SMCalloutView *calloutView;
    MKAnnotationView *pinView;
}
@end

@implementation OppurtunityListingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self addSegmentedControl];
    self.jobMapView.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_blurred"]];
    self.navigationItem.title= @"Oppurtunities";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:  [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"DINAlternate-Bold" size:20.0]};
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *menuButton =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_menu"]
                                                                 style:UIBarButtonItemStylePlain
                                                    target:self
                                                action:@selector(menuButtonAction)];
    UIBarButtonItem *feedbackButton =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_menu_feedback"] style:UIBarButtonItemStylePlain
                                                target:self
                                                action:@selector(feedbackButtonAction)];
    menuButton.tintColor= [UIColor whiteColor];
    feedbackButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = menuButton;
    self.navigationItem.rightBarButtonItem = feedbackButton;
    MKPointAnnotation *annotation =
    [[MKPointAnnotation alloc]init];
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 9.931;
    coordinate.longitude = 76.2678;
    annotation.coordinate = coordinate;
    [_mapView addAnnotation:annotation];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    float spanX = 0.00725;
    float spanY = 0.00725;
    MKCoordinateRegion region;
    region.center.latitude = self.mapView.userLocation.coordinate.latitude;
    region.center.longitude = self.mapView.userLocation.coordinate.longitude;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    [self.mapView setRegion:region animated:YES];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)mapView:(MKMapView *)mapView
didUpdateUserLocation:
(MKUserLocation *)userLocation{
    _mapView.centerCoordinate =
    userLocation.location.coordinate;
    [calloutView dismissCalloutAnimated:NO];
}

- (void)segmentedControlChangedValue:(UISegmentedControl *)sender{
    if(segmentedControl.selectedSegmentIndex == 0){
        self.listView.hidden = NO;
        self.jobMapView.hidden = YES;
    }else if(segmentedControl.selectedSegmentIndex == 1){
        self.jobMapView.hidden = NO;
        self.listView.hidden = YES;
    }
}

#pragma mark - TableView Delegates and Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JobOppurtunityCellTableViewCell *cell = (JobOppurtunityCellTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kJobOppurtunityCellID];
    if(cell == nil){
        cell = [[JobOppurtunityCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kJobOppurtunityCellID];
    }
    cell.jobTitle.text = @"Window Repair";
    cell.jobDescription.text = @"So i need some one to cook my food and help me repair my kitchen window";
    cell.jobDistance.text = @"150 m";
    cell.jobEstimates.text = @"120 Estimates";
    cell.jobListedDate.text = @"Listed:12 Apr 2014";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"JOB_DETAIL" sender:nil];
}

- (void)addSegmentedControl{
    segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"List",@"Map"]];
    segmentedControl.frame = CGRectMake(60, 66, 200, 40);
    segmentedControl.backgroundColor = [UIColor clearColor];
    segmentedControl.selectedTextColor = [UIColor whiteColor];
    segmentedControl.font = [UIFont fontWithName:@"DINAlternate-Bold" size:15.0f];
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.selectionIndicatorHeight = 4.0f;
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.selectionIndicatorColor = [UIColor whiteColor];
    segmentedControl.textColor = [UIColor whiteColor];
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
}

- (void)menuButtonAction{
}

- (void)feedbackButtonAction{
}

#pragma mark MKMapView delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    if ([annotation isKindOfClass:[MKPointAnnotation class]]){
        pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:kCustomPinAnnotation];
        if (!pinView){
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kCustomPinAnnotation];
            //pinView.animatesDrop = YES;
            pinView.canShowCallout = NO;
            pinView.image = [UIImage imageNamed:@"map_pin"];
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)annotationView {
    MKAnnotationView *selectedAnnotation = annotationView;
    if(![selectedAnnotation.annotation.title isEqualToString:@"Current Location"]){
        calloutView = [SMCalloutView platformCalloutView];
        calloutView.delegate = self;
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(72,0, 170, 20)];
        titleLabel.text = @"Window Repair";
        titleLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:12.0f];
        UILabel *subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(72, 25, 170, 40)];
        subTitleLabel.text = @"so i need some one to cook my food and help me repair my kitchen window";
        subTitleLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:12.0f];
        subTitleLabel.numberOfLines = 2;
        subTitleLabel.textColor = [UIColor colorWithRed:(float)140/255 green:(float)131/255 blue:(float)123/255 alpha:1];
        titleLabel.textColor =[UIColor colorWithRed:(float)140/255 green:(float)131/255 blue:(float)123/255 alpha:1];
        calloutView.backgroundView = [[SMCalloutBackgroundView alloc]initWithFrame:CGRectMake(0, 0, 250, 70)];
        calloutView.contentView = [[SMCalloutView alloc]initWithFrame:CGRectMake(0, 0, 225,35)];
        calloutView.backgroundView.backgroundColor =[UIColor colorWithRed:(float)140/255 green:(float)131/255 blue:(float)123/255 alpha:1];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,65,65)];
        imageView.image = [UIImage imageNamed:@"window.jpg"];
        UIView *mainView = [[UIView alloc]initWithFrame:CGRectMake(5,5,240,65)];
        mainView.layer.cornerRadius = 0;
        mainView.clipsToBounds = YES;
        mainView.backgroundColor = [UIColor whiteColor];
        [mainView addSubview:imageView];
        [mainView addSubview:titleLabel];
        [mainView addSubview:subTitleLabel];
        [calloutView.backgroundView addSubview:mainView];
        calloutView.calloutOffset = annotationView.calloutOffset;
        [calloutView presentCalloutFromRect:annotationView.bounds inView:annotationView constrainedToView:self.mapView animated:NO];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    [calloutView dismissCalloutAnimated:NO];
}

@end
