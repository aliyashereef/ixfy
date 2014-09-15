//
//  JobDetailViewController.m
//  fixify
//
//  Created by Aliya  on 21/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "JobDetailViewController.h"
#import "JobImageCollectionViewCell.h"
#import "CommentsTableViewCell.h"
#import "FixifyUser.h"

@interface JobDetailViewController ()

@end

@implementation JobDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.jobDetailLabel.text = _job.jobDescription;
    self.tradesmanImage.layer.cornerRadius = self.tradesmanImage.frame.size.width / 2;
    self.tradesmanImage.clipsToBounds = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGSize requiredSize = [Utilities getRequiredSizeForText:_descriptionLabel.text
                                                                 font:kThemeFont
                                                             maxWidth:_descriptionLabel.frame.size.width];
    _descriptionLabelHeight.constant = requiredSize.height +1;
    self.tradesmanName.text = [FixifyUser currentUser].fullName;
    PFFile *imageFile = [FixifyUser currentUser].image;
    [imageFile getDataInBackgroundWithBlock:^(NSData *result, NSError *error) {
        if (!error){
            self.tradesmanImage.image = [UIImage imageWithData:result];
        }
    }];
}
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showOrHideJobCompletedView];
    _detailViewHeight.constant = 445 + _jobProgressViewHeight.constant+ _jobCompletedViewHeight.constant +_descriptionLabelHeight.constant;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (IBAction)cancelWorkingButtonAction:(id)sender {
}

- (IBAction)jobCompletedButtonAction:(id)sender {
}

- (IBAction)submitEstimateButtonAction:(id)sender {
}

#pragma mark - Collection View Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _job.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JobImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kJObImageCellID forIndexPath:indexPath];
    if (cell == nil){
        cell = [[JobImageCollectionViewCell alloc] init];
    }
    cell.jobImage.image = [UIImage imageWithData:[_job.imageArray objectAtIndex:indexPath.row]];
    int pages = floor(_jobImageCollectionView.contentSize.width / _jobImageCollectionView.frame.size.width);
    [_pageControl setNumberOfPages:pages];
	return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 12;
}

#pragma mark - UIScrollVewDelegate for UIPageControl

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat pageWidth = _jobImageCollectionView.frame.size.width;
    float currentPage = _jobImageCollectionView.contentOffset.x / pageWidth;
    if (0.0f != fmodf(currentPage, 1.0f)) {
        _pageControl.currentPage = currentPage + 1;
    } else {
        _pageControl.currentPage = currentPage;
    }
}

#pragma mark - Table View Delagate and datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentsTableViewCell *cell = (CommentsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCommentListID];
    if(cell == nil){
        cell = [[CommentsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCommentListID];
    }
    cell.avatarView.layer.cornerRadius = cell.avatarView.frame.size.width / 2;
    cell.avatarView.clipsToBounds = YES;
    cell.avatarView.image = [UIImage imageNamed:@"window.jpg"];
    cell.fullName.text = @"Andrew Simons";
    cell.commentLabel.text = @"Does the window have double glazing and is it porecelain glass?";
    CGSize requiredSize = [Utilities getRequiredSizeForText:cell.commentLabel.text
                                                        font:[UIFont fontWithName:@"DINAlternate-Bold" size:12]
                                                    maxWidth:cell.commentLabel.frame.size.width];
    cell.commentLabelHeight.constant = requiredSize.height +1;
    return cell;
}

- (void)showOrHideJobCompletedView{
    if ([FixifyUser currentUser].isTradesman) {
        _jobCompletedViewHeight.constant = 0;
    }else{
        _jobProgressViewHeight.constant = 0;
    }
}

- (IBAction)backButtonAction:(id)sender {
     [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString: kSubmitQuoteSegue]) {
        SubmitQuoteViewController *viewController = (SubmitQuoteViewController *)segue.destinationViewController;
         viewController.activeJob = _job;
    }
}
@end
