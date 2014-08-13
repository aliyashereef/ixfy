//
//  VerifyNumberViewController.m
//  fixify
//
//  Created by Aliya  on 12/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "VerifyNumberViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#import <Parse/Parse.h>
#import "ParseUtilities.h"

@interface VerifyNumberViewController ()

@end

@implementation VerifyNumberViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_blurred"]];
    self.navigationItem.title = @"Verify Number";
    self.navigationItem.hidesBackButton = YES;
    self.verificationCode.textColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonTapped:(id)sender {
    UIButton *tappedButton=(UIButton *)sender;
    [self buttonSelected:tappedButton];
}

- (IBAction)deleteButtonAction:(id)sender {
    if ([self.currentPin length] == 0){
        self.verificationCode.text = @"----";
        return;
    }
    self.currentPin = [self.currentPin substringWithRange:NSMakeRange(0, [self.currentPin length] - 1)];
    self.verificationCode.text =[NSString stringWithFormat:@"%@%@",_currentPin,[self addHyphenMark:[_currentPin length]]];
;
}

- (IBAction)skipButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)buttonSelected:(UIButton *)sender{
    NSInteger tag = sender.tag;
    if(!self.currentPin){
        self.currentPin = [NSString stringWithFormat:@"%d",tag];
    }else{
        self.currentPin = [NSString stringWithFormat:@"%@%d",self.currentPin,tag];
    }
    self.verificationCode.text =[NSString stringWithFormat:@"%@%@",_currentPin,[self addHyphenMark:[_currentPin length]]];
    if ([_currentPin length]==4) {
        [self processPin];
    }
}

- (void)processPin{
    [self.view setUserInteractionEnabled:NO];
    NSString *testString =@"1234";
    if ([_currentPin isEqualToString:testString]) {
        MBProgressHUD *progressHud = [[MBProgressHUD alloc]init] ;
        progressHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        progressHud.mode = MBProgressHUDModeIndeterminate;
        progressHud.labelText = @"Saving";
        [progressHud show:YES];
        ParseUtilities *parse = [[ParseUtilities alloc]init];
        [parse signUpWithUser:_user
             requestSucceeded:^(PFUser *user){
                 [progressHud hide:YES];
                 [self dismissViewControllerAnimated:YES completion:nil];
         }requestFailed:^(NSError *error){
             NSString *errorString = [[error userInfo] objectForKey:@"error"];
             [Utilities showAlertWithTitle:@"Register" message:errorString];
             [progressHud hide:YES];
             [self.navigationController popViewControllerAnimated:YES];
         }];
    }else{
        self.verificationCode.text =[NSString stringWithFormat:@"%@%@",_currentPin,[self addHyphenMark:[_currentPin length]]];
;
        CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
        [shake setDuration:0.1];
        [shake setRepeatCount:4];
        [shake setAutoreverses:YES];
        [shake setFromValue:[NSValue valueWithCGPoint:
                             CGPointMake(self.verificationCode.center.x - 5,self.verificationCode.center.y)]];
        [shake setToValue:[NSValue valueWithCGPoint:
                           CGPointMake(self.verificationCode.center.x + 5,self.verificationCode.center.y)]];
        [self.verificationCode.layer addAnimation:shake forKey:@"position"];
        [self.view setUserInteractionEnabled:YES];
    }
    _currentPin = @"";
}
- (NSString *)addHyphenMark:(NSInteger)pinlength{
    NSString *hyphenString = @"";
    int difference = kPinLength - pinlength;
    for (int i=0; i<difference; i++) {
        hyphenString = [NSString stringWithFormat:@"%@-",hyphenString];
    }
    return hyphenString;
}

@end
