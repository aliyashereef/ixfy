//
//  TermsAndConditionsViewController.m
//  fixify
//
//  Created by Vineeth on 07/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "TermsAndConditionsViewController.h"
#import "MBProgressHUD.h"

@interface TermsAndConditionsViewController ()

@end

@implementation TermsAndConditionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:@"http://www.google.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.termsAndConditionsWebView loadRequest:request];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - UIWebView Delegates
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self refreshNavigationToolBar:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self refreshNavigationToolBar:NO];
    [MBProgressHUD hideAllHUDsForView:self.termsAndConditionsWebView animated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self refreshNavigationToolBar:YES];
    [MBProgressHUD showHUDAddedTo:self.termsAndConditionsWebView animated:YES];
}

- (void)loadNewUrl:(NSString *)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.termsAndConditionsWebView loadRequest:request];
}

#pragma mark - Toolbar Button Action
- (IBAction)webViewBackButton:(id)sender {
    [self.termsAndConditionsWebView goBack];
}

- (IBAction)webViewNextButton:(id)sender {
    [self.termsAndConditionsWebView goForward];
}

- (IBAction)webViewCancelButton:(id)sender {
    [MBProgressHUD hideAllHUDsForView:self.termsAndConditionsWebView animated:YES];
    [self.termsAndConditionsWebView stopLoading];
}

- (IBAction)webViewRefreshButton:(id)sender {
    [self.termsAndConditionsWebView reload];
}

- (IBAction)shareButton:(id)sender {
    NSArray *activityItems = @[[NSString stringWithFormat:@"GOOGLE"],[NSURL URLWithString:@"http://www.google.com"]];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:Nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypeAssignToContact ];
    [self presentViewController:activityViewController animated:YES completion:NULL];
}

#pragma mark - Function to change state of Bar buttons

- (void)refreshNavigationToolBar:(BOOL)loading {
    self.webViewBackButton.enabled = self.termsAndConditionsWebView.canGoBack;
    self.webViewNextButton.enabled = self.termsAndConditionsWebView.canGoForward;
    self.webViewRefreshButton.enabled = !loading;
    self.webViewCancelButton.enabled = loading;
}
@end
