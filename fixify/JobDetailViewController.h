//
//  JobDetailViewController.h
//  fixify
//
//  Created by Aliya  on 21/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobDetailViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>


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

@end
