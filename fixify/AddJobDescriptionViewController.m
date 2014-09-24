//
//  AddJobDescriptionViewController.m
//  fixify
//
//  Created by Aliya  on 29/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "AddJobDescriptionViewController.h"
#import "FixifyJob.h"

@interface AddJobDescriptionViewController (){
    UIButton *addImage;
    CGRect imageFrame;
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
    [self.imageScroll bringSubviewToFront:self.messageView];
   
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
    imageFrame = [addImage frame];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    UIImageView *addedImage = [[UIImageView alloc]initWithFrame:CGRectMake(imageFrame.origin.x,imageFrame.origin.y,96,96)];
    UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(80, 0, 20, 20)];
    [deleteButton setImage:[UIImage imageNamed:@"delete_image"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deteteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    addedImage.image = image;
    deleteButton.userInteractionEnabled = YES;
    addedImage.userInteractionEnabled = YES;
    [addedImage addSubview:deleteButton];
    [self.imageScroll addSubview:addedImage];
    addedImage.tag = indexOfImage;
    NSData *imageData = UIImageJPEGRepresentation(image,.5);
    [imageArray addObject:imageData];
    imageFrame.origin.x += 100;
    if (imageFrame.origin.x > 300) {
        imageFrame.origin.y += 100;
        imageFrame.origin.x = 12;
    }
    [addImage setFrame:imageFrame];
    self.imageScroll.contentSize = CGSizeMake(320, imageFrame.origin.y+130);
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
    if(!imageArray || !imageArray.count){
        [Utilities showAlertWithTitle:@"ERROR" message:@"Please attach an image to continue"];
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _job.jobDescription = self.descriptionField.text;
        _job.owner = [FixifyUser currentUser];
        _job.imageArray = imageArray;
        _job.status = kNewJob ;
        [_job saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self performSegueWithIdentifier:kMyJobsViewSegue sender:self];
        }];
    }
}

- (IBAction)addImage:(id)sender {
    [self.messageView removeFromSuperview];
    indexOfImage++;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (IBAction)deteteButtonAction:(id)sender{
    UIImageView *tappedImage = (UIImageView *)[sender superview];
    [imageArray removeObjectAtIndex:(tappedImage.tag-1)];
    [tappedImage removeFromSuperview];
    int offsetMultiplier = imageFrame.origin.y/100;
    if (offsetMultiplier >0) {
        if (imageFrame.origin.x >12) {
            imageFrame.origin.x -=100;
        }else{
            imageFrame.origin.y -= offsetMultiplier * 100;
            imageFrame.origin.x = 212;
        }
    }else{
       imageFrame.origin.x -= 100;
    }
    [addImage setFrame:imageFrame];
}

@end
