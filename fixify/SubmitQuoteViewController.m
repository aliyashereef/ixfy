//
//  SubmitQuoteViewController.m
//  fixify
//
//  Created by Aliya  on 26/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "SubmitQuoteViewController.h"

@interface SubmitQuoteViewController ()


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
    UIBarButtonItem *backButton =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"previous_white"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(backButtonAction)];
    self.navigationItem.title= @"Submit Estimate";
    UIBarButtonItem *addButton =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_accept"] style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(submitEstimateButtonAction:)];
    backButton.tintColor= kThemeBrown;
    addButton.tintColor = kThemeBrown;
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.estimateErrorImage.hidden = YES;
    self.descriptionErrorImage.hidden = YES;
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
}

-(void)updateTextField:(id)sender{
    UIDatePicker *picker = (UIDatePicker*)self.date.inputView;
    self.date.text = [self formatDate:picker.date];
}

- (BOOL)isValidNumber:(NSString *)Number{
    NSString *phoneRegex = @"^(?:|0|[1-9]\\d*)(?:\\.\\d*)?$";
    NSPredicate *NumberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [NumberPredicate evaluateWithObject:Number];
}

- (BOOL)validAllFields {
    BOOL isValid = YES;
    if (![self isValidNumber:self.estimate.text]) {
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
        [Utilities showAlertWithTitle:@"Success" message:@"Submitted Estimate"];
    }
}

- (void)backButtonAction{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end
