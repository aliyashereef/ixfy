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

@interface CustomMapView : MKMapView
@property (nonatomic, strong) SMCalloutView *calloutView;
@end

@interface OppurtunityListingViewController (){
    HMSegmentedControl *segmentedControl;
    SMCalloutView *calloutView;
    MKAnnotationView *pinView;
    CLLocationCoordinate2D coordinate;
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
    self.menuView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_blurred"]];
    self.menuView.alpha = 0.95f;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_blurred"]];
    self.navigationController.navigationBarHidden = YES;
    [self addAnnotation];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView Delegates and Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
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

#pragma mark - Private Methods

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
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    coordinate.latitude = 10.49861448;
    coordinate.longitude = 76.2286377;
    annotation.coordinate = coordinate;
    self.mapKitWithSMCalloutView = [[CustomMapView alloc] initWithFrame:self.jobMapView.bounds];
    self.mapKitWithSMCalloutView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapKitWithSMCalloutView.delegate = self;
    [self.mapKitWithSMCalloutView addAnnotation:annotation];
    _mapKitWithSMCalloutView.showsUserLocation = YES;
    [self.jobMapView addSubview:self.mapKitWithSMCalloutView];
}

#pragma mark MKMapView delegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    _mapKitWithSMCalloutView.centerCoordinate = userLocation.location.coordinate;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in _mapKitWithSMCalloutView.annotations) {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(zoomRect)) {
            zoomRect = pointRect;
        } else {
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
    }
    [_mapKitWithSMCalloutView setVisibleMapRect:zoomRect edgePadding:UIEdgeInsetsMake(20,20,20,20) animated:YES];
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    if ([annotation isKindOfClass:[MKPointAnnotation class]]){
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
    MKAnnotationView *selectedAnnotation = annotationView;
    if(![selectedAnnotation.annotation.title isEqualToString:@"Current Location"]){
        calloutView = [SMCalloutView platformCalloutView];
        calloutView.delegate = self;
        self.mapKitWithSMCalloutView.calloutView = calloutView;
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(72,0, 170, 20)];
        titleLabel.text = @"Window Repair";
        titleLabel.font = kThemeFont;
        UILabel *subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(72, 25, 170, 40)];
        subTitleLabel.text = @"so i need some one to cook my food and help me repair my kitchen window";
        subTitleLabel.font = kThemeFont;
        subTitleLabel.numberOfLines = 2;
        subTitleLabel.textColor = kThemeBrown;
        titleLabel.textColor =kThemeBrown;
        calloutView.backgroundView = [[SMCalloutBackgroundView alloc]initWithFrame:CGRectMake(0, 0, 250, 70)];
        calloutView.contentView = [[SMCalloutView alloc]initWithFrame:CGRectMake(0, 0, 225,35)];
        calloutView.backgroundView.backgroundColor =kThemeBrown;
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
        [calloutView presentCalloutFromRect:annotationView.bounds inView:annotationView constrainedToView:self.mapKitWithSMCalloutView animated:NO];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    [calloutView dismissCalloutAnimated:NO];
}

#pragma mark - CalloutView Delegate Methods

- (void)calloutViewClicked:(SMCalloutView *)calloutView{
    [self performSegueWithIdentifier:@"JOB_DETAIL" sender:self];
}

- (IBAction)menuButtonAction:(id)sender {
    [self.view sendSubviewToBack:segmentedControl];
    float offset = self.menuView.frame.size.width;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.75];
    [UIView  setAnimationDelegate:self];
    CGRect newFrame = self.menuView.frame;
    newFrame.origin.x = newFrame.origin.x + offset;
    self.menuView.frame = newFrame;
    [UIView commitAnimations];
}

- (IBAction)signOutButtonAction:(id)sender {
    [FixifyUser logOut];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:kLoginStatus];
    [defaults synchronize];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)menuCloseButtonAction:(id)sender {
    float offset = -self.menuView.frame.size.width;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.75];
    [UIView  setAnimationDelegate:self];
    CGRect newFrame = self.menuView.frame;
    newFrame.origin.x = newFrame.origin.x + offset;
    self.menuView.frame = newFrame;
    [UIView commitAnimations];
}
- (IBAction)profileViewButtonAction:(id)sender {
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileView"];
    [self.navigationController presentViewController:controller animated:NO completion:nil];
}
@end

#pragma mark - Custom class Implementation

@interface MKMapView (UIGestureRecognizer)

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;
@end

@implementation CustomMapView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIControl class]])
        return NO;
    else
        return [super gestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *calloutMaybe = [self.calloutView hitTest:[self.calloutView convertPoint:point fromView:self] withEvent:event];
    if (calloutMaybe) return calloutMaybe;
    return [super hitTest:point withEvent:event];
}

@end

