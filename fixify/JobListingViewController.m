//
//  JobListingViewController.m
//  fixify
//
//  Created by Aliya  on 19/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "JobListingViewController.h"

@interface JobListingViewController ()

@end

@implementation JobListingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_blurred"]];
    self.navigationItem.title= @"Job Listing";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"DINAlternate-Bold" size:20.0]};
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *menuButton =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_menu"]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(menuButtonAction)];
    UIBarButtonItem *feedbackButton =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_menu_feedback"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(feedbackButtonAction)];
    menuButton.tintColor= [UIColor whiteColor];
    feedbackButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = menuButton;
    self.navigationItem.rightBarButtonItem = feedbackButton;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)menuButtonAction{
}

- (void)feedbackButtonAction{
}

@end
