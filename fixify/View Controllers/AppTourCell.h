//
//  AppTourCell.h
//  fixify
//
//  Created by qbadmin on 04/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppTourCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *description;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;

@end
