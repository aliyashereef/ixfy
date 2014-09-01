//
//  AddJobDescriptionViewController.h
//  fixify
//
//  Created by Aliya  on 29/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddJobDescriptionViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

- (IBAction)backButtonAction:(id)sender;
- (IBAction)postTheJobButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *descriptionField;

- (IBAction)addImage:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScroll;


@end
