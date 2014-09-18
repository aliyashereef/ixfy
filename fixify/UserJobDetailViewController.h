//
//  UserJobDetailViewController.h
//  fixify
//
//  Created by Aliya  on 28/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "FixifyJob.h"
#import "FixifyUser.h"

@interface UserJobDetailViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDataSource,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

- (IBAction)backButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *countOfEstimates;
@property (weak, nonatomic) IBOutlet UILabel *jobCreatedAt;
@property (weak, nonatomic) IBOutlet UICollectionView *jobImageCollectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControlForCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *jobDescription;

@property (weak, nonatomic) IBOutlet UISegmentedControl *estimatesOrCommentsSegmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *estimatesOrCommentsTableView;
@property (weak, nonatomic) FixifyJob *myJob;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jobDescriptionLabelHeight;

@property (weak, nonatomic) IBOutlet UIButton *estimateFilterButton;


@property (strong, nonatomic) NSArray *estimatesArray;

@end
