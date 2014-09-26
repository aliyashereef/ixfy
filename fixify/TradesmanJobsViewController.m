//
//  TradesmanJobsViewController.m
//  fixify
//
//  Created by Aliya  on 24/09/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "TradesmanJobsViewController.h"

@interface TradesmanJobsViewController (){
    NSArray *jobArray;
    FixifyJob *activeJob;
}

@end

@implementation TradesmanJobsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    activeJob = [[FixifyJob alloc]init];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_blurred"]];
    jobArray = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"JobList"ofType:@"plist"]];
    self.viewTitleLabel.text = @"test";
    
}
#pragma mark - Collection View Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_myJobArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MyJobsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TRADESMAN_JOBS_COLLECTIONVIEWCELL_ID" forIndexPath:indexPath];
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    activeJob = [_myJobArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"TRADESMAN_JOB_DETAIL" sender:self];
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

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"TRADESMAN_JOB_DETAIL"]) {
        JobDetailViewController *viewController = (JobDetailViewController *)segue.destinationViewController;;
        viewController.job = activeJob;
    }
}
@end
