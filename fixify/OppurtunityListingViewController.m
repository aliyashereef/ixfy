//
//  OppurtunityListingViewController.m
//  fixify
//
//  Created by Aliya  on 19/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "OppurtunityListingViewController.h"
#import "AnnotationView.h"
#import "HMSegmentedControl.h"
#import "JobOppurtunityCellTableViewCell.h"

@interface OppurtunityListingViewController ()
{
    HMSegmentedControl *segmentedControl;
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
    self.jobMapView.hidden = YES;
    //_mapView.showsUserLocation = YES;
    [self addSegmentedControl];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_blurred"]];
    self.navigationItem.title= @"Oppurtunities";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"DINAlternate-Bold" size:20.0]};
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
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)segmentedControlChangedValue:(UISegmentedControl *)sender{
    if(segmentedControl.selectedSegmentIndex == 0){
        self.listView.hidden = NO;
        self.mapView.hidden = YES;
    }else if(segmentedControl.selectedSegmentIndex == 1){
        self.mapView.hidden = NO;
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
    JobOppurtunityCellTableViewCell *cell = (JobOppurtunityCellTableViewCell*)[tableView dequeueReusableCellWithIdentifier:JobOppurtunityCellID];
    if(cell == nil){
        cell = [[JobOppurtunityCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JobOppurtunityCellID];
    }
    cell.jobTitle.text = @"Window Repair";
    cell.jobDescription.text = @"So i need some one to cook my food and help me repair my kitchen window";
    cell.jobDistance.text = @"150 m";
    cell.jobEstimates.text = @"120 Estimates";
    cell.jobListedDate.text = @"Listed:12 Apr 2014";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (void)addSegmentedControl{
    segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"List",@"Map"]];
    segmentedControl.frame = CGRectMake(0, 66, 320, 40);
    segmentedControl.tintColor = [UIColor whiteColor];
    segmentedControl.backgroundColor = [UIColor clearColor];
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
}

- (void)menuButtonAction{
}

- (void)feedbackButtonAction{
}

@end
