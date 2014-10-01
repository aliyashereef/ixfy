//
//  JobDetailViewController.h
//  fixify
//
//  Created by Aliya  on 21/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FixifyJob.h"
#import "SubmitQuoteViewController.h"
#import "CommentsTableViewCell.h"
#import "FixifyComment.h"

@interface JobDetailViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,SwipeableCellDelegate>


@property (weak, nonatomic) IBOutlet UIScrollView *detailScrollView;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UIView *profileView;
@property (weak, nonatomic) IBOutlet UIImageView *tradesmanImage;
@property (weak, nonatomic) IBOutlet UIView *jobCompletedView;
@property (weak, nonatomic) IBOutlet UIView *jobProgressView;

@property (weak, nonatomic) IBOutlet UILabel *listedDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *noOfEstimatesLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UICollectionView *jobImageCollectionView;

@property (weak, nonatomic) IBOutlet UILabel *tradesmanName;
@property (weak, nonatomic) IBOutlet UIButton *profileViewButton;
- (IBAction)cancelWorkingButtonAction:(id)sender;

- (IBAction)jobCompletedButtonAction:(id)sender;
- (IBAction)submitEstimateButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jobCompletedViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jobStatusViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *jobStatusImage;
@property (weak, nonatomic) IBOutlet UILabel *jobStatusLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jobProgressViewHeight;
- (IBAction)backButtonAction:(id)sender;
@property (weak, nonatomic) FixifyJob *job;
@property (strong, nonatomic) NSArray *estimatesForJob;
@property (strong, nonatomic) NSArray *commentsForJob;
@property (weak, nonatomic) IBOutlet UILabel *jobDetailLabel;
- (IBAction)postCommentButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;



@end
