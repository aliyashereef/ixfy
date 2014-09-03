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
    UIBarButtonItem *leftButton;
    UIButton *notificationButton;
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
    self.navigationItem.title= @"Add a Job";
    job = [[FixifyJob alloc]init];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_blurred"]];
    self.menuView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_blurred"]];
    self.menuView.alpha = 0.95f;
    self.userAvatar.layer.cornerRadius = self.userAvatar.frame.size.width / 2;
    self.userAvatar.clipsToBounds = YES;
    jobArray =[NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"JobList"ofType:@"plist"]];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView Delegates and Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CategoryCell *cell = (CategoryCell*)[tableView dequeueReusableCellWithIdentifier:kCategoryCellID];
    if(cell == nil){
        cell = [[CategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCategoryCellID];
    }
    NSDictionary  *jobDictionary=[[NSDictionary alloc]init];
    jobDictionary = [jobArray objectAtIndex:indexPath.row ];
    cell.categoryName.text =[jobDictionary objectForKey:@"title"];
    cell.categoryName.textColor = kThemeBrown;
    cell.categoryImage.image = [UIImage imageWithData:[jobDictionary objectForKey:@"image"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    job.category = indexPath.row ;
    [self performSegueWithIdentifier:@"CHOOSE_ADRESS" sender:nil];
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
    [FixifyUser logOut];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:kLoginStatus];
    [defaults synchronize];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)notificationButton:(id)sender {
}

- (IBAction)menuCloseButton:(id)sender {
    float offset = -self.menuView.frame.size.width;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.75];
    [UIView  setAnimationDelegate:self];
    CGRect newFrame = self.menuView.frame;
    newFrame.origin.x = newFrame.origin.x + offset;
    self.menuView.frame = newFrame;
    [UIView commitAnimations];
}

- (IBAction)profileView:(id)sender {
    [self performSegueWithIdentifier:@"EDIT_PROFILE" sender:nil];
}

- (IBAction)myJobsButtonAction:(id)sender {
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MY_JOBS"];
    [self presentViewController:controller animated:NO completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"EDIT_PROFILE"]) {
        EditProfileViewController *editProfileViewController = (EditProfileViewController *)segue.destinationViewController;
        editProfileViewController.user = [FixifyUser currentUser];
    }else if([segue.identifier isEqualToString:@"CHOOSE_ADRESS"]){
        ChooseAdressViewController *chooseAdressViewController = (ChooseAdressViewController *)segue.destinationViewController;
        chooseAdressViewController.job = job;
    }
}
@end
