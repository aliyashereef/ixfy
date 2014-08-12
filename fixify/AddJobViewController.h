//
//  AddJobViewController.h
//  fixify
//
//  Created by qbadmin on 11/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddJobViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *categoryTable;
@property (strong, nonatomic) IBOutlet UIView *menuView;
- (IBAction)menuButton:(id)sender;
- (IBAction)notificationButton:(id)sender;
- (IBAction)menuCoseButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *userAvatar;
@property (strong, nonatomic) IBOutlet UILabel *userName;

@end
