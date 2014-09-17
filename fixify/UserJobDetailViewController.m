//
//  UserJobDetailViewController.m
//  fixify
//
//  Created by Aliya  on 28/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "UserJobDetailViewController.h"
#import "JobImageCollectionViewCell.h"
#import "FixifyJobEstimates.h"
#import "CommentsTableViewCell.h"
#import "EstimatesTableViewCell.h"

@interface UserJobDetailViewController (){
    NSInteger tableViewRowCount;
}

@end

@implementation UserJobDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self updateView];
    [_estimatesOrCommentsSegmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)segmentedControlChangedValue:(UISegmentedControl *)sender{
    if(_estimatesOrCommentsSegmentedControl.selectedSegmentIndex == 0){
      tableViewRowCount = _estimatesArray.count;
    }else{
      tableViewRowCount = 2;
    }
    [self.estimatesOrCommentsTableView reloadData];
}

- (IBAction)backButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateView{
    PFQuery *estimatesQuery = [FixifyJobEstimates query];
    [estimatesQuery whereKey:@"job" equalTo:_myJob];
    [estimatesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            _estimatesArray = [objects mutableCopy];
            _countOfEstimates.text = [NSString stringWithFormat:@"%d Estimates",_estimatesArray.count];
            [_estimatesOrCommentsSegmentedControl setTitle:[NSString stringWithFormat:@"Estimates [%d]",_estimatesArray.count]
                                         forSegmentAtIndex:0 ];
            [self.estimatesOrCommentsTableView reloadData];
        }
    }];
    self.jobDescription.text = _myJob.jobDescription ;
    CGSize requiredSize = [Utilities getRequiredSizeForText:self.jobDescription.text
                                                       font:kThemeFont
                                                   maxWidth:self.jobDescription.frame.size.width];
    self.jobDescriptionLabelHeight.constant = requiredSize.height + 1 ;
    _contentViewHeight.constant = _contentViewHeight.constant + self.jobDescriptionLabelHeight.constant ;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        if (screenSize.height == 480) {
            _contentViewHeight.constant = _contentViewHeight.constant - 90.0f;
        }
    }

    self.jobCreatedAt.text =[NSString stringWithFormat:@"Listed : %@",[Utilities formatDate: _myJob.createdAt]];
    [_estimatesOrCommentsSegmentedControl setTitle:[NSString stringWithFormat:@"Comments "] forSegmentAtIndex:1];
}

#pragma mark - Collection View Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _myJob.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JobImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kJObImageCellID forIndexPath:indexPath];
    if (cell == nil){
        cell = [[JobImageCollectionViewCell alloc] init];
    }
    cell.jobImage.image = [UIImage imageWithData:[_myJob.imageArray objectAtIndex:indexPath.row]];
    int pages = floor(_jobImageCollectionView.contentSize.width / _jobImageCollectionView.frame.size.width);
    [_pageControlForCollectionView setNumberOfPages:pages];
	return cell;
}

#pragma mark - UIScrollVewDelegate for UIPageControl

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat pageWidth = _jobImageCollectionView.frame.size.width;
    float currentPage = _jobImageCollectionView.contentOffset.x / pageWidth;
    if (0.0f != fmodf(currentPage, 1.0f)) {
        _pageControlForCollectionView.currentPage = currentPage + 1;
    } else {
        _pageControlForCollectionView.currentPage = currentPage;
    }
}

#pragma mark - UITableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _estimatesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (_estimatesOrCommentsSegmentedControl.selectedSegmentIndex == 0) {
        cell = (EstimatesTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kEstimateCellID];
        if(cell == nil){
            cell = [[EstimatesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kEstimateCellID];
        }
        [self configureCell:cell forRowAtIndexPath:indexPath];
    }else{
        cell = (CommentsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCommentListCellID];
        if(cell == nil){
            cell = [[CommentsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCommentListCellID];
        }
    }
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    EstimatesTableViewCell *estimateCell = (EstimatesTableViewCell *)cell;
    FixifyJobEstimates *estimate = [_estimatesArray objectAtIndex:indexPath.row];
    estimateCell.tradesmanAvatar.layer.cornerRadius =  estimateCell.tradesmanAvatar.frame.size.width / 2;
    estimateCell.tradesmanAvatar.clipsToBounds = YES;
    [estimate.owner fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        estimateCell.tradesmanName.text = estimate.owner.fullName ;
        [estimate.owner.image getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                estimateCell.tradesmanAvatar.image = [UIImage imageWithData:imageData];
            }
        }];
    }];
    estimateCell.estimateAmount.text = [NSString stringWithFormat:@"%@", estimate.amount] ;
}

@end
