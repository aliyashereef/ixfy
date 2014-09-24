//
//  TradesmanProfileViewController.m
//  fixify
//
//  Created by Aliya  on 18/09/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "TradesmanProfileViewController.h"
#import "CommentsTableViewCell.h"

@interface TradesmanProfileViewController ()

@end

@implementation TradesmanProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = kThemeBackground;
    self.tradesmanName.text = _tradesman.fullName ;
    self.tradesmanImage.layer.cornerRadius =  self.tradesmanImage.frame.size.width / 2;
    self.tradesmanImage.clipsToBounds = YES;
    [_tradesman.image getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            self.tradesmanImage.image = [UIImage imageWithData:imageData];
        }
    }];

}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
#pragma mark - UITableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentsTableViewCell *cell = (CommentsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCommentListCellID];
        if(cell == nil){
            cell = [[CommentsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kReviewListCellID];
        }
    cell.avatarView.layer.cornerRadius =  cell.avatarView.frame.size.width / 2;
    cell.avatarView.clipsToBounds = YES;
    return cell;
}

- (IBAction)backButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
