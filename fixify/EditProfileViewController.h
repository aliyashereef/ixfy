//
//  EditProfileViewController.h
//  fixify
//
//  Created by Aliya  on 14/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FixifyUser.h"

@interface EditProfileViewController : UIViewController<UIImagePickerControllerDelegate,UITextFieldDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *detailScroll;

@property (weak, nonatomic) IBOutlet UITextField *usernameField;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UITextField *emailField;

@property (weak, nonatomic) IBOutlet UIImageView *avatarView;

@property (weak, nonatomic) IBOutlet UITextField *mobileNumberField;

- (IBAction)closeButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *editProfileScrollView;

- (IBAction)changeAvatarButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *fullNameView;

@property (weak, nonatomic) IBOutlet UIView *passwordView;

@property (weak, nonatomic) IBOutlet UIView *emailIdView;

@property (weak, nonatomic) IBOutlet UIView *mobileNumberView;

@property (weak, nonatomic) IBOutlet UIImageView *mobileNumberErrorImage;

@property (weak, nonatomic) IBOutlet UIImageView *fullNameErrorImage;

@property (weak, nonatomic) IBOutlet UIImageView *emailErrorImage;

@property (weak, nonatomic) IBOutlet UIImageView *passwordErrorImage;

- (IBAction)doneButton:(id)sender;

@property (nonatomic,weak) FixifyUser *user;

@property (weak, nonatomic) IBOutlet UIButton *changePassword;


@end
