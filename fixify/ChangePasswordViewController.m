//
//  ChangePasswordViewController.m
//  fixify
//
//  Created by Aliya  on 18/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_blurred"]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.passwordErrorImage.hidden = YES;
    self.confirmPasswordErrorImage.hidden = YES;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (IBAction)closeButtonAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)doneButton:(id)sender {
    if([self isValidPassword]) {
        if(_confirmPassword.text == [FixifyUser currentUser].password){
            [FixifyUser currentUser].password = _passwordField.text;
            [[FixifyUser currentUser] saveInBackground];
            [self dismissViewControllerAnimated:NO completion:nil];
        }else{
            [Utilities setBorderColor:[UIColor redColor] forView:_confirmPasswordView];
            self.confirmPasswordErrorImage.hidden = NO;
        }
    }
}

- (BOOL)isValidPassword{
    BOOL isValid = YES;
    if ([self.passwordField.text isEqualToString:@""]) {
        [Utilities setBorderColor:[UIColor redColor] forView:_passwordView];
        self.passwordErrorImage.hidden = NO;
        isValid = NO;
    }else{
        [Utilities setBorderColor:[UIColor clearColor] forView:_passwordView];
        self.passwordErrorImage.hidden = YES;
    }
    if ([self.confirmPassword.text isEqualToString:@""]) {
        [Utilities setBorderColor:[UIColor redColor] forView:_confirmPasswordView];
        self.confirmPasswordErrorImage.hidden = NO;
        isValid = NO;
    }else{
        [Utilities setBorderColor:[UIColor clearColor] forView:_confirmPasswordView];
        self.confirmPasswordView.hidden = YES;
    }
    return isValid;
}

@end
