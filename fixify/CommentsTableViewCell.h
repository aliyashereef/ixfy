//
//  CommentsTableViewCell.h
//  fixify
//
//  Created by Aliya  on 21/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SwipeableCellDelegate <NSObject>
@optional
- (void)deleteButtonActionForCell:(UITableViewCell *)cell;
- (void)replyButtonActionForCell:(UITableViewCell *)cell;
- (void)flagButtonActionForCell:(UITableViewCell *)cell;
- (void)cellDidOpen:(UITableViewCell *)cell;
- (void)cellDidClose:(UITableViewCell *)cell;
@end

@interface CommentsTableViewCell : UITableViewCell <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *cellContentView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replyButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flagButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteButtonWidth;
@property (nonatomic, weak) IBOutlet UIButton *deleteButton;
@property (nonatomic, weak) IBOutlet UIButton *replyButton;
@property (nonatomic, weak) IBOutlet UIButton *flagButton;
@property (nonatomic, weak) id <SwipeableCellDelegate> delegate;

@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, assign) CGPoint panStartPoint;
@property (nonatomic, assign) CGFloat startingRightLayoutConstraintConstant;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewRightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewLeftConstraint;
- (void)openCell;
@end
