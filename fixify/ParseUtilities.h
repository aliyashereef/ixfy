//
//  ParseUtilities.h
//  fixify
//
//  Created by Vineeth on 08/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

typedef void (^Success)(PFUser *user);
typedef void (^Failure)(NSError *error);

@interface ParseUtilities : NSObject

@property (nonatomic, strong) Success successCallback;
@property (nonatomic, strong) Failure failureCallback;

- (void) signUpWithUser:(PFUser *)user
       requestSucceeded:(void (^)(PFUser *user))success
          requestFailed:(void (^)(NSError *error))failure;
- (void) logInWithUser:(PFUser *)loginUser
      requestSucceeded:(void (^)(PFUser *user))success
         requestFailed:(void (^)(NSError *error))failure;
- (void) logOutWithUser :(PFUser *)user;

@end
