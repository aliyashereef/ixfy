//
//  RegisterViewController.m
//  fixify
//
//  Created by qbadmin on 01/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
{
    UIButton *closeButton;
    UIButton *acceptButton;
    UIBarButtonItem *leftButton;
    UIBarButtonItem *rightButton;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.registerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_blurred"]];
    self.view.backgroundColor = [UIColor clearColor];
    
    UIImage *closeImage = [UIImage imageNamed:@"ic_close"];
    closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:closeImage forState:UIControlStateNormal];
    closeButton.frame = CGRectMake(0.0,0.0,closeImage.size.width,closeImage.size.height);
    [closeButton addTarget:self
                    action:@selector(closeButtonClicked)
          forControlEvents:UIControlEventTouchUpInside];
    
    leftButton = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    
    UIImage *acceptImage = [UIImage imageNamed:@"ic_accept"];
    acceptButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [acceptButton setImage:acceptImage forState:UIControlStateNormal];
    acceptButton.frame = CGRectMake(0.0,0.0,acceptImage.size.width,acceptImage.size.height);
    [acceptButton addTarget:self
                     action:@selector(acceptButtonClicked)
           forControlEvents:UIControlEventTouchUpInside];
    
    rightButton = [[UIBarButtonItem alloc] initWithCustomView:acceptButton];
    self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)changeAvatarButton:(id)sender {
}

- (IBAction)doneButton:(id)sender {
}

- (IBAction)tradesmanSwitch:(id)sender {
}

- (void)acceptButtonClicked
{
    
}

- (void)closeButtonClicked
{
    
}
@end
