//
//  AddJobDescriptionViewController.m
//  fixify
//
//  Created by Aliya  on 29/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "AddJobDescriptionViewController.h"

@interface AddJobDescriptionViewController (){
    UIButton *addImage;
    CGRect frame;
    NSMutableArray *imageArray;
    int indexOfImage;
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
    imageArray = [[NSMutableArray alloc]init];
    addImage = [[UIButton alloc]initWithFrame:CGRectMake(12, 12, 96, 96)];
    [addImage addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
    [addImage setImage:[UIImage imageNamed:@"add_image_brown"] forState:UIControlStateNormal];
    [self.imageScroll addSubview:addImage];
   
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    indexOfImage = 0;
}

#pragma mark -Image Picker methods

//if pick a image ,view dismissed and assigned to a image view
-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info{
    frame = [addImage frame];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    UIImageView *addedImage = [[UIImageView alloc]initWithFrame:CGRectMake(frame.origin.x,frame.origin.y,96,96)];
    UIButton *deleteButton =[[UIButton alloc]initWithFrame:CGRectMake(80, 0, 20, 20)];
    [deleteButton setImage:[UIImage imageNamed:@"delete_image"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deteteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    addedImage.image = image;
    deleteButton.userInteractionEnabled = YES;
    addedImage.userInteractionEnabled = YES;
    [addedImage addSubview:deleteButton];
    [self.imageScroll addSubview:addedImage];
    addedImage.tag = indexOfImage;
    [imageArray addObject:image];
    frame.origin.x += 100;
    if (frame.origin.x >300) {
        frame.origin.y +=100;
        frame.origin.x =12;
    }
    [addImage setFrame:frame];
    self.imageScroll.contentSize = CGSizeMake(320, frame.origin.y+130);
    [self dismissViewControllerAnimated:YES completion:nil];
}

//function to dismiss view when cancel pressed
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private functions

- (IBAction)backButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)postTheJobButtonAction:(id)sender {
    [Utilities showAlertWithTitle:@"test" message:@"success"];
}

- (IBAction)addImage:(id)sender {
    indexOfImage++;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate=self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (IBAction)deteteButtonAction:(id)sender{
    UIImageView *tappedImage = (UIImageView *)[sender superview];
    [imageArray removeObjectAtIndex:(tappedImage.tag-1)];
    [tappedImage removeFromSuperview];
    int offsetMultiplier = frame.origin.y/100;
    if (offsetMultiplier >0) {
        if (frame.origin.x >12) {
            frame.origin.x -=100;
        }else{
            frame.origin.y -=offsetMultiplier * 100;
            frame.origin.x = 212;
        }
    }else{
       frame.origin.x -=100;
    }
    [addImage setFrame:frame];
}

@end
