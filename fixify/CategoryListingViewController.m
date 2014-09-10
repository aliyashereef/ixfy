//
//  CategoryListingViewController.m
//  fixify
//
//  Created by Aliya  on 09/09/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "CategoryListingViewController.h"

@interface CategoryListingViewController ()

@end

@implementation CategoryListingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    _categories= [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:kPlistName ofType:@"plist"]];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (IBAction)hideSubCategoryList:(id)sender {
    self.view.hidden = YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CategoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.textLabel.font = kThemeFont;
    cell.textLabel.textColor = kThemeBrown;
    cell.textLabel.text = [[_categories objectAtIndex:indexPath.row] valueForKey:@"title"];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *index = [NSNumber numberWithInt:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:kCategorySelectedNotification
                                                        object:index];
}

@end
