//
//  EstimateDetailViewController.m
//  fixify
//
//  Created by Aliya  on 18/09/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "EstimateDetailViewController.h"
#import "TradesmanProfileViewController.h"
#import "FixifyJob.h"

@interface EstimateDetailViewController ()

@end

@implementation EstimateDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setUpView];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods

- (void)setUpView {
    self.estimateDescription.text = _estimate.jobDescription ;
    CGSize requiredSize = [Utilities getRequiredSizeForText:self.estimateDescription.text
                                                       font:[UIFont fontWithName:@"DINAlternate-Bold" size:17.0f]
                                                   maxWidth:self.estimateDescription.frame.size.width];
    _estimateDescriptionLabelHeight.constant = requiredSize.height + 1 ;
    self.dateAndTime.text = [Utilities formatDateForEstimate:_estimate.estimateTime];
    self.estimateAmount.text = [NSString stringWithFormat:@"%@",_estimate.amount];
    self.tradesmanName.text = _estimate.owner.fullName ;
    self.tradesmanImage.layer.cornerRadius =  self.tradesmanImage.frame.size.width / 2;
    self.tradesmanImage.clipsToBounds = YES;
    [_estimate.owner.image getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
           self.tradesmanImage.image = [UIImage imageWithData:imageData];
        }
    }];
    
}

- (IBAction)backButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)profileViewButtonAction:(id)sender {
    [self performSegueWithIdentifier:kTradesmanProfileView sender:self];
}
- (IBAction)acceptEstimateButtonAction:(id)sender {
    _estimate.isAccepted = YES ;
    _estimate.job.status = kInProgressJob ;
    _estimate.job.tradesman = _estimate.owner ;
    [_estimate saveInBackground];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:kTradesmanProfileView]) {
        TradesmanProfileViewController *viewController = segue.destinationViewController;
        viewController.tradesman = _estimate.owner;
    }
}
@end
