//
//  SignInViewController.h
//  fixify
//
//  Created by Aliya on 01/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *emailField;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)signInButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;

@property (weak, nonatomic) IBOutlet UIImageView *emailErrorImage;
@property (weak, nonatomic) IBOutlet UIImageView *passwordErrorImage;

@property (strong, nonatomic) NSMutableData* imageData;

@property (weak, nonatomic) IBOutlet UIScrollView *signInScrollView;
- (IBAction)resetPassword:(id)sender;
- (IBAction)logInWithFacebook:(id)sender;




@end
