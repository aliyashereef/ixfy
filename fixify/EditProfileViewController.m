//
//  EditProfileViewController.m
//  fixify
//
//  Created by Aliya  on 14/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "EditProfileViewController.h"
#import "MBProgressHUD.h"

@interface EditProfileViewController ()

@end

@implementation EditProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_blurred"]];
    self.usernameField.text = self.user.FullName;
    self.emailField.text = self.user.username;
    self.mobileNumberField.text = self.user.MobileNumber;
    PFFile *imageFile=self.user.Image;
    [imageFile getDataInBackgroundWithBlock:^(NSData *result, NSError *error) {
        if (!error){
            self.avatarView.image = [UIImage imageWithData:result];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.emailErrorImage.hidden = YES;
    self.mobileNumberErrorImage.hidden = YES;
    self.passwordErrorImage.hidden = YES;
    self.fullNameErrorImage.hidden = YES;
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - PickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.avatarView.image = image;
    [self dismissViewControllerAnimated:YES completion:Nil];
}
- (IBAction)closeButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (IBAction)changeAvatarButton:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (IBAction)doneButton:(id)sender{
    if([self invalidEntry]){
        _user.username = self.emailField.text;
        _user.password = self.passwordField.text;
        _user.FullName    = self.usernameField.text;
        _user.MobileNumber = self.mobileNumberField.text;
        NSData *imageData = UIImagePNGRepresentation(self.avatarView.image);
        PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
        _user.Image = imageFile;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"Uploading";
        [hud show:YES];
        [_user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        [hud hide:YES];
            if (!error)
            {// Show success message
            }}];
    }
}

#pragma mark - Function to change border colour

- (BOOL)invalidEntry{
    BOOL isValid = YES;
    if(![Utilities isValidEmail:self.emailField.text]){
        [Utilities setBorderColor:[UIColor redColor] forView:_emailIdView];
        self.emailErrorImage.hidden = NO;
        isValid = NO;
    }else{
        self.emailIdView.layer.borderWidth = 0.0f;
        self.emailErrorImage.hidden = YES;
    }
    if(![Utilities stringIsValidMobileNumber:self.mobileNumberField.text]){
        [Utilities setBorderColor:[UIColor redColor] forView:_mobileNumberView];
        self.mobileNumberErrorImage.hidden = NO;
        isValid = NO;
    }else{
        self.mobileNumberView.layer.borderWidth = 0.0f;
        self.mobileNumberErrorImage.hidden = YES;
    }
    if ([self.usernameField.text isEqualToString:@""]) {
        [Utilities setBorderColor:[UIColor redColor] forView:_fullNameView];
        self.fullNameErrorImage.hidden = NO;
        isValid = NO;
    }else{
        self.fullNameView.layer.borderWidth = 0.0f;
        self.fullNameErrorImage.hidden = YES;
    }
    if ([self.passwordField.text isEqualToString:@""]) {
        [Utilities setBorderColor:[UIColor redColor] forView:_passwordView];
        self.passwordErrorImage.hidden = NO;
        isValid = NO;
    }else{
        self.passwordView.layer.borderWidth = 0.0f;
        self.passwordErrorImage.hidden = YES;
    }
    return isValid;
}

@end
