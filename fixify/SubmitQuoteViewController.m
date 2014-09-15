//
//  SubmitQuoteViewController.m
//  fixify
//
//  Created by Aliya  on 26/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "SubmitQuoteViewController.h"
#import "FixifyJobEstimates.h"

@interface SubmitQuoteViewController (){
    NSDate *selectedDate;
}
@end

@implementation SubmitQuoteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.date.text = [self formatDate:[NSDate date]];
    [self addPickerView];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.estimateErrorImage.hidden = YES;
    self.descriptionErrorImage.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - Textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    int offsetMultiplier;
    if (textField == self.estimate) {
        [self.description becomeFirstResponder];
        offsetMultiplier = 1;
    }
    else if (textField == self.description){
        [self.date becomeFirstResponder];
        offsetMultiplier = 2;
    }
    else{
        [self.date resignFirstResponder];
        [self submitEstimateButtonAction:self];
        offsetMultiplier = 3;
    }
    self.contentScrollView.contentOffset = CGPointMake(0,offsetMultiplier * 80);
    return YES;
}

#pragma mark - Private Functions

- (NSString *)formatDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@" dd MMM yyyy hh:mm a" ];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}

- (void)addPickerView{
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    [datePicker setDate:[NSDate date]];
    [self.date setInputView:datePicker];
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    selectedDate =[[NSDate alloc]init];
    selectedDate = datePicker.date;
}

-(void)updateTextField:(id)sender{
    UIDatePicker *picker = (UIDatePicker*)self.date.inputView;
    self.date.text = [self formatDate:picker.date];
    selectedDate = picker.date;
}

- (BOOL)validAllFields {
    BOOL isValid = YES;
    if (![Utilities isValidNumber:self.estimate.text]||[Utilities cleanString:self.estimate.text].length == 0) {
        isValid = NO;
        self.estimateErrorImage.hidden = NO;
        [Utilities setBorderColor:[UIColor redColor] forView:_estimateView];
    }else{
        self.estimateErrorImage.hidden = YES;
        [Utilities setBorderColor:[UIColor clearColor] forView:_estimateView];
    }
    if([Utilities cleanString:self.description.text].length == 0) {
        isValid = NO;
        self.descriptionErrorImage.hidden = NO;
        [Utilities setBorderColor:[UIColor redColor] forView:_descriptionView];
    }else{
        self.descriptionErrorImage.hidden = YES;
        [Utilities setBorderColor:[UIColor clearColor] forView:_descriptionView];
    }
    return isValid;
}

- (IBAction)submitEstimateButtonAction:(id)sender {
    if ([self validAllFields]) {
        FixifyJobEstimates *jobEstimate = [FixifyJobEstimates object];
        jobEstimate.owner = [FixifyUser currentUser];
        jobEstimate.amount =[NSNumber numberWithFloat:[self.estimate.text floatValue]];
        jobEstimate.jobDescription = self.description.text;
        jobEstimate.estimateTime = selectedDate;
        jobEstimate.job = _activeJob;
        [jobEstimate saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [Utilities showAlertWithTitle:@"Success" message:@"Submitted Estimate"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

- (IBAction)backButtonAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
