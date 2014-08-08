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


@end
