//
//  VerifyNumberViewController.h
//  fixify
//
//  Created by Aliya  on 12/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <parse/Parse.h>

@interface VerifyNumberViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *verificationCode;

@property (nonatomic,weak) PFUser *user;

@property (nonatomic, strong) IBOutlet UIButton *buttonOne;
@property (nonatomic, strong) IBOutlet UIButton *buttonTwo;
@property (nonatomic, strong) IBOutlet UIButton *buttonThree;
@property (nonatomic, strong) IBOutlet UIButton *buttonFour;
@property (nonatomic, strong) IBOutlet UIButton *buttonFive;
@property (nonatomic, strong) IBOutlet UIButton *buttonSix;
@property (nonatomic, strong) IBOutlet UIButton *buttonSeven;
@property (nonatomic, strong) IBOutlet UIButton *buttonEight;
@property (nonatomic, strong) IBOutlet UIButton *buttonNine;
@property (nonatomic, strong) IBOutlet UIButton *buttonZero;

@property (nonatomic, strong) IBOutlet UIButton *skipButton;

@property (nonatomic, weak) IBOutlet UIButton *deleteButton;

@property (nonatomic, strong) NSString *currentPin;

- (IBAction)buttonTapped:(id)sender;
- (IBAction)deleteButtonAction:(id)sender;
- (IBAction)skipButtonAction:(id)sender;

@end
