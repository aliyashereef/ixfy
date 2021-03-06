//
//  MyJobsViewController.m
//  fixify
//
//  Created by Aliya  on 02/09/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "MyJobsViewController.h"
#import "UserJobDetailViewController.h"

@interface MyJobsViewController (){
    NSArray *jobArray;
    FixifyJob *activeJob;
}

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
    activeJob = [[FixifyJob alloc]init];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_blurred"]];
    jobArray = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"JobList"ofType:@"plist"]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    MyJobsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MY_JOBS_COLLECTIONVIEWCELL_ID" forIndexPath:indexPath];
    if (cell == nil){
        cell = [[MyJobsCollectionViewCell alloc] init];
    }
    cell.myJobImage.layer.cornerRadius = cell.myJobImage.frame.size.width / 2;
    cell.myJobImage.clipsToBounds = YES;
    FixifyJob *myJob = _myJobArray[indexPath.row];
    NSDictionary  *jobDictionary = [[NSDictionary alloc]init];
    jobDictionary = [jobArray objectAtIndex:myJob.category];
    cell.jobCategoryImage.image = [UIImage imageWithData:[jobDictionary objectForKey:@"image"]];
    cell.myJobCategoryLabel.text = [jobDictionary objectForKey:@"title"];
    cell.myJobImage.image = [UIImage imageWithData:[NSData dataWithData:[myJob.imageArray objectAtIndex:0]]];
        cell.myJobDescriptionLabel.text = myJob.jobDescription;
	int pages = floor(_myJobs.contentSize.width / _myJobs.frame.size.width);
    [_pageControl setNumberOfPages:pages];
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    activeJob = [_myJobArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"MY_JOB_DETAIL_VIEW" sender:self];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
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

#pragma mark - Private Methods

- (void)getJobs{
    PFQuery *query = [FixifyJob query];
    [query whereKey:@"owner" equalTo:[FixifyUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        _myJobArray = [objects mutableCopy];
        [self.myJobs reloadData];
    }];
}

- (IBAction)addJobButtonAction:(id)sender {
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:kAddJobViewControllerID];
    [self presentViewController:controller animated:NO completion:nil];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"MY_JOB_DETAIL_VIEW"]) {
        UserJobDetailViewController *viewController = (UserJobDetailViewController *)segue.destinationViewController;;
        viewController.myJob = activeJob;
    }
}
@end
