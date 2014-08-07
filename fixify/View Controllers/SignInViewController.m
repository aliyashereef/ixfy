//
//  SignInViewController.m
//  fixify
//
//  Created by qbadmin on 01/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "SignInViewController.h"
#import <Parse/Parse.h>

@interface SignInViewController ()

@end

@implementation SignInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setUpView];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
#pragma mark - Private Functions 

- (void)closeButtonAction{
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

- (void)setUpView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_blurred"]];
    self.navigationItem.title= @"Sign In";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"DINAlternate-Bold" size:15.0]};
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *closeButton =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"close"]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(closeButtonAction)];
    closeButton.tintColor= [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = closeButton;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _emailField) {
        [_passwordField becomeFirstResponder];
    } else if (textField == _passwordField) {
        [_passwordField resignFirstResponder];
        [self signInButtonAction:nil];
    }
        return NO;
}

- (IBAction)signInButtonAction:(id)sender {
    [PFUser logInWithUsernameInBackground:self.emailField.text password:self.passwordField.text block:^(PFUser *user, NSError *error)
     {
         if (!error) {
             if (user){
                 NSLog(@"sign in");
            }
         }
         else
         {
             //Some error  has ocurred in login process
             NSString *errorString = [[error userInfo] objectForKey:@"error"];
             if ([errorString isEqualToString:@"invalid login credentials"]) {
                 _passwordView.layer.borderColor = [UIColor redColor].CGColor;
                 _emailView.layer.borderColor = [UIColor redColor].CGColor;
                 _passwordView.layer.borderWidth = 1.0f;
                 _emailView.layer.borderWidth = 1.0f;
                 //_errorImage.image = [UIImage imageNamed:@""
             }
             UIAlertView *errorAlertView = [[UIAlertView alloc]
                                            initWithTitle:@"Error"
                                            message:errorString
                                            delegate:nil
                                            cancelButtonTitle:@"Ok"
                                            otherButtonTitles:nil, nil];
             [errorAlertView show];
         }
     }];
}

@end
