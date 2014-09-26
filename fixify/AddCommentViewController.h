//
//  AddCommentViewController.h
//  fixify
//
//  Created by Aliya  on 23/09/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FixifyComment.h"
#import "FixifyUser.h"
#import "FixifyJob.h"

@interface AddCommentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

- (IBAction)backButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *postPrivatelyButton;
@property (weak, nonatomic) IBOutlet UIButton *postCommentButton;
@property (weak, nonatomic) IBOutlet UITextView *commentText;
@property (weak, nonatomic) IBOutlet UIView *postCommentView;
@property (strong, nonatomic) FixifyJob *job;
@property (weak, nonatomic) FixifyComment *comment;
- (IBAction)postCommentButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (strong, nonatomic) NSArray *comments;
@end
