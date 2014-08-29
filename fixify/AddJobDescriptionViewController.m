//
//  AddJobDescriptionViewController.m
//  fixify
//
//  Created by Aliya  on 29/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "AddJobDescriptionViewController.h"

@interface AddJobDescriptionViewController (){
    UIImageView *addedImage;
}

@end

@implementation AddJobDescriptionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark -Image Picker methods

//if pick a image ,view dismissed and assigned to a image view
-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    addedImage.image = image;
}

//function to dismiss view when cancel pressed
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private functions

- (IBAction)backButtonAction:(id)sender {
}

- (IBAction)postTheJobButtonAction:(id)sender {
    [Utilities showAlertWithTitle:@"test" message:@"success"];
}

- (IBAction)addImage:(id)sender {
    addedImage = [[UIImageView alloc]initWithFrame:CGRectMake(_addImage.bounds.origin.x,_addImage.bounds.origin.y, _addImage.bounds.size.width, _addImage.bounds.size.height)];
    CGRect frame = [_addImage frame];
    frame.origin.x += 100;      
    [_addImage setFrame:frame];
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate=self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

@end
