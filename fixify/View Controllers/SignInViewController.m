//
//  SignInViewController.m
//  fixify
//
//  Created by qbadmin on 01/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "SignInViewController.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "RegisterViewController.h"
#import "ParseUtilities.h"

@interface SignInViewController ()

@end

@implementation SignInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setUpView];
    // Check if user is cached and linked to Facebook, if so, bypass login
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideErrorImage:YES];
    [Utilities setBorderColor:[UIColor clearColor] forView:_emailView];
    [Utilities setBorderColor:[UIColor clearColor] forView:_passwordView];
    _passwordField.text = @"";
}

#pragma mark - Private Functions 

- (BOOL)validAllFields {
    BOOL isValid = YES;
    if([Utilities cleanString:self.emailField.text].length == 0){
        isValid = NO;
        _emailErrorImage.hidden = NO;
        [Utilities setBorderColor:[UIColor redColor] forView:_emailView];
        [self.emailField becomeFirstResponder];
    }else{
        if([Utilities isValidEmail:self.emailField.text]){
            _emailErrorImage.hidden = YES;
            [Utilities setBorderColor:[UIColor clearColor] forView:_emailView];
        } else {
            isValid = NO;
            _emailErrorImage.hidden = NO;
            [Utilities setBorderColor:[UIColor redColor] forView:_emailView];
            [self.emailField becomeFirstResponder];
        }
    }
    if([Utilities cleanString:self.passwordField.text].length == 0) {
        isValid = NO;
        _passwordErrorImage.hidden = NO;
        [Utilities setBorderColor:[UIColor redColor] forView:_passwordView];
    } else {
        _passwordErrorImage.hidden = YES;
        [Utilities setBorderColor:[UIColor clearColor] forView:_passwordView];
    }
    return isValid;
}

//  Validating email fields.
- (BOOL)validateEmail:(NSString *)email {
    BOOL isValid = YES;
    if([Utilities cleanString:email].length == 0) {
        isValid = NO;
    } else {
        if(![Utilities isValidEmail:email]) {
            isValid = NO;
        }
    }
    return isValid;
}

- (void)closeButtonAction{
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

//To set up the view .
- (void)setUpView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_blurred"]];
    self.navigationItem.title= @"Sign In";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"DINAlternate-Bold" size:20.0]};
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

//Perform the parse API login.
- (void)login{
    PFUser *user = [PFUser user];
    user.username = self.emailField.text;
    user.password = self.passwordField.text;
    ParseUtilities *parse = [[ParseUtilities alloc] init];

    [parse logInWithUser:user requestSucceeded:^(PFUser *user){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kLoginStatus];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kLoggedInWithFacebook];
        [[NSUserDefaults standardUserDefaults] synchronize];
        }requestFailed:^(NSError *error){
            //Some error  has ocurred in login process
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            if ([errorString isEqualToString:@"invalid login credentials"]) {
                [Utilities setBorderColor:[UIColor redColor] forView:_emailView];
                [Utilities setBorderColor:[UIColor redColor] forView:_passwordView];
                [self hideErrorImage:NO];
            }else{
                [Utilities showAlertWithTitle:@"Error" message:errorString];
            }
        }];
}

- (IBAction)signInButtonAction:(id)sender {
    if ([self validAllFields]) {
        [self login];
        [self performSegueWithIdentifier:@"homeScreen" sender:self];
    }
}
- (void)hideErrorImage:(BOOL)hide {
    _passwordErrorImage.hidden = hide;
    _emailErrorImage.hidden = hide;
}

- (IBAction)resetPassword:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] init];
    alertView.title =@"FORGOT PASSWORD";
    alertView.message = @"Enter email to reset";
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView addButtonWithTitle:@"Cancel"];
    [alertView addButtonWithTitle:@"Done"];
    alertView.delegate = self;
    alertView.tag = 0;
    UITextField *textField = [alertView textFieldAtIndex:0];
    textField.text = _emailField.text;
    [alertView show];
}

#pragma mark - Text Field Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _emailField) {
        [_passwordField becomeFirstResponder];
    } else if (textField == _passwordField) {
        [_passwordField resignFirstResponder];
        [self signInButtonAction:nil];
    }
    return NO;
}

#pragma mark - Facebook methods

- (IBAction)logInWithFacebook:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[@"email"];
    
    // Login PFUser using facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (!user) {
            if (!error){
                [Utilities showAlertWithTitle:@"Log In Error" message:@"The user cancelled the Facebook login."];
            } else {
                 NSString *errorString = [[error userInfo] objectForKey:@"error"];
                [Utilities showAlertWithTitle:@"Log In Error" message:errorString];
            }
        } else{
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kLoginStatus];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kLoggedInWithFacebook];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if (user.isNew) {
                
            } else {
                
            }
            [self performSegueWithIdentifier:@"homeScreen" sender:self];
        }
    }];
}

#pragma mark - Alert View Methods

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1 && alertView.tag == 0) {
        UITextField *alertTextField = [alertView textFieldAtIndex:0];
        if([self validateEmail:alertTextField.text]) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [PFUser requestPasswordResetForEmailInBackground:alertTextField.text block:^(BOOL succeeded, NSError *error){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (!error) {
                    [Utilities showAlertWithTitle:@"Success" message:@"Please check your mail to reset the password"];
                }else{
                    NSString *errorString = [[error userInfo] objectForKey:@"error"];
                    [Utilities showAlertWithTitle:@"Failed" message:errorString];
                }
            }];
        }
    }
}



@end
