//
//  CommentReplyTableViewCell.h
//  fixify
//
//  Created by Aliya  on 15/09/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentReplyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userFullName;
@property (weak, nonatomic) IBOutlet UILabel *userReplyText;

@end
