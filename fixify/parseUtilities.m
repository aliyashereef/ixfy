//
//  parseUtilities.m
//  fixify
//
//  Created by qbadmin on 08/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "parseUtilities.h"
#import <Parse/Parse.h>

@implementation parseUtilities

- (void) signUpWithUserName:(NSString *)userName
       password:(NSString *)password
         avatar:(UIImage *)avatar
       fullname:(NSString *)fullName
   mobilenumber:(NSString *)mobileNumber
      tradesman:(BOOL *)tradesman
           requestSucceeded:(void (^)(PFUser *user))success
              requestFailed:(void (^)(NSError *error))failure
{
    self.successCallback = success;
    self.failureCallback = failure;
    PFUser *user = [PFUser user];
    user.username = userName;
    user.password = password;
    user[@"FullName"]     = fullName;
    user[@"MobileNumber"] = mobileNumber;
    NSData *imageData = UIImagePNGRepresentation(avatar);
    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
    user[@"Image"] = imageFile;
    
    if (tradesman) {
        user[@"Tradesman"] = @"YES";
    }
    else{
        user[@"Tradesman"] = @"NO";
    }
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
               if (!error) {
                   self.successCallback(user);
        } else {
            self.failureCallback(error);
        }
    }];
}


@end
