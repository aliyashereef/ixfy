//
//  RegisterViewController.m
//  fixify
//
//  Created by Vineeth on 01/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "RegisterViewController.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "VerifyNumberViewController.h"
#import "Utilities.h"

@interface RegisterViewController (){
    UIButton *closeButton;
    UIBarButtonItem *leftButton;
    MBProgressHUD *progressHud;
    FixifyUser *parseUser;
}
@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    parseUser =[[FixifyUser alloc]init];
    progressHud = [[MBProgressHUD alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title= @"Registration";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"DINAlternate-Bold" size:20.0]};
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
    self.defaultAvatar.layer.cornerRadius = self.defaultAvatar.frame.size.width / 2;
    self.defaultAvatar.clipsToBounds = YES;
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
    int offsetMultiplier;
    if (textField == self.fullName) {
        [self.password becomeFirstResponder];
        offsetMultiplier = 1;
    }
    else if (textField == self.password){
        [self.emailId becomeFirstResponder];
        offsetMultiplier = 2;
    }
    else if (textField == self.emailId){
        [self.mobileNumber becomeFirstResponder];
        offsetMultiplier = 3;
    }
    else{
        [self doneButton:self];
        offsetMultiplier = 3;
    }
    self.registerScrollView.contentOffset = CGPointMake(0,offsetMultiplier * 80);
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

- (IBAction)signUpWithFacebook:(id)sender {
    [Utilities progressAnimeAddedTo:self.view show:YES];
    NSArray *permissionsArray = @[@"email"];
    // Login PFUser using facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [Utilities progressAnimeAddedTo:self.view show:NO];
        if (!user){
            if (!error){
                [Utilities showAlertWithTitle:@"Log In Error" message:@"The user cancelled the Facebook login."];
            } else {
                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                [Utilities showAlertWithTitle:@"Log In Error" message:errorString];
            }
        } else{
            [self getFacebookData];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kLoginStatus];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kLoggedInWithFacebook];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if (user.isNew) {
            }else{
            }
        }
    }];
}

- (IBAction)doneButton:(id)sender{
    if([self isValidEntry]){
        BOOL tradesman = NO;
        if (self.tradesmanSwitch.isOn){
            tradesman  = YES;
        }
        parseUser.username = self.emailId.text;
        parseUser.password = self.password.text;
        parseUser.fullName    = self.fullName.text;
        parseUser.mobileNumber = self.mobileNumber.text;
        NSData *imageData = UIImageJPEGRepresentation(self.defaultAvatar.image,0);
        PFFile *imageFile = [PFFile fileWithName:@"image" data:imageData];
        parseUser.Image = imageFile;
        if (tradesman) {
            parseUser.isTradesman = YES;
        }else{
            parseUser.isTradesman = NO;
        }
        [self performSegueWithIdentifier:@"VERIFY_NUMBER" sender:nil];
    }
}

#pragma mark - CloseButton action

- (void)closeButtonClicked{
    [self dismissViewControllerAnimated:YES completion:Nil];
}

#pragma mark - Function to change border colour

- (BOOL)isValidEntry{
    BOOL isValid = YES;
    if(![Utilities isValidEmail:self.emailId.text]){
        [Utilities setBorderColor:[UIColor redColor] forView:_emailIdView];
        self.emailErrorImage.hidden = NO;
        isValid = NO;
    }else{
        self.emailIdView.layer.borderWidth = 0.0f;
        self.emailErrorImage.hidden = YES;
    }
    if(![Utilities isValidMobileNumber:self.mobileNumber.text]){
        [Utilities setBorderColor:[UIColor redColor] forView:_mobileNumberView];
        self.mobileNumberErrorImage.hidden = NO;
        isValid = NO;
    }else{
        self.mobileNumberView.layer.borderWidth = 0.0f;
        self.mobileNumberErrorImage.hidden = YES;
    }
    if ([[Utilities cleanString:self.fullName.text] isEqualToString:@""]) {
        [Utilities setBorderColor:[UIColor redColor] forView:_fullNameView];
        self.fullNameErrorImage.hidden = NO;
        isValid = NO;
    }else{
        self.fullNameView.layer.borderWidth = 0.0f;
        self.fullNameErrorImage.hidden = YES;
    }
    if ([[Utilities cleanString:self.password.text] isEqualToString:@""]) {
        [Utilities setBorderColor:[UIColor redColor] forView:_passwordView];
        self.passwordErrorImage.hidden = NO;
        isValid = NO;
    }else{
        self.passwordView.layer.borderWidth = 0.0f;
        self.passwordErrorImage.hidden = YES;
    }
    return isValid;
}

- (void)getFacebookData{
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)user;
            NSString *facebookID = userData[@"id"];
            NSString *name = userData[@"name"];
            _imageData = [[NSMutableData alloc] init];
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL
                                                                      cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                  timeoutInterval:2.0f];
            NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
            [urlConnection start];
            self.emailId.text = user[@"email"];
            self.fullName.text = name;
        }
    }];
}
// Called every time a chunk of the data is received
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_imageData appendData:data]; // Build the image
}

// Called when the entire image is finished downloading
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // Set the image in the header imageView
    self.defaultAvatar.image = [UIImage imageWithData:_imageData];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"VERIFY_NUMBER"]) {
        VerifyNumberViewController *verifyNumberViewController = (VerifyNumberViewController *)segue.destinationViewController;
        verifyNumberViewController.user = parseUser;
    }
}

@end
