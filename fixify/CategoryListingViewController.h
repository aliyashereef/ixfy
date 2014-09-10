//
//  CategoryListingViewController.h
//  fixify
//
//  Created by Aliya  on 09/09/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryListingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *categoryTable;
@property (nonatomic, strong) NSArray *categories;

@end
