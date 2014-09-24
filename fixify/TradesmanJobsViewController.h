//
//  TradesmanJobsViewController.h
//  fixify
//
//  Created by Aliya  on 24/09/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyJobsCollectionViewCell.h"
#import "FixifyJob.h"
#import "FixifyUser.h"
#import <Parse/Parse.h>
#import "JobDetailViewController.h"

@interface TradesmanJobsViewController : UIViewController<
UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *myJobs;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong, nonatomic) NSArray *myJobArray;
@property (weak, nonatomic) IBOutlet UILabel *viewTitleLabel;

- (IBAction)backButtonAction:(id)sender;

@end
