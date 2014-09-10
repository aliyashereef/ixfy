//
//  MyJobsViewController.h
//  fixify
//
//  Created by Aliya  on 02/09/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyJobsCollectionViewCell.h"
#import "FixifyJob.h"
#import "FixifyUser.h"
#import <Parse/Parse.h>

@interface MyJobsViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *myJobs;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong, nonatomic) NSMutableArray *myJobArray;
- (IBAction)addJobButtonAction:(id)sender;

@end
