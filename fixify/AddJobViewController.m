//
//  AddJobViewController.m
//  fixify
//
//  Created by qbadmin on 11/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "AddJobViewController.h"
#import "CategoryCell.h"
#import "ParseUtilities.h"
#import <Parse/Parse.h>

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
    self.menuView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_blurred"]];
    self.menuView.alpha = 0.95f;
    
    self.userAvatar.layer.cornerRadius = self.userAvatar.frame.size.width / 2;
    self.userAvatar.clipsToBounds = YES;
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
- (IBAction)menuButton:(id)sender {
    float offset = self.menuView.frame.size.width;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.75];
    [UIView  setAnimationDelegate:self];
    CGRect newFrame = self.menuView.frame;
    newFrame.origin.x = newFrame.origin.x + offset;
    self.menuView.frame = newFrame;
    [UIView commitAnimations];

}
- (IBAction)signOutAction:(id)sender {
    PFUser *user = [PFUser currentUser];
    ParseUtilities *parse = [[ParseUtilities alloc]init];
    [parse LogOutWithUser:user];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)notificationButton:(id)sender {
}

- (IBAction)menuCoseButton:(id)sender {
    float offset = -self.menuView.frame.size.width;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.75];
    [UIView  setAnimationDelegate:self];
    CGRect newFrame = self.menuView.frame;
    newFrame.origin.x = newFrame.origin.x + offset;
    self.menuView.frame = newFrame;
    [UIView commitAnimations];
}

@end
