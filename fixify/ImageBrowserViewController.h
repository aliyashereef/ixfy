//
//  ImageBrowserViewController.h
//  fixify
//
//  Created by Aliya  on 01/10/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageBrowserViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *pageImages;
@property (nonatomic, strong) NSMutableArray *pageViews;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;

- (IBAction)doneButton:(id)sender;

@end
