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

- (void)viewDidLoad{
    self.appTour.hidden = YES;
    self.pageControl.hidden = YES;
    [super viewDidLoad];
    [self setUpView];
    [self animateView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - Collection View Methods
#pragma mark

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
	AppTourCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
   
    if (cell==nil){
        cell=[[AppTourCell alloc] init];
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

#pragma mark - Private Methods
- (void)setUpView{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_blurred"]];
    self.navigationController.navigationBar.hidden= YES;
}

#pragma mark - Animate Logo
- (void)animateView{
    CGFloat animeViewNewVerticalDistance   = 48.0f;
    CGFloat animeViewNewHeight             = 124.0f;
    CGFloat animeViewNewWidth              = 116.0f;
    CGFloat animeViewNewHorizontalDistance = 102.0f;
    
    [UIView animateWithDuration:1.0f
                          delay:1.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         _background.alpha = 0.0f;
                                             }
                     completion:^ (BOOL finished){
                         if (finished) {
                             [UIView animateWithDuration:1.5f
                                                   delay:1.0f
                                                 options: UIViewAnimationOptionCurveLinear
                                              animations:^{
                                                  self.animeViewVerticalConstraint.constant     = animeViewNewVerticalDistance;
                                                  self.animeViewHeightConstraint.constant       = animeViewNewHeight;
                                                  self.animeViewWidthConstraint.constant        = animeViewNewWidth;
                                                  self.animeViewHorizontalConstraint.constant   = animeViewNewHorizontalDistance;
                                                  self.animeView.clipsToBounds                  = YES;
                                                  [self.animeView layoutIfNeeded];
                                                  
                                              }completion:^ (BOOL finished){
                                                  if (finished){
                                                      self.animeView.hidden      = YES;
                                                      self.appTour.hidden        = NO;
                                                      self.pageControl.hidden    = NO;
                                                  }
                                              }];
                         }
                     }];
}
@end
