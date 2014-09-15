//
//  SubmitQuoteViewController.h
//  fixify
//
//  Created by Aliya  on 26/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FixifyUser.h"
#import "FixifyJob.h"

@interface SubmitQuoteViewController : UIViewController<UITextFieldDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@property (weak, nonatomic) IBOutlet UIView *estimateView;
@property (weak, nonatomic) IBOutlet UITextField *estimate;

@property (weak, nonatomic) IBOutlet UIView *descriptionView;
@property (weak, nonatomic) IBOutlet UITextField *description;

@property (weak, nonatomic) IBOutlet UIView *dateView;
@property (weak, nonatomic) IBOutlet UITextField *date;

- (IBAction)submitEstimateButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *estimateErrorImage;

@property (weak, nonatomic) IBOutlet UIImageView *descriptionErrorImage;

- (IBAction)backButtonAction:(id)sender;

@property (weak, nonatomic) FixifyJob *activeJob;

@end
