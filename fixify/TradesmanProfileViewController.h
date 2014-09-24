//
//  TradesmanProfileViewController.h
//  fixify
//
//  Created by Aliya  on 18/09/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FixifyUser.h"

@interface TradesmanProfileViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tradesmanName;
@property (weak, nonatomic) IBOutlet UIImageView *tradesmanImage;

@property (weak, nonatomic) FixifyUser *tradesman;
- (IBAction)backButtonAction:(id)sender ;
@end
