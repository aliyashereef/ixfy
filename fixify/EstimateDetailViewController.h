//
//  EstimateDetailViewController.h
//  fixify
//
//  Created by Aliya  on 18/09/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FixifyJobEstimates.h"
#import "FixifyUser.h"

@interface EstimateDetailViewController : UIViewController
- (IBAction)backButtonAction:(id)sender;
- (IBAction)profileViewButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *tradesmanName;
@property (weak, nonatomic) IBOutlet UIImageView *tradesmanImage;
@property (weak, nonatomic) IBOutlet UILabel *estimateAmount;
@property (weak, nonatomic) IBOutlet UILabel *dateAndTime;
@property (weak, nonatomic) IBOutlet UILabel *estimateDescription;
- (IBAction)acceptEstimateButtonAction:(id)sender;
@property (weak, nonatomic) FixifyJobEstimates *estimate;
@end
