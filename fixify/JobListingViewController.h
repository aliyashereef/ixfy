//
//  JobListingViewController.h
//  fixify
//
//  Created by Aliya  on 19/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FixifyUser.h"
#import "FixifyJob.h"
#import "FixifyJobEstimates.h"

@interface JobListingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *menuView;

- (IBAction)menuCloseButtonAction:(id)sender;
- (IBAction)menuButtonAction:(id)sender;
- (IBAction)notificationButtonAction:(id)sender;
- (IBAction)feedbackButtonAction:(id)sender;
- (IBAction)shareAppButtonAction:(id)sender;
- (IBAction)signOutButtonAction:(id)sender;
- (IBAction)profileViewButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *tradesmanName;
@property (weak, nonatomic) IBOutlet UIImageView *tradesmanAvatar;

@property (weak, nonatomic) IBOutlet UIButton *estimatesButton;
@property (weak, nonatomic) IBOutlet UIButton *inProgressButton;
@property (weak, nonatomic) IBOutlet UIButton *paymentNeededButton;
@property (weak, nonatomic) IBOutlet UIButton *completedButton;

@property (strong, nonatomic) NSArray *jobArray;
@end
