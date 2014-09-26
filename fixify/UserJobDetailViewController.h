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
#import "FixifyComment.h"
#import "CommentsTableViewCell.h"

@interface UserJobDetailViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDataSource,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,SwipeableCellDelegate>

- (IBAction)backButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *countOfEstimates;
@property (weak, nonatomic) IBOutlet UILabel *jobCreatedAt;
@property (weak, nonatomic) IBOutlet UILabel *jobDescription;
@property (weak, nonatomic) IBOutlet UILabel *jobStatusLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *jobImageCollectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControlForCollectionView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *estimatesOrCommentsSegmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *estimatesOrCommentsTableView;
@property (weak, nonatomic) IBOutlet UIButton *estimateFilterButton;
@property (weak, nonatomic) IBOutlet UIImageView *jobStatusImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewContentSize;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jobStatusViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jobDescriptionLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *estimatesOrCommentsViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tradesmanProfileViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *makePaymentViewHeight;

@property (strong, nonatomic) FixifyJob *myJob;
@property (strong, nonatomic) NSArray *estimatesArray;
@property (strong, nonatomic) NSArray *commentsArray;

@end
