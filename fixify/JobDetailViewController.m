//
//  JobDetailViewController.m
//  fixify
//
//  Created by Aliya  on 21/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "JobDetailViewController.h"
#import "JobImageCollectionViewCell.h"
#import "FixifyUser.h"
#import "FixifyJobEstimates.h"
#import "AddCommentViewController.h"
#import "ImageBrowserViewController.h"

@interface JobDetailViewController (){
    UIImage *activeImage;
}

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
    activeImage = [[UIImage alloc]init];
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
    [self getAllEstimatesForJob];
    [self getAllCommentsForJob];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
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

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    activeImage = [UIImage imageWithData:[_job.imageArray objectAtIndex:indexPath.row]];
    [self performSegueWithIdentifier:@"TradesmanFullScreenImageView" sender:self];}


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
    return _commentsForJob.count;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentsTableViewCell *cell = (CommentsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCommentListID];
    if(cell == nil){
        cell = [[CommentsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCommentListID];
    }
    cell.delegate = self;
    FixifyComment *comment = [_commentsForJob objectAtIndex:indexPath.row];
    if (comment.author == [FixifyUser currentUser]) {
        cell.replyButtonWidth.constant = 0;
        cell.deleteButtonWidth.constant = 0;
    }else{
        cell.replyButtonWidth.constant = 0;
        cell.flagButtonWidth.constant = 0;
    }
    [cell updateConstraintsIfNeeded];
    cell.avatarView.layer.cornerRadius = cell.avatarView.frame.size.width / 2;
    cell.avatarView.clipsToBounds = YES;
    cell.fullName.text = comment.author.fullName ;
    cell.commentLabel.text = comment.commentString ;
    PFFile *imageFile = comment.author.image ;
    [imageFile getDataInBackgroundWithBlock:^(NSData *result, NSError *error) {
        if (!error){
             cell.avatarView.image = [UIImage imageWithData:result];
        }
    }];
    CGSize requiredSize = [Utilities getRequiredSizeForText:cell.commentLabel.text
                                                        font:[UIFont fontWithName:@"DINAlternate-Bold" size:12]
                                                    maxWidth:cell.commentLabel.frame.size.width];
    cell.commentLabelHeight.constant = requiredSize.height + 1;
    return cell;
}

- (void)getAllEstimatesForJob {
    PFQuery *estimatesQuery = [FixifyJobEstimates query];
    [estimatesQuery whereKey:@"job" equalTo: _job];
    [estimatesQuery includeKey:@"owner"];
    [estimatesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            _estimatesForJob = [objects mutableCopy];
            [self showOrHideJobCompletedView];
        }
    }];
}
- (void)getAllCommentsForJob {
    PFQuery *commentsQuery = [FixifyComment query];
    [commentsQuery whereKey:@"job" equalTo:_job];
    [commentsQuery includeKey:@"author"];
    [commentsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            _commentsForJob = [objects mutableCopy];
            [self.commentsTableView reloadData];
        }
    }];
}

- (void)showOrHideJobCompletedView{
    if([_job.status isEqualToString: kNewJob]){
        _jobCompletedViewHeight.constant = 0;
        _jobStatusViewHeight.constant = 0;
    }else if([_job.status isEqualToString: kEstimatedJob]){
        _jobCompletedViewHeight.constant = 0;
        _jobProgressViewHeight.constant = 0;
        _jobStatusViewHeight.constant = 0;
    }else if([_job.status isEqualToString: kInProgressJob]){
        _jobProgressViewHeight.constant = 0;
        [self prepareJobStatusAnimation:kJobProgressImageArray];
        _jobStatusLabel.text = kInProgressJob;
    }else if([_job.status isEqualToString: kPaymentRequired]){
        _jobCompletedViewHeight.constant = 0;
        _jobProgressViewHeight.constant = 0;
        [self prepareJobStatusAnimation:kJobPaymentRequiredImageArray];
        _jobStatusLabel.text = kPaymentRequired;
    }else if([_job.status isEqualToString: kJobCompleted]){
        _jobCompletedViewHeight.constant = 0;
        _jobProgressViewHeight.constant = 0;
        _jobStatusViewHeight.constant = 0;
        UIImageView *jobStatusImage = [[UIImageView alloc]initWithFrame:CGRectMake(245, 50, 80, 80)];
        jobStatusImage.image = [UIImage imageNamed:@"job_complete"];
        [self.detailView addSubview:jobStatusImage];
    }
     _detailViewHeight.constant = 450 + _jobProgressViewHeight.constant+ _jobCompletedViewHeight.constant +_descriptionLabelHeight.constant;
}

- (IBAction)postCommentButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"POST_COMMENT" sender:self];
}

- (IBAction)backButtonAction:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelWorkingButtonAction:(id)sender {
}

- (IBAction)jobCompletedButtonAction:(id)sender {
}

- (IBAction)submitEstimateButtonAction:(id)sender {
}

- (void) prepareJobStatusAnimation :(NSArray *)imageArray{
    NSMutableArray *images = [[NSMutableArray alloc]init];
    for (NSString *imageName in imageArray ) {
        [images addObject:[UIImage imageNamed:imageName]];
    }
    _jobStatusImage.animationImages = images;
    _jobStatusImage.animationDuration = 0.5;
    [_jobStatusImage startAnimating];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString: kSubmitQuoteViewSegue]) {
        SubmitQuoteViewController *viewController = (SubmitQuoteViewController *)segue.destinationViewController;
         viewController.activeJob = _job;
    }else if([segue.identifier isEqualToString:@"POST_COMMENT"]){
        AddCommentViewController *viewController = [segue destinationViewController];
        viewController.job = _job;
        viewController.comments = _commentsForJob;
    }else if ([segue.identifier isEqualToString:@"TradesmanFullScreenImageView"]) {
        ImageBrowserViewController *viewController = [segue destinationViewController];
        viewController.image = activeImage;
    }

}


#pragma mark - swipable cell delegate

- (void)deleteButtonActionForCell:(UITableViewCell *)cell{
    NSIndexPath *indexPath = [self.commentsTableView indexPathForCell:cell];
    FixifyComment *comment = [_commentsForJob objectAtIndex:indexPath.row];
    [comment deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self getAllCommentsForJob];
    }];
}

- (void)replyButtonActionForCell:(UITableViewCell *)cell{
}

- (void)flagButtonActionForCell:(UITableViewCell *)cell{
}

- (void)cellDidClose:(UITableViewCell *)cell{
}

- (void)cellDidOpen:(UITableViewCell *)cell{
}

@end
