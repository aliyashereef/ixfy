//
//  EstimatesTableViewCell.h
//  fixify
//
//  Created by Aliya  on 15/09/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EstimatesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *tradesmanAvatar;
@property (weak, nonatomic) IBOutlet UILabel *tradesmanName;
@property (weak, nonatomic) IBOutlet UILabel *estimateAmount;

@end
