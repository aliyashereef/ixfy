//
//  JobOppurtunityCellTableViewCell.h
//  fixify
//
//  Created by Aliya  on 19/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobOppurtunityCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *jobImage;

@property (weak, nonatomic) IBOutlet UILabel *jobDistance;

@property (weak, nonatomic) IBOutlet UILabel *jobTitle;

@property (weak, nonatomic) IBOutlet UILabel *jobDescription;

@property (weak, nonatomic) IBOutlet UILabel *jobListedDate;

@property (weak, nonatomic) IBOutlet UILabel *jobEstimates;

@end
