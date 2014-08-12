//
//  AddJobViewController.m
//  fixify
//
//  Created by qbadmin on 11/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "AddJobViewController.h"
#import "CategoryCell.h"

@interface AddJobViewController ()
{
    UIButton *menuButton;
    UIBarButtonItem *leftButton;
    UIButton *notificationButton;
    UIBarButtonItem *rightButton;
}

@end

@implementation AddJobViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title= @"Add a Job";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"DINAlternate-Bold" size:20.0]};
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_blurred"]];
    
    [self.navigationController.navigationBar
     setBackgroundImage:[UIImage new]
     forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    UIImage *menuImage = [UIImage imageNamed:@"ic_menu"];
    menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [menuButton setImage:menuImage forState:UIControlStateNormal];
    menuButton.frame = CGRectMake(0.0,0.0,menuImage.size.width,menuImage.size.height);
    
    [menuButton addTarget:self
                    action:@selector(menuButtonClicked)
          forControlEvents:UIControlEventTouchUpInside];
    
    leftButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIImage *notificationImage = [UIImage imageNamed:@"ic_notification"];
    notificationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [notificationButton setImage:notificationImage forState:UIControlStateNormal];
    notificationButton.frame = CGRectMake(0.0,0.0,notificationImage.size.width,notificationImage.size.height);
    
    [notificationButton addTarget:self
                   action:@selector(notificationButtonClicked)
         forControlEvents:UIControlEventTouchUpInside];
    
    rightButton = [[UIBarButtonItem alloc] initWithCustomView:notificationButton];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    self.menuView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_blurred"]];
    self.menuView.alpha = 0.8f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView Delegates and Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CategoryCell *cell = (CategoryCell*)[tableView dequeueReusableCellWithIdentifier:CategoryCellID];
    if(cell == nil)
    {
        cell = [[CategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CategoryCellID];
    }
    cell.categoryName.text = @"Engineer";
    cell.categoryName.textColor = [UIColor colorWithRed:(float)140/255 green:(float)131/255 blue:(float)123/255 alpha:1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - Bar Button Action
- (void)menuButtonClicked{
    static BOOL showMenu = NO;
    float offset;
    if (showMenu) {
        offset = self.menuView.frame.size.width;
    }else{
        offset = -self.menuView.frame.size.width;
    }
    showMenu = !showMenu;
//    [self.menuView transitionWithView:self.view
//                      duration:0.75
//                       options:UIViewAnimationTransitionFlipFromRight
//                    animations:^{
//                        
//                    }
//                    completion:nil];
 
}

- (void)notificationButtonClicked{
    
}

@end
