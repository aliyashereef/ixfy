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
    self.tradesmanImage.layer.cornerRadius = self.tradesmanImage.frame.size.width / 2;
    self.tradesmanImage.clipsToBounds = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: kThemeBrown,NSFontAttributeName:[UIFont fontWithName:@"DINAlternate-Bold" size:20.0]};
    self.navigationItem.title= @"Job Detail";
    UIBarButtonItem *backButton =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"previous_white"]
                                        style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(backButtonAction)];
    UIBarButtonItem *addButton =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"add_job"] style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(addButtonAction)];
    backButton.tintColor= kThemeBrown;
    self.navigationItem.leftBarButtonItem = backButton;
    addButton.tintColor = kThemeBrown;
    self.navigationItem.rightBarButtonItem = addButton;
    CGSize requiredSize =[Utilities getRequiredSizeForText:_descriptionLabel.text
                                                                 font:[UIFont fontWithName:@"DINAlternate-Bold" size:12]
                                                             maxWidth:_descriptionLabel.frame.size.width];
    _descriptionLabelHeight.constant = requiredSize.height +1;
    PFFile *imageFile=[FixifyUser currentUser].image;
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

- (void)backButtonAction{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)addButtonAction{
}

#pragma mark - Collection View Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JobImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kJObImageCellID forIndexPath:indexPath];
    if (cell==nil){
        cell=[[JobImageCollectionViewCell alloc] init];
    }
    cell.jobImage.image = [UIImage imageNamed:@"window.jpg"];
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
    int r = arc4random() % 10;
    if (r%2 ==0) {
        _jobCompletedViewHeight.constant = 0;
    }else{
        _jobProgressViewHeight.constant = 0;
    }
}

@end
