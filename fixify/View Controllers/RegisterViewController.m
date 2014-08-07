//
//  RegisterViewController.m
//  fixify
//
//  Created by qbadmin on 01/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "RegisterViewController.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"

@interface RegisterViewController ()
{
    UIButton *closeButton;
    UIBarButtonItem *leftButton;
    MBProgressHUD *progressHud;
}

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    progressHud = [[MBProgressHUD alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_blurred"]];
    [self.navigationController.navigationBar
                                setBackgroundImage:[UIImage new]
                                     forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    UIImage *closeImage = [UIImage imageNamed:@"ic_close"];
    closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:closeImage forState:UIControlStateNormal];
    closeButton.frame = CGRectMake(0.0,0.0,closeImage.size.width,closeImage.size.height);
    
    [closeButton addTarget:self
                    action:@selector(closeButtonClicked)
          forControlEvents:UIControlEventTouchUpInside];
    
    leftButton = [[UIBarButtonItem alloc] initWithCustomView:closeButton];

    self.navigationItem.leftBarButtonItem = leftButton;
}

- (void) viewWillAppear:(BOOL)animated{
    self.emailErrorImage.hidden = YES;
    self.mobileNumberErrorImage.hidden = YES;
    self.passwordErrorImage.hidden = YES;
    self.fullNameErrorImage.hidden = YES;
}
    
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - Textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.fullName) {
        [self.password becomeFirstResponder];
    }
    else if (textField == self.password)
    {
        [self.emailId becomeFirstResponder];
    }
    else if (textField == self.emailId)
    {
        self.registerScrollView.contentOffset = CGPointMake(0,100);
        [self.mobileNumber becomeFirstResponder];
    }
    else
    {
        [self doneButton:self];
    }
    return YES;
}

#pragma mark - Change avatar

- (IBAction)changeAvatarButton:(id)sender {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - PickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.defaultAvatar.image = image;
    [self dismissViewControllerAnimated:YES completion:Nil];
}

#pragma mark - Done Button action

- (IBAction)doneButton:(id)sender{
    if( ![self.fullName.text isEqualToString:@""] && ![self.password.text isEqualToString:@""] && ![self.emailId.text isEqualToString:@""] && ![self.mobileNumber.text isEqualToString:@""] && [self stringIsValidEmail:self.emailId.text] && [self stringIsValidMobileNumber:self.mobileNumber.text])
    {
        PFUser *user = [PFUser user];
        user.username = self.emailId.text;
        user.password = self.password.text;
        user[@"FullName"]     = self.fullName.text;
        user[@"MobileNumber"] = self.mobileNumber.text;
        NSData *imageData = UIImagePNGRepresentation(self.defaultAvatar.image);
        PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
        user[@"Image"] = imageFile;
        
        if (self.tradesmanSwitch.isOn) {
            user[@"Tradesman"] = @"YES";
        }
        else{
            user[@"Tradesman"] = @"NO";
        }
        
        [self.registerView setUserInteractionEnabled:NO];
        progressHud = [MBProgressHUD showHUDAddedTo:self.registerView animated:YES];
        progressHud.mode = MBProgressHUDModeIndeterminate;
        progressHud.labelText = @"Saving";
        [progressHud show:YES];
        [self invalidEntry];
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [self dismissViewControllerAnimated:YES completion:Nil];
                [progressHud hide:YES];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Register"
                                                               message:@"EmailID Already Exists" delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:Nil, nil];
                [self.view setUserInteractionEnabled:YES];
                [progressHud hide:YES];
                [alert show];
                self.emailIdView.layer.borderWidth = 2.0f;
                self.emailIdView.layer.borderColor = [[UIColor redColor] CGColor];
                self.emailErrorImage.hidden = NO;
                [self.registerView setUserInteractionEnabled:YES];
            }
        }];
    }
    else{
        [self invalidEntry];
    }
}

#pragma mark - CloseButton action

- (void)closeButtonClicked{
    [self dismissViewControllerAnimated:YES completion:Nil];
}

#pragma mark - Function to change border colour

- (void)invalidEntry{
    if(![self stringIsValidEmail:self.emailId.text])
    {
        self.emailIdView.layer.borderWidth = 2.0f;
        self.emailIdView.layer.borderColor = [[UIColor redColor] CGColor];
        self.emailErrorImage.hidden = NO;
    }
    else{
        self.emailIdView.layer.borderWidth = 0.0f;
        self.emailErrorImage.hidden = YES;
    }
    if(![self stringIsValidMobileNumber:self.mobileNumber.text])
    {
        self.mobileNumberView.layer.borderWidth = 2.0f;
        self.mobileNumberView.layer.borderColor = [[UIColor redColor] CGColor];
        self.mobileNumberErrorImage.hidden = NO;
    }
    else{
        self.mobileNumberView.layer.borderWidth = 0.0f;
        self.mobileNumberErrorImage.hidden = YES;
    }
    
    if ([self.fullName.text isEqualToString:@""]) {
        self.fullNameView.layer.borderWidth = 2.0f;
        self.fullNameView.layer.borderColor = [[UIColor redColor] CGColor];
        self.fullNameErrorImage.hidden = NO;
    }
    else{
        self.fullNameView.layer.borderWidth = 0.0f;
        self.fullNameErrorImage.hidden = YES;
    }
    if ([self.password.text isEqualToString:@""]) {
        self.passwordView.layer.borderWidth = 2.0f;
        self.passwordView.layer.borderColor = [[UIColor redColor] CGColor];
        self.passwordErrorImage.hidden = NO;
    }
    else{
        self.passwordView.layer.borderWidth = 0.0f;
        self.passwordErrorImage.hidden = YES;
    }
}

#pragma mark - Funtions for validation

-(BOOL) stringIsValidEmail:(NSString *)checkString{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(BOOL) stringIsValidMobileNumber:(NSString *)checkString{
    NSString *phoneRegex = @"^[0-9]{6,14}$";
    NSPredicate *mobileNumberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [mobileNumberTest evaluateWithObject:checkString];
}
@end
