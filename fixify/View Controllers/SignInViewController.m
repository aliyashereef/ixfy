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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideErrorImage:YES];
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

- (BOOL)validAllFields {
    BOOL isValid = YES;
    if([Utilities cleanString:self.emailField.text].length == 0) {
        isValid = NO;
        _emailErrorImage.hidden = NO;
        [Utilities setBorderColor:[UIColor redColor] forView:_emailView];
        [self.emailField becomeFirstResponder];
    } else {
        if([Utilities isValidEmail:self.emailField.text]) {
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

//Perform the parse API login.
- (void)login{
    [PFUser logInWithUsernameInBackground:self.emailField.text password:self.passwordField.text block:^(PFUser *user, NSError *error){
        if (!error) {
            NSLog(@"sign in");
        }else{
            //Some error  has ocurred in login process
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            if ([errorString isEqualToString:@"invalid login credentials"]) {
                [Utilities setBorderColor:[UIColor redColor] forView:_emailView];
                [Utilities setBorderColor:[UIColor redColor] forView:_passwordView];
                [self hideErrorImage:NO];
            }else{
                [Utilities showAlertWithTitle:@"Error" message:errorString];
            }
        }
    }];
}

- (IBAction)signInButtonAction:(id)sender {
    if ([self validAllFields]) {
        [self login];
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
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"email",@"public_profile"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Retrieve the app delegate
             AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
         }];
    }
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
