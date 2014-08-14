//
//  TermsAndConditionsViewController.h
//  fixify
//
//  Created by Vineeth on 07/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TermsAndConditionsViewController : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *termsAndConditionsWebView;

- (IBAction)webViewBackButton:(id)sender;

- (IBAction)webViewNextButton:(id)sender;

- (IBAction)webViewCancelButton:(id)sender;

- (IBAction)webViewRefreshButton:(id)sender;

- (IBAction)shareButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *webViewBackButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *webViewCancelButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *webViewNextButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *webViewRefreshButton;

@end
