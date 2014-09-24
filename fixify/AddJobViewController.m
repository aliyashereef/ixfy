//
//  AddJobViewController.m
//  fixify
//
//  Created by Vineeth on 11/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "AddJobViewController.h"
#import "CategoryCell.h"
#import "FixifyUser.h"
#import "FixifyJob.h"
#import <Parse/Parse.h>
#import "EditProfileViewController.h"
#import "ChooseAdressViewController.h"

@interface AddJobViewController (){
    UIButton *menuButton;
    UIButton *notificationButton;
    UIBarButtonItem *leftButton;
    UIBarButtonItem *rightButton;
    NSMutableArray *jobArray;
    FixifyJob *job;
}

@end

@implementation AddJobViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title= kViewTitle;
    self.view.backgroundColor = kThemeBackground;
    self.menuView.backgroundColor = kThemeBackground;
    self.userAvatar.layer.cornerRadius = self.userAvatar.frame.size.width / 2;
    self.userAvatar.clipsToBounds = YES;
    job = [[FixifyJob alloc]init];
    jobArray = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:kPlistName ofType:@"plist"]];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView Delegates and Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return jobArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CategoryCell *cell = (CategoryCell*)[tableView dequeueReusableCellWithIdentifier:kCategoryCellID];
    if(cell == nil){
        cell = [[CategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCategoryCellID];
    }
    NSDictionary  *jobDictionary = [[NSDictionary alloc]init];
    jobDictionary = [jobArray objectAtIndex:indexPath.row ];
    cell.categoryName.text = [jobDictionary objectForKey:kPlistTitle];
    cell.categoryName.textColor = kThemeBrown;
    cell.categoryImage.image = [UIImage imageWithData:[jobDictionary objectForKey:kPlistImage]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    job.category = indexPath.row ;
    [self performSegueWithIdentifier:kChooseAddressViewSegue sender:nil];
}

#pragma mark - Bar Button Actions

- (IBAction)menuButton:(id)sender {
    [Utilities showAnimationForView:self.menuView];
}

- (IBAction)notificationButton:(id)sender {
}

#pragma mark - Menu View Button Actions

- (IBAction)signOutAction:(id)sender {
    [FixifyUser logOut];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:kLoginStatus];
    [defaults synchronize];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)menuCloseButton:(id)sender {
    [Utilities hideAnimationForView:self.menuView];
}

- (IBAction)profileView:(id)sender {
    [self performSegueWithIdentifier:kEditProfileViewSegue sender:nil];
}

- (IBAction)myJobsButtonAction:(id)sender {
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:kMyJobsViewControllerID];
    [self presentViewController:controller animated:NO completion:nil];
}

#pragma mark - Navigation Methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:kEditProfileViewSegue]) {
        EditProfileViewController *editProfileViewController = (EditProfileViewController *)segue.destinationViewController;
        editProfileViewController.user = [FixifyUser currentUser];
    }else if([segue.identifier isEqualToString:kChooseAddressViewSegue]){
        ChooseAdressViewController *chooseAdressViewController = (ChooseAdressViewController *)segue.destinationViewController;
        chooseAdressViewController.job = job;
    }
}

@end
