//
//  MyJobsCollectionViewCell.h
//  fixify
//
//  Created by Aliya  on 02/09/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyJobsCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *jobCategoryImage;

@property (weak, nonatomic) IBOutlet UILabel *listedDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *estimatesNumberLabel;

@property (weak, nonatomic) IBOutlet UIImageView *myJobImage;

@property (weak, nonatomic) IBOutlet UILabel *myJobCategoryLabel;

@property (weak, nonatomic) IBOutlet UILabel *myJobDescriptionLabel;

@end
