//
//  Utilities.h
//  fixify
//
//  Created by Aliya on 07/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject

//  Email validation.
+ (BOOL)isValidEmail:(NSString *)email;

//  Shows an alert view with the given title and message.
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;

// Alphabetic string validation.
+ (BOOL)isValidAlphaNumericString:(NSString *)string;

//  Removes blank space and new line characters from the begining and end of a string;
+ (NSString *)cleanString:(NSString *)string;

// Set border color for a view
+ (void)setBorderColor:(UIColor *)color forView:(UIView *)view ;

@end
