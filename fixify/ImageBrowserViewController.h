//
//  ImageBrowserViewController.h
//  fixify
//
//  Created by Aliya  on 01/10/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageBrowserViewController : UIViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *fullScreenImageView;
@property (strong, nonatomic)  UIImage *image;

- (IBAction)doneButton:(id)sender;
@end
