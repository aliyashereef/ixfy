//
//  MyJobsViewController.m
//  fixify
//
//  Created by Aliya  on 02/09/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "MyJobsViewController.h"

@interface MyJobsViewController ()

@end

@implementation MyJobsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_blurred"]];
    [self getJobs];

}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - Collection View Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_myJobArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
	MyJobsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MY_JOBS" forIndexPath:indexPath];
    if (cell==nil){
        cell=[[MyJobsCollectionViewCell alloc] init];
    }
    FixifyJob *myJob = [_myJobArray objectAtIndex:indexPath.row];
    cell.myJobCategoryLabel.text = myJob.category;
    cell.myJobDescriptionLabel.text = myJob.description;
	int pages = floor(_myJobs.contentSize.width / _myJobs.frame.size.width);
    [_pageControl setNumberOfPages:pages];
	return cell;
}

#pragma mark - UIScrollVewDelegate for UIPageControl

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat pageWidth = _myJobs.frame.size.width;
    float currentPage = _myJobs.contentOffset.x / pageWidth;
    if (0.0f != fmodf(currentPage, 1.0f)) {
        _pageControl.currentPage = currentPage + 1;
    } else {
        _pageControl.currentPage = currentPage;
    }
}

- (void)getJobs{
    PFQuery *query =[FixifyJob query];
    [query whereKey:@"owner" equalTo:[FixifyUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        _myJobArray = [objects mutableCopy];
        [self.myJobs reloadData];
        
    }];
    
}
@end
