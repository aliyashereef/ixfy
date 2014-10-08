//
//  JobListingViewController.m
//  fixify
//
//  Created by Aliya  on 19/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "JobListingViewController.h"
#import "TradesmanJobsViewController.h"
#import "MBProgressHUD.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface JobListingViewController (){
    NSMutableArray *estimatedJobArray;
    NSMutableArray *inProgressJobArray;
    NSMutableArray *paymentNeededJobArray;
    NSMutableArray *completedJobArray;
    NSArray *categoryJobArray;
}

@end

@implementation JobListingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self getJobs];
    estimatedJobArray = [[NSMutableArray alloc]init];
    inProgressJobArray = [[NSMutableArray alloc]init];
    paymentNeededJobArray = [[NSMutableArray alloc]init];
    completedJobArray = [[NSMutableArray alloc]init];
    categoryJobArray = [[NSArray alloc]init];
    self.view.backgroundColor = kThemeBackground;
    self.menuView.backgroundColor = kThemeBackground;
    self.menuView.alpha = 0.95f;
    self.navigationController.navigationBarHidden = YES;
    self.tradesmanName.text = [FixifyUser currentUser].fullName ;
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (IBAction)menuCloseButtonAction:(id)sender {
    [Utilities hideAnimationForView:self.menuView];
}

- (IBAction)menuButtonAction:(id)sender {
    [Utilities showAnimationForView:self.menuView];
}

- (IBAction)notificationButtonAction:(id)sender {
}

- (IBAction)feedbackButtonAction:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
        [mailComposer setMailComposeDelegate:self];
        [mailComposer setSubject:@"FEED_BACK"];
        NSArray *toRecipients = [NSArray arrayWithObject:kFeedBackEmailID];
        [mailComposer setToRecipients:toRecipients];
        [self presentViewController:mailComposer animated:YES completion:nil];
    } else {
        [Utilities showAlertWithTitle:@"MAIL"message:@"NO_EMAIL_ACC"];
    }

}

- (IBAction)shareAppButtonAction:(id)sender {
    NSString *shareText =@"CHECK_OUT_APP";
    NSURL *shareUrl = [NSURL URLWithString:@"https://www.google.com"];
    NSArray * activityItems = @[shareText, shareUrl];
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:@[]];
    NSArray *excludeActivities = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeMessage, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
    activityController.excludedActivityTypes = excludeActivities;
    [self.navigationController presentViewController:activityController animated:YES completion:nil];
}

- (IBAction)signOutButtonAction:(id)sender {
    [FixifyUser logOut];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:kLoginStatus];
    [defaults synchronize];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)profileViewButtonAction:(id)sender {
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:kEditProfileViewControllerID];
    [self.navigationController presentViewController:controller animated:NO completion:nil];
}

- (void)getJobs{
    [Utilities progressAnimeAddedTo:self.view show:YES];
    PFQuery *query = [FixifyJob query];
    [query whereKey:@"tradesman" equalTo:[FixifyUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [Utilities progressAnimeAddedTo:self.view show:NO];            _jobArray = [objects mutableCopy];
            for (FixifyJob *job in _jobArray) {
                if([job.status isEqualToString:kInProgressJob]){
                    [inProgressJobArray addObject:job];
                }else if([job.status isEqualToString:kPaymentRequired]){
                    [paymentNeededJobArray addObject:job];
                }else  if([job.status isEqualToString:kJobCompleted]){
                    [completedJobArray addObject:job];
                }
            }
            [self updateButtonTitles];
        }
    }];
    PFQuery *estimatedQuery = [FixifyJobEstimates query];
    [estimatedQuery whereKey:@"owner" equalTo:[FixifyUser currentUser]];
    [estimatedQuery includeKey:@"job"];
    [estimatedQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (FixifyJobEstimates *jobEstimates in objects) {
                [estimatedJobArray addObject:jobEstimates.job];
            }
        }
    }];
}

- (IBAction)switchToSection:(id)sender{
    switch ([sender tag]) {
        case 0:categoryJobArray = [[NSArray alloc]initWithArray:estimatedJobArray];
            break;
        case 1:categoryJobArray = [[NSArray alloc]initWithArray:inProgressJobArray];
            break;
        case 2:categoryJobArray = [[NSArray alloc]initWithArray:paymentNeededJobArray];
            break;
        case 3:categoryJobArray = [[NSArray alloc]initWithArray:completedJobArray];
            break;
        default:
            break;
            }
    [self performSegueWithIdentifier:@"TRADESMAN_JOBS" sender:self];
}

- (void)updateButtonTitles{
    [self.estimatesButton setTitle:[NSString stringWithFormat:@"Estimates [%d]", estimatedJobArray.count] forState:UIControlStateNormal];
    [self.inProgressButton setTitle:[NSString stringWithFormat:@"In Progress Job [%d]", inProgressJobArray.count] forState:UIControlStateNormal];
    [self.paymentNeededButton setTitle:[NSString stringWithFormat:@"Payment Needed [%d]", paymentNeededJobArray.count] forState:UIControlStateNormal];
    [self.completedButton setTitle:[NSString stringWithFormat:@"Completed [%d]", completedJobArray.count] forState:UIControlStateNormal];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
       if ([segue.identifier isEqualToString:@"TRADESMAN_JOBS"]) {
           TradesmanJobsViewController *viewController = [segue destinationViewController];
           viewController.myJobArray = categoryJobArray;
    }
}

#pragma mark - MFMailComposerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    if(result == MFMailComposeResultSent) {
        [Utilities showAlertWithTitle:@"SUCCESS" message:@"FEEDBACK_SENT"];
    } else {
        [Utilities showAlertWithTitle:@"FAILED" message:error.localizedDescription];
    }
	[controller dismissViewControllerAnimated:YES completion:nil];
}

@end
