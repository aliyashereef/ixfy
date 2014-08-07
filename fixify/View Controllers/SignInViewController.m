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
        passwordErrori.hidden = NO;
        [PNGUtilities setBorderColor:[UIColor redColor] forView:_passwordView];
    } else {
        passwordErrorLabel.hidden = YES;
        [PNGUtilities setBorderColor:[UIColor clearColor] forView:_passwordView];
    }
    return isValid;
}

//  Validating email fields.
- (BOOL)validateEmail:(NSString *)email {
    BOOL isValid = YES;
    if([PNGUtilities cleanString:email].length == kZeroValue) {
        isValid = NO;
        [PNGUtilities showAlertWithTitle:NSLocalizedString(@"FAILED", @"") message:NSLocalizedString(@"ENTER_EMAIL_TO_RESET", @"")];
    } else {
        if(![PNGUtilities isValidEmail:email]) {
            isValid = NO;
            [PNGUtilities showAlertWithTitle:NSLocalizedString(@"FAILED", @"") message:NSLocalizedString(@"INVALID_EMAIL", @"")];
        }
    }
    return isValid;
}

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
    }else{
        [self signInButtonAction:nil];
    }
        return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self hideErrorImage:YES];
    [Utilities setBorderColor:[UIColor clearColor] forView:_emailView];
    [Utilities setBorderColor:[UIColor clearColor] forView:_passwordView];
}
- (IBAction)signInButtonAction:(id)sender {
    if (![_emailField.text isEqual:@""]&&[_passwordField.text isEqual:@""]) {
        [self login];
            }else{
        [self hideErrorImage:NO];
        [Utilities setBorderColor:[UIColor redColor] forView:_emailView];
        [Utilities setBorderColor:[UIColor redColor] forView:_passwordView];
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
                UIAlertView *errorAlertView = [[UIAlertView alloc]
                                               initWithTitle:@"Error"
                                               message:errorString
                                               delegate:nil
                                               cancelButtonTitle:@"Ok"
                                               otherButtonTitles:nil, nil];
                [errorAlertView show];
            }
        }
    }];

}
@end
