//
//  WelcomeScreenViewController.h
//  fixify
//
//  Created by qbadmin on 01/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeScreenViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UICollectionView *appTour;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end
