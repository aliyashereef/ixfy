//
//  ParseUtilities.m
//  fixify
//
//  Created by Vineeth on 08/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "ParseUtilities.h"
#import <Parse/Parse.h>

@implementation ParseUtilities

// Parse signup
- (void) signUpWithUser:(PFUser *)user
       requestSucceeded:(void (^)(PFUser *user))success
          requestFailed:(void (^)(NSError *error))failure
{
    self.successCallback = success;
    self.failureCallback = failure;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            self.successCallback(user);
        } else {
            self.failureCallback(error);
        }
    }];
}

//parse login
- (void) logInWithUser:(PFUser *)loginUser
      requestSucceeded:(void (^)(PFUser *user))success
         requestFailed:(void (^)(NSError *error))failure
{
    self.successCallback = success;
    self.failureCallback = failure;
    
    [PFUser logInWithUsernameInBackground:loginUser.username password:loginUser.password
        block:^(PFUser *user, NSError *error){
            if (!error) {
                self.successCallback(user);
            }else{
                self.failureCallback(error);
            }
    }];
}

-(void) logOutWithUser :(PFUser *)user
{
    [PFUser logOut];
}

@end
