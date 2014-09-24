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
#import "FixifyUser.h"
#import "FixifyJob.h"
#import "CategoryListingViewController.h"
#import "JobDetailViewController.h"
#import "MBProgressHUD.h"

@interface CustomMapView : MKMapView
@property (nonatomic, strong) SMCalloutView *calloutView;
@end

@interface OppurtunityListingViewController (){
    HMSegmentedControl *segmentedControl;
    SMCalloutView *calloutView;
    FixifyJob *activeJob;
    CategoryListingViewController * categoryListingViewController;
    NSArray *titleArray;
}

@end

@implementation OppurtunityListingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

#pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchAllJobsList];
    [self addSegmentedControl];
    [self addCategoryView];
    activeJob = [[FixifyJob alloc]init];
    self.jobMapView.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = kThemeBackground;
    self.menuView.backgroundColor = kThemeBackground;
    self.menuView.alpha = 0.95f;
    self.navigationController.navigationBarHidden = YES;
    [_categoryFilterButton addTarget:self action:@selector(showCategories:) forControlEvents:UIControlEventTouchUpInside];
    titleArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:kPlistName ofType:@"plist"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(showOrHideCategoryView:)
                                                     name:kFilterSelectionNotification
                                                   object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(categorySelected:)
                                                     name:kCategorySelectedNotification
                                                   object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFilterSelectionNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCategorySelectedNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView Delegates and Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _jobArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JobOppurtunityCellTableViewCell *cell = (JobOppurtunityCellTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kJobOppurtunityCellID];
    if(cell == nil){
        cell = [[JobOppurtunityCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kJobOppurtunityCellID];
    }
    FixifyJob *job = [_jobArray objectAtIndex:indexPath.section];
    CLLocation *joblocation  = [[CLLocation alloc]initWithLatitude:job.location.latitude longitude:job.location.longitude];
    CLLocationDistance meters = [joblocation distanceFromLocation:_mapKitWithSMCalloutView.userLocation.location];
    cell.jobTitle.text = [NSString stringWithFormat:@"%@",[[titleArray objectAtIndex:job.category] valueForKey:@"title"]];
    cell.jobImage.image = [UIImage imageWithData:[[titleArray objectAtIndex:job.category] valueForKey:@"image"]];
    cell.jobDescription.text = job.jobDescription;
    cell.jobDistance.text = [NSString stringWithFormat:@"%.1f m",meters];
    cell.jobEstimates.text = @"120 Estimates";
    cell.jobListedDate.text = @"Listed:12 Apr 2014";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    activeJob = [_jobArray objectAtIndex:indexPath.section];
    [self performSegueWithIdentifier:kJobDetailViewSegue sender:nil];
}

#pragma mark MKMapView delegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    _mapKitWithSMCalloutView.centerCoordinate = userLocation.location.coordinate;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(FXAnnotation *)annotation {
    MKAnnotationView *pinView;
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    if ([annotation isKindOfClass:[FXAnnotation class]]){
        pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:kCustomPinAnnotation];
        if (!pinView){
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kCustomPinAnnotation];
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
    if(![annotationView.annotation.title isEqualToString:@"Current Location"]){
        calloutView = [SMCalloutView platformCalloutView];
        calloutView.delegate = self;
        self.mapKitWithSMCalloutView.calloutView = calloutView;
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(72,0, 170, 20)];
        UILabel *subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(72, 25, 170, 40)];
        calloutView.backgroundView = [[SMCalloutBackgroundView alloc]initWithFrame:CGRectMake(0, 0, 250, 70)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,70,65)];
        calloutView.contentView = [[SMCalloutView alloc]initWithFrame:CGRectMake(0, 0, 225,35)];
        UIView *mainView = [[UIView alloc]initWithFrame:CGRectMake(5,5,240,65)];
        calloutView.backgroundView.backgroundColor = kThemeBrown;
        subTitleLabel.textColor = kThemeBrown;
        titleLabel.textColor = kThemeBrown;
        titleLabel.font = kThemeFont;
        subTitleLabel.font = kThemeFont;
        subTitleLabel.numberOfLines = 2;
        FXAnnotation *annotation = annotationView.annotation;
        titleLabel.text = [NSString stringWithFormat:@"%@",[[titleArray objectAtIndex:annotation.job.category] valueForKey:@"title"]];
        subTitleLabel.text = annotation.job.jobDescription;
        imageView.image = annotation.jobImage;
        mainView.backgroundColor = [UIColor whiteColor];
        [mainView addSubview:imageView];
        [mainView addSubview:titleLabel];
        [mainView addSubview:subTitleLabel];
        [calloutView.backgroundView addSubview:mainView];
        calloutView.calloutOffset = annotationView.calloutOffset;
        activeJob = annotation.job;
        [calloutView presentCalloutFromRect:annotationView.bounds inView:annotationView constrainedToView:self.mapKitWithSMCalloutView animated:NO];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    [calloutView dismissCalloutAnimated:NO];
}

#pragma mark - CalloutView Delegate Methods

- (void)calloutViewClicked:(SMCalloutView *)clickedCalloutView{
    [self performSegueWithIdentifier:kJobDetailViewSegue sender:self];
}

- (IBAction)myJobsButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)menuButtonAction:(id)sender {
    [self.view sendSubviewToBack:segmentedControl];
    [Utilities showAnimationForView:self.menuView];
}

#pragma mark - Private Methods

- (void)fetchAllJobsList{
    PFGeoPoint *userLocation = [PFGeoPoint geoPointWithLocation:_mapKitWithSMCalloutView.userLocation.location];
    PFQuery *jobQuery = [FixifyJob query];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [jobQuery whereKey:@"location" nearGeoPoint:userLocation];
    [jobQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            _jobArray = [objects mutableCopy];
            [self addAnnotation];
            [self.jobTableView reloadData];
        }else{
            [Utilities showAlertWithTitle:kError message:error.description];
        }
    }];
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

- (void)segmentedControlChangedValue:(UISegmentedControl *)sender{
    if(segmentedControl.selectedSegmentIndex == 0){
        self.listView.hidden = NO;
        self.jobMapView.hidden = YES;
    }else if(segmentedControl.selectedSegmentIndex == 1){
        self.jobMapView.hidden = NO;
        self.listView.hidden = YES;
    }
}

- (void)addAnnotation{
    self.mapKitWithSMCalloutView = [[CustomMapView alloc] initWithFrame:self.jobMapView.bounds];
    self.mapKitWithSMCalloutView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
    self.mapKitWithSMCalloutView.delegate = self;
    NSMutableArray *annotationArray = [[NSMutableArray alloc]init];
    [annotationArray addObject:_mapKitWithSMCalloutView.userLocation];
    for (int i = 0; i < _jobArray.count; i++) {
        FixifyJob *job = [_jobArray objectAtIndex:i];
        CLLocation *joblocation  = [[CLLocation alloc]initWithLatitude:job.location.latitude longitude:job.location.longitude];
        FXAnnotation *annotation = [[FXAnnotation alloc]initWithCoordinate:joblocation.coordinate];
        annotation.job = job;
        annotation.jobImage = [UIImage imageWithData:[[titleArray objectAtIndex:job.category]valueForKey:@"image"]];
        [annotationArray addObject:annotation];
        [self.mapKitWithSMCalloutView addAnnotation:annotation];
    }
    _mapKitWithSMCalloutView.showsUserLocation = YES;
    [self.jobMapView addSubview:self.mapKitWithSMCalloutView];
    [self.mapKitWithSMCalloutView showAnnotations:annotationArray animated:YES];
}

- (IBAction)signOutButtonAction:(id)sender {
    [FixifyUser logOut];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:kLoginStatus];
    [defaults synchronize];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)menuCloseButtonAction:(id)sender {
    [Utilities hideAnimationForView:self.menuView];
}

- (IBAction)profileViewButtonAction:(id)sender {
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:kEditProfileViewControllerID];
    [self.navigationController presentViewController:controller animated:NO completion:nil];
}

- (void)addCategoryView{
    categoryListingViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:kCategoryListingViewControllerID];
    categoryListingViewController.view.frame = self.view.bounds;
    [self addChildViewController:categoryListingViewController];
    [self.view addSubview:categoryListingViewController.view];
    categoryListingViewController.view.hidden = YES;
}

- (void)showCategories:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kFilterSelectionNotification object:nil];
}

- (void) fetchCategoryJobs{
    PFGeoPoint *userLocation = [PFGeoPoint geoPointWithLocation:_mapKitWithSMCalloutView.userLocation.location];
    PFQuery *jobQuery = [FixifyJob query];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [jobQuery whereKey: @"category" equalTo:_category];
    [jobQuery whereKey: @"location" nearGeoPoint:userLocation];
    [jobQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [MBProgressHUD hideAllHUDsForView: self.view animated:YES];
            _jobArray = [objects mutableCopy];
            [self addAnnotation];
            [self.jobTableView reloadData];
        }else{
            [Utilities showAlertWithTitle:kError message:error.description];
        }
    }];
}

#pragma mark - Notification Methods

- (void)showOrHideCategoryView:(NSNotification *)notification {
    categoryListingViewController.view.hidden = !categoryListingViewController.view.hidden;
}

//  Invoked on selecting an item from category list.
- (void)categorySelected:(NSNotification *)notification {
    categoryListingViewController.view.hidden = YES;
    self.category = notification.object;
    [self fetchCategoryJobs];
}

#pragma mark - Navigation Methods

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:kJobDetailViewSegue]) {
        JobDetailViewController *viewController = (JobDetailViewController *)segue.destinationViewController;
        viewController.job = activeJob;
    }
}

@end

#pragma mark - Custom class Implementation

@interface MKMapView (UIGestureRecognizer)

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;
@end

@implementation CustomMapView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIControl class]]){
        return NO;
    }else{
        return [super gestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *calloutMaybe = [self.calloutView hitTest:[self.calloutView convertPoint:point fromView:self] withEvent:event];
    if (calloutMaybe){
        return calloutMaybe;
    }
    return [super hitTest:point withEvent:event];
}

@end

