//
//  Utilities.h
//  fixify
//
//  Created by Aliya on 07/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

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

// Validate Mobile Number
+ (BOOL)isValidMobileNumber:(NSString *)checkString;

//  Returns required size for text with max width and font.
+ (CGSize)getRequiredSizeForText:(NSString *)text font:(UIFont *)font maxWidth:(CGFloat)width;

// Validate a numeric string.
+ (BOOL)isValidNumber:(NSString *)Number;

// Returns an array with location details.
+ (NSArray *)getArrayForLocation :(CLPlacemark *)placemark;

//returns a date string for date
+ (NSString *)formatDate:(NSDate *)date;

//returns a date string for date
+ (NSString *)formatDateForEstimate:(NSDate *)date;

//show animation for menu view
+ (void)showAnimationForView:(UIView *)view;

//hide animation for menu view
+ (void)hideAnimationForView:(UIView *)view;
@end
