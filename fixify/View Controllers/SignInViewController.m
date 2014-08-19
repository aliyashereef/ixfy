//
//  SignInViewController.m
//  fixify
//
//  Created by Aliya on 01/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "SignInViewController.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "RegisterViewController.h"
#import "FixifyUser.h"

@interface SignInViewController ()
@end

@implementation SignInViewController
{
    NSData *fullImageData;
}
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
    if ([FixifyUser currentUser] && [PFFacebookUtils isLinkedWithUser:[FixifyUser currentUser]]){
        
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
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
    [FixifyUser logInWithUsernameInBackground:self.emailField.text password:self.passwordField.text block:^(PFUser *user, NSError *error) {
        if (!error) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kLoginStatus];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kLoggedInWithFacebook];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self performSegueWithIdentifier:@"homeScreen" sender:self];
            }else{
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
    self.signInScrollView.contentOffset = CGPointMake(0,80);
    return NO;
}

#pragma mark - Facebook methods

- (IBAction)logInWithFacebook:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSArray *permissionsArray = @[@"email"];
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *fbUser, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (!fbUser) {
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
            if (fbUser.isNew) {
                FBRequest *request = [FBRequest requestForMe];
                [request startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                    if (!error) {
                        NSDictionary *userData = (NSDictionary *)user;
                        NSString *facebookID = userData[@"id"];
                        fbUser[@"fullName"] = userData[@"name"];
                        fbUser.username = user[@"email"];
                        _imageData = [[NSMutableData alloc] init];
                        NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
                        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL
                                                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                              timeoutInterval:2.0f];
                        NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
                        [urlConnection start];
                        fbUser[@"image"] = [PFFile fileWithName:@"image" data:fullImageData];
                        fbUser[@"isTradesman"] = @NO;
                        [fbUser saveInBackground];
                    }
                }];
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
            [FixifyUser requestPasswordResetForEmailInBackground:alertTextField.text block:^(BOOL succeeded, NSError *error){
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

// Called every time a chunk of the data is received
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_imageData appendData:data]; // Build the image
}

// Called when the entire image is finished downloading
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    UIImageView *defaultAvatar = [[UIImageView alloc]init];
    defaultAvatar.image = [UIImage imageWithData:_imageData];
    fullImageData = UIImageJPEGRepresentation(defaultAvatar.image, 0);
}

@end
