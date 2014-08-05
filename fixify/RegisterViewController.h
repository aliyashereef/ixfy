//
//  RegisterViewController.h
//  fixify
//
//  Created by qbadmin on 01/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *registerScrollView;

@property (weak, nonatomic) IBOutlet UIView *registerView;

@property (weak, nonatomic) IBOutlet UIView *avatarView;

@property (weak, nonatomic) IBOutlet UIImageView *defaultAvatar;

- (IBAction)changeAvatarButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *fullNameView;

@property (weak, nonatomic) IBOutlet UIView *passwordView;

@property (weak, nonatomic) IBOutlet UIView *emailIdView;

@property (weak, nonatomic) IBOutlet UIView *mobileNumberView;

@property (weak, nonatomic) IBOutlet UITextField *fullName;

@property (weak, nonatomic) IBOutlet UITextField *mobileNumber;

@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet UITextField *emailId;

- (IBAction)doneButton:(id)sender;

- (IBAction)tradesmanSwitch:(id)sender;

@end
