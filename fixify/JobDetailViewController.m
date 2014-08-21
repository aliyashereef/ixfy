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
    [self presentView];
    self.tradesmanImage.layer.cornerRadius = self.tradesmanImage.frame.size.width / 2;
    self.tradesmanImage.clipsToBounds = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title= @"Job Detail";
    UIBarButtonItem *backButton =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"previous_white"]
                                        style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(backButtonAction)];
    UIBarButtonItem *addButton =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"add_job"] style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(addButtonAction)];
    backButton.tintColor= [UIColor colorWithRed:(float)140/255 green:(float)131/255 blue:(float)123/255 alpha:1];
    self.navigationItem.leftBarButtonItem = backButton;
    addButton.tintColor = [UIColor colorWithRed:(float)140/255 green:(float)131/255 blue:(float)123/255 alpha:1];
    self.navigationItem.rightBarButtonItem = addButton;
    PFFile *imageFile=[FixifyUser currentUser].image;
    [imageFile getDataInBackgroundWithBlock:^(NSData *result, NSError *error) {
        if (!error){
            self.tradesmanImage.image = [UIImage imageWithData:result];
        }
    }];
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
    cell.commentLabel.text = @"Does the window have double glazing?";
    return cell;
}

- (void)presentView{
    int r = arc4random() % 10;
    if (r%2 ==0) {
    }else{
    }
}

@end
