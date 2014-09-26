//
//  CommentsTableViewCell.m
//  fixify
//
//  Created by Aliya  on 21/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "CommentsTableViewCell.h"

@implementation CommentsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panThisCell:)];
    self.panRecognizer.delegate = self;
    [self.cellContentView addGestureRecognizer:self.panRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}

- (IBAction)buttonClicked:(id)sender {
    if (sender == self.replyButton) {
        [self.delegate replyButtonActionForCell:self];
    } else if (sender == self.flagButton) {
        [self.delegate flagButtonActionForCell:self];
    } else if (sender == self.deleteButton){
        [self.delegate deleteButtonActionForCell:self];
    }
}

- (void)prepareForReuse{
    [super prepareForReuse];
    [self resetConstraintContstantsToZero:NO notifyDelegateDidClose:NO];
}

- (void)openCell{
    [self setConstraintsToShowAllButtons:NO notifyDelegateDidOpen:NO];
}

- (CGFloat)buttonTotalWidth{
    return CGRectGetWidth(self.frame) - CGRectGetMinX(self.replyButton.frame);
}

- (void)panThisCell:(UIPanGestureRecognizer *)recognizer{
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.panStartPoint = [recognizer translationInView:self.cellContentView];
            self.startingRightLayoutConstraintConstant = self.contentViewRightConstraint.constant;
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint currentPoint = [recognizer translationInView:self.cellContentView];
            CGFloat deltaX = currentPoint.x - self.panStartPoint.x;
            BOOL panningLeft = NO;
            if (currentPoint.x < self.panStartPoint.x) {
                panningLeft = YES;
            }
            if (self.startingRightLayoutConstraintConstant == 0) {
                if (!panningLeft) {
                    CGFloat constant = MAX(-deltaX, 0);
                    if (constant == 0) {
                        [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:NO];
                    } else {
                        self.contentViewRightConstraint.constant = constant;
                    }
                } else {
                    CGFloat constant = MIN(-deltaX, [self buttonTotalWidth]);
                    if (constant == [self buttonTotalWidth]) {
                        [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO];
                    } else {
                        self.contentViewRightConstraint.constant = constant;
                    }
                }
            }else {
                CGFloat adjustment = self.startingRightLayoutConstraintConstant - deltaX;
                if (!panningLeft) {
                    CGFloat constant = MAX(adjustment, 0);
                    if (constant == 0) {
                        [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:NO];
                    } else {
                        self.contentViewRightConstraint.constant = constant;
                    }
                } else {
                    CGFloat constant = MIN(adjustment, [self buttonTotalWidth]);
                    if (constant == [self buttonTotalWidth]) {
                        [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO];
                    } else {
                        self.contentViewRightConstraint.constant = constant;
                    }
                }
            }
            self.contentViewLeftConstraint.constant = -self.contentViewRightConstraint.constant;
        }
            break;
        case UIGestureRecognizerStateEnded:
            if (self.startingRightLayoutConstraintConstant == 0) {
                CGFloat halfOfButtonOne = CGRectGetWidth(self.deleteButton.frame) / 2;
                if (self.contentViewRightConstraint.constant >= halfOfButtonOne) {
                   [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
                } else {
                    [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
                }
            } else {
                CGFloat buttonOnePlusHalfOfButton2 = CGRectGetWidth(self.deleteButton.frame) + (CGRectGetWidth(self.replyButton.frame) / 2);
                if (self.contentViewRightConstraint.constant >= buttonOnePlusHalfOfButton2) {
                    [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
                } else {
                    [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
                }
            }
            break;
        case UIGestureRecognizerStateCancelled:
            if (self.startingRightLayoutConstraintConstant == 0) {
                [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
            } else {
                [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
            }
            break;
        default:
            break;
    }
}

- (void)updateConstraintsIfNeeded:(BOOL)animated completion:(void (^)(BOOL finished))completion;{
    float duration = 0;
    if (animated) {
        duration = 0.1;
    }
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self layoutIfNeeded];
    } completion:completion];
}

- (void)resetConstraintContstantsToZero:(BOOL)animated notifyDelegateDidClose:(BOOL)notifyDelegate{
    if (notifyDelegate) {
        [self.delegate cellDidClose:self];
    }
    if (self.startingRightLayoutConstraintConstant == 0 &&
        self.contentViewRightConstraint.constant == 0) {
        return;
    }
    self.contentViewRightConstraint.constant = -kBounceValue;
    self.contentViewLeftConstraint.constant = kBounceValue;
    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
        self.contentViewRightConstraint.constant = 0;
        self.contentViewLeftConstraint.constant = 0;
        [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
            self.startingRightLayoutConstraintConstant = self.contentViewRightConstraint.constant;
        }];
    }];
}


- (void)setConstraintsToShowAllButtons:(BOOL)animated notifyDelegateDidOpen:(BOOL)notifyDelegate{
    if (notifyDelegate) {
        [self.delegate cellDidOpen:self];
    }
    if (self.startingRightLayoutConstraintConstant == [self buttonTotalWidth] &&
        self.contentViewRightConstraint.constant == [self buttonTotalWidth]) {
        return;
    }
    self.contentViewLeftConstraint.constant = -[self buttonTotalWidth] - kBounceValue;
    self.contentViewRightConstraint.constant = [self buttonTotalWidth] + kBounceValue;
    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
        self.contentViewLeftConstraint.constant = -[self buttonTotalWidth];
        self.contentViewRightConstraint.constant = [self buttonTotalWidth];
        [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
            self.startingRightLayoutConstraintConstant = self.contentViewRightConstraint.constant;
        }];
    }];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

@end
