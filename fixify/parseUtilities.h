//
//  parseUtilities.h
//  fixify
//
//  Created by qbadmin on 08/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

typedef void (^Success)(PFUser *user);
typedef void (^Failure)(NSError *error);

@interface parseUtilities : NSObject

@property (nonatomic, strong) Success successCallback;
@property (nonatomic, strong) Failure failureCallback;

- (void) signUpWithUserName:(NSString *)userName
                   password:(NSString *)password
                     avatar:(UIImage *)avatar
                   fullname:(NSString *)fullName
               mobilenumber:(NSString *)mobileNumber
                  tradesman:(BOOL *)tradesman
           requestSucceeded:(void (^)(PFUser *user))success
              requestFailed:(void (^)(NSError *error))failure;

@end
