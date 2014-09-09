//
//  SearchAddressViewController.h
//  fixify
//
//  Created by Aliya  on 03/09/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "FixifyJob.h"


@interface SearchAddressViewController : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UITableView *resultsTableView;

@property (strong, nonatomic) CLGeocoder *geocoder;

@property (strong, nonatomic) NSMutableArray *recentSearch;

@property (weak, nonatomic) FixifyJob *job;

- (IBAction)closeButtonAction:(id)sender;

@end
