//
//  WelcomeScreenViewController.m
//  fixify
//
//  Created by qbadmin on 01/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "WelcomeScreenViewController.h"
#import "AppTourCell.h"

@interface WelcomeScreenViewController ()

@end

@implementation WelcomeScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_blurred"]];
    [self setUpView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIView animateWithDuration:2.0
                          delay: 1.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         _background.alpha = 0.0;
                     }
                     completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection View Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
	AppTourCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (cell==nil)
    {
        cell=[[AppTourCell alloc]init];
    }
    cell.logo.image =[UIImage imageNamed:@"logo_signIn"];
    cell.description.text = @"Book and manage urgent home repairs, using local trade professionals.";
    cell.subTitle.text = @"Don't DIY - fixify";
	int pages = floor(_appTour.contentSize.width / _appTour.frame.size.width);
    [_pageControl setNumberOfPages:pages];
	return cell;
}

#pragma mark - UIScrollVewDelegate for UIPageControl

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat pageWidth = _appTour.frame.size.width;
    float currentPage = _appTour.contentOffset.x / pageWidth;
    if (0.0f != fmodf(currentPage, 1.0f)) {
        _pageControl.currentPage = currentPage + 1;
    } else {
        _pageControl.currentPage = currentPage;
    }
}

- (void)setUpView{
    //self.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.hidden= YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
