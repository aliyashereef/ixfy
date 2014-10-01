//
//  AddCommentViewController.m
//  fixify
//
//  Created by Aliya  on 23/09/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "AddCommentViewController.h"
#import "CommentsTableViewCell.h"
#import "CommentReplyTableViewCell.h"

@interface AddCommentViewController (){
    CGRect commentViewFrame;
}

@end

@implementation AddCommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.postPrivatelyButton.backgroundColor = kThemeBrown;
    self.postCommentButton.backgroundColor = kThemeBrown;
    commentViewFrame = [_postCommentView frame];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - Notification Methods

- (void)keyboardWasShown:(NSNotification*)notification {
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    commentViewFrame.origin.y = commentViewFrame.origin.y - keyboardSize.height ;
    [_postCommentView setFrame:commentViewFrame];
}

- (void)keyboardWillBeHidden:(NSNotification*)notification {
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    commentViewFrame.origin.y = commentViewFrame.origin.y + keyboardSize.height ;
    [_postCommentView setFrame:commentViewFrame];
}

#pragma mark - Private Methods

- (IBAction)backButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FixifyComment *comment = [_comments objectAtIndex:indexPath.row];
    if (comment.parentComment) {
        CommentReplyTableViewCell *cell = (CommentReplyTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"COMMENT_REPLY_CELL"];
        if(cell == nil){
            cell = [[CommentReplyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"COMMENT_REPLY_CELL"];
        }
        cell.userImage.layer.cornerRadius = cell.userImage.frame.size.width / 2;
        cell.userImage.clipsToBounds = YES;
        cell.userFullName.text = comment.author.fullName ;
        cell.userReplyText.text = comment.commentString ;
        PFFile *imageFile = comment.author.image;
        [imageFile getDataInBackgroundWithBlock:^(NSData *result, NSError *error) {
            if (!error){
                cell.userImage.image = [UIImage imageWithData:result];
            }
        }];
        return cell;
    }else{
        CommentsTableViewCell *cell = (CommentsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"COMMENT_CELL"];
        if(cell == nil){
            cell = [[CommentsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"COMMENT_CELL"];
        }
        cell.avatarView.layer.cornerRadius = cell.avatarView.frame.size.width / 2;
        cell.avatarView.clipsToBounds = YES;
        cell.fullName.text = comment.author.fullName ;
        cell.commentLabel.text = comment.commentString ;
        PFFile *imageFile = comment.author.image ;
        [imageFile getDataInBackgroundWithBlock:^(NSData *result, NSError *error) {
            if (!error){
                cell.avatarView.image = [UIImage imageWithData:result];
            }
        }];
        CGSize requiredSize = [Utilities getRequiredSizeForText:cell.commentLabel.text
                                                           font:[UIFont fontWithName:@"DINAlternate-Bold" size:12]
                                                       maxWidth:cell.commentLabel.frame.size.width];
        cell.commentLabelHeight.constant = requiredSize.height +1;
        return cell;
    }
}

- (IBAction)postCommentButtonAction:(id)sender {
    [self.commentText resignFirstResponder];
    BOOL isPrivateComment = [sender tag];
    _comment = [FixifyComment object];
    if (_comments.count == 1) {
        _comment.parentComment = [_comments firstObject];
        FixifyComment *rootComment = _comment.parentComment;
        [rootComment.replies addObject:[_comments firstObject]];
        [rootComment saveInBackground];
    }
    _comment.job = _job;
    _comment.commentString = self.commentText.text ;
    _comment.author = [FixifyUser currentUser];
    _comment.isPrivate = isPrivateComment;
    [Utilities progressAnimeAddedTo:self.view show:YES];
    [_comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [Utilities progressAnimeAddedTo:self.view show:NO];
            self.commentText.text = @"";
            [self getAllCommentsForJob];
        }
    }];
}

- (void)getAllCommentsForJob {
    PFQuery *commentsQuery = [FixifyComment query];
    [commentsQuery whereKey:@"job" equalTo:_job];
    [commentsQuery whereKey:@"isPrivate" equalTo:[NSNumber numberWithBool:NO]];
    [commentsQuery includeKey:@"author"];
    [commentsQuery includeKey:@"parentComment"];
    [commentsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            _comments = [objects mutableCopy];
            [self.commentTableView reloadData];
        }
    }];
}

@end
