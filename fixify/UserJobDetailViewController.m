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
#import "EstimateDetailViewController.h"
#import "AddCommentViewController.h"
#import "ImageBrowserViewController.h"
#import "CommentReplyTableViewCell.h"

@interface UserJobDetailViewController (){
    FixifyJobEstimates *selectedEstimate;
    NSInteger parentCommentID;
    NSMutableArray *replyArray;
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
    replyArray = [[NSMutableArray alloc]init];
    selectedEstimate = [[FixifyJobEstimates alloc]init];
    [_estimatesOrCommentsSegmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods

- (void) prepareJobStatusAnimation :(NSArray *)imageArray{
    NSMutableArray *images = [[NSMutableArray alloc]init];
    for (NSString *imageName in imageArray ) {
        [images addObject:[UIImage imageNamed:imageName]];
    }
    _jobStatusImage.animationImages = images;
    _jobStatusImage.animationDuration = 0.5;
    [_jobStatusImage startAnimating];
}

- (void)segmentedControlChangedValue:(UISegmentedControl *)sender{
    [self.estimatesOrCommentsTableView reloadData];
}

- (IBAction)backButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateView{
    [self fetchEstimates];
    [self fetchComments];
    if ([_myJob.status isEqualToString: kInProgressJob ]) {
        [self prepareJobStatusAnimation :kJobProgressImageArray];
        self.jobStatusLabel.text = kInProgressJob ;
        self.estimatesOrCommentsViewHeight.constant = 0;
        self.makePaymentViewHeight.constant = 0;
    }else if([_myJob.status isEqualToString:kPaymentRequired]){
        [self prepareJobStatusAnimation :kJobPaymentRequiredImageArray];
        self.jobStatusLabel.text = kPaymentRequired ;
        self.estimatesOrCommentsViewHeight.constant = 0;
    }else if([_myJob.status isEqualToString:kNewJob]){
        self.jobStatusViewHeight.constant = 0;
        self.makePaymentViewHeight.constant = 0;
        self.tradesmanProfileViewHeight.constant = 0;
    }else if([_myJob.status isEqualToString:kEstimatedJob]){
        self.jobStatusViewHeight.constant = 0;
        self.tradesmanProfileViewHeight.constant = 0;
        self.makePaymentViewHeight.constant = 0;
    }else if([_myJob.status isEqualToString:kJobCompleted]){
        self.jobStatusViewHeight.constant = 0;
        self.estimatesOrCommentsViewHeight.constant = 0;
        self.makePaymentViewHeight.constant = 0;
    }
    self.jobDescription.text = _myJob.jobDescription ;
    CGSize requiredSize = [Utilities getRequiredSizeForText:self.jobDescription.text
                                                       font:kThemeFont
                                                   maxWidth:self.jobDescription.frame.size.width];
    self.jobDescriptionLabelHeight.constant = requiredSize.height + 1 ;
    _contentViewHeight.constant = 300 + self.jobDescriptionLabelHeight.constant ;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        if (screenSize.height == 480) {
            _contentViewHeight.constant = _contentViewHeight.constant - 90.0f;
        }
    }
    self.scrollViewContentSize.constant = _contentViewHeight.constant + _jobStatusViewHeight.constant + _estimatesOrCommentsViewHeight.constant + _tradesmanProfileViewHeight.constant + _makePaymentViewHeight.constant + _jobStatusViewHeight.constant ;
    self.jobCreatedAt.text =[NSString stringWithFormat:@"Listed : %@",[Utilities formatDate: _myJob.createdAt]];
}

- (void)fetchEstimates {
    PFQuery *estimatesQuery = [FixifyJobEstimates query];
    [estimatesQuery whereKey:@"status" equalTo:kNewJob ];
    [estimatesQuery whereKey:@"status" equalTo:kEstimatedJob];
    [estimatesQuery whereKey:@"job" equalTo:_myJob];
    [estimatesQuery includeKey:@"owner"];
    [estimatesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            _estimatesArray = [objects mutableCopy];
            _countOfEstimates.text = [NSString stringWithFormat:@"%d Estimates",_estimatesArray.count];
            [_estimatesOrCommentsSegmentedControl setTitle:[NSString stringWithFormat:@"Estimates [%d]",_estimatesArray.count]
                                         forSegmentAtIndex:0 ];
            [self.estimatesOrCommentsTableView reloadData];
        }
    }];
}

- (void)fetchComments {
    PFQuery *commentQuery = [FixifyComment query];
    [commentQuery whereKey:@"job" equalTo: _myJob];
    [commentQuery whereKey:@"parentComment" equalTo:[NSNull null]];
    [commentQuery includeKey:@"author"];
    [commentQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            _commentsArray = [objects mutableCopy];
            [_estimatesOrCommentsSegmentedControl setTitle:[NSString stringWithFormat:@"Comments [%d]",_commentsArray.count]
                                         forSegmentAtIndex:1 ];
            [self.estimatesOrCommentsTableView reloadData];
            [self addReplyForComments];
        }
    }];
}

- (void) addReplyForComments  {
    for (FixifyComment *comment in _commentsArray) {
        if (!comment.parentComment) {
            PFRelation *reply = comment.replies;
            [[reply query] includeKey:@"author"];
            [[reply query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    replyArray = [objects mutableCopy];
                    NSInteger index = [_commentsArray indexOfObject: comment];
                    NSRange range = NSMakeRange(index+1,[replyArray count]);
                    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
                    [_commentsArray insertObjects:replyArray atIndexes:indexSet];
                    }
            }];
        }
    }
    [self.estimatesOrCommentsTableView reloadData];
}

#pragma mark - Collection View Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _myJob.imageArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:kFullScreenImageView sender:self];}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
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
    if (_estimatesOrCommentsSegmentedControl.selectedSegmentIndex == 0) {
        return _estimatesArray.count;
    }else{
        return _commentsArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    FixifyComment *comment = [_commentsArray objectAtIndex:indexPath.row];
    if (comment.parentComment) {
        return kReplyCellRowHeight;
    } else {
        return kCommentCellRowHeight;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_estimatesOrCommentsSegmentedControl.selectedSegmentIndex == 0) {
        selectedEstimate = [_estimatesArray objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:kEstimateDetailViewSegue sender:self];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (_estimatesOrCommentsSegmentedControl.selectedSegmentIndex == 0) {
        cell = (EstimatesTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kEstimateCellID];
        if(cell == nil){
            cell = [[EstimatesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kEstimateCellID];
        }
        [self configureEstimateCell:cell forRowAtIndexPath:indexPath];
    }else{
        FixifyComment *comment = [_commentsArray objectAtIndex:indexPath.row];
        if (comment.parentComment) {
            cell = (CommentReplyTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kUserJobDetailViewReplyCellID];
            if(cell == nil){
                cell = [[CommentReplyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kUserJobDetailViewReplyCellID];
            }
            [self configureReplyCell:cell forRowAtIndexPath:indexPath];
        }else{
            cell = (CommentsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kUserJobDetailViewCommentCellID];
            if(cell == nil){
                cell = [[CommentsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kUserJobDetailViewCommentCellID];
            }
            [self configureCommentCell:cell forRowAtIndexPath:indexPath];
        }
    }
    return cell;
}

- (void)configureEstimateCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    EstimatesTableViewCell *estimateCell = (EstimatesTableViewCell *)cell;
    FixifyJobEstimates *estimate = [_estimatesArray objectAtIndex:indexPath.row];
    estimateCell.tradesmanAvatar.layer.cornerRadius =  estimateCell.tradesmanAvatar.frame.size.width / 2;
    estimateCell.tradesmanAvatar.clipsToBounds = YES;
    estimateCell.tradesmanName.text = estimate.owner.fullName ;
    [estimate.owner.image getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            estimateCell.tradesmanAvatar.image = [UIImage imageWithData:imageData];
        }
    }];
    estimateCell.estimateAmount.text = [NSString stringWithFormat:@"%@", estimate.amount] ;
}

- (void)configureCommentCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentsTableViewCell *commentCell = (CommentsTableViewCell *)cell;
    commentCell.delegate = self;
    commentCell.flagButtonWidth.constant = 0;
    FixifyComment *commentInCell = [_commentsArray objectAtIndex:indexPath.row];
    commentCell.avatarView.layer.cornerRadius =  commentCell.avatarView.frame.size.width / 2;
    commentCell.avatarView.clipsToBounds = YES;
    [commentInCell.author fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        commentCell.fullName.text = commentInCell.author.fullName ;
        [commentInCell.author.image getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                commentCell.avatarView.image = [UIImage imageWithData:imageData];
            }
        }];
    }];
    commentCell.commentLabel.text = [NSString stringWithFormat:@"%@", commentInCell.commentString] ;
}

- (void)configureReplyCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentReplyTableViewCell *commentCell = (CommentReplyTableViewCell *)cell;
    FixifyComment *commentInCell = [_commentsArray objectAtIndex:indexPath.row];
    commentCell.userImage.layer.cornerRadius =  commentCell.userImage.frame.size.width / 2;
    commentCell.userImage.clipsToBounds = YES;
    [commentInCell.author fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        commentCell.userFullName.text = commentInCell.author.fullName ;
        [commentInCell.author.image getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                commentCell.userImage.image = [UIImage imageWithData:imageData];
            }
        }];
    }];
    commentCell.userReplyText.text = [NSString stringWithFormat:@"%@", commentInCell.commentString] ;
}


#pragma mark - Navigation Methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:kEstimateDetailViewSegue]) {
        EstimateDetailViewController *viewController = segue.destinationViewController;
        viewController.estimate = selectedEstimate;
    }else if ([segue.identifier isEqualToString:kFullScreenImageView]) {
        ImageBrowserViewController *viewController = [segue destinationViewController];
        viewController.pageImages = _myJob.imageArray;
    }

}

#pragma mark - swipable cell delegate

- (void)deleteButtonActionForCell:(UITableViewCell *)cell{
    NSIndexPath *indexPath = [self.estimatesOrCommentsTableView indexPathForCell:cell];
    FixifyComment *deletingComment = [_commentsArray objectAtIndex:indexPath.row];
    [deletingComment deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self fetchComments];
    }];
}
- (void)replyButtonActionForCell:(UITableViewCell *)cell{
    parentCommentID = 1;
    NSIndexPath *indexPath = [self.estimatesOrCommentsTableView indexPathForCell:cell];
    FixifyComment *comment = [_commentsArray objectAtIndex:indexPath.row];
    NSMutableArray *singleComment = [[NSMutableArray alloc]initWithObjects:comment, nil];
    AddCommentViewController *viewController =[self.storyboard instantiateViewControllerWithIdentifier:kAddCommentViewControllerStoryBoardID];
    viewController.job = _myJob;
    viewController.comments = singleComment;
    viewController.parentCommentID = [NSNumber numberWithInteger:parentCommentID];
    [self presentViewController:viewController animated:NO completion:nil];
    
}

@end
