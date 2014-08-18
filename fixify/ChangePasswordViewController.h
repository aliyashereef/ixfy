//
//  ChangePasswordViewController.h
//  fixify
//
//  Created by Aliya  on 18/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FixifyUser.h"

@interface ChangePasswordViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *confirmPasswordView;

@property (weak, nonatomic) IBOutlet UIView *passwordView;

@property (weak, nonatomic) IBOutlet UIImageView *passwordErrorImage;

- (IBAction)closeButtonAction:(id)sender;

- (IBAction)doneButton:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UIImageView *confirmPasswordErrorImage;

@end
