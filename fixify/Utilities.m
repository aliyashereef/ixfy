//
//  Utilities.m
//  fixify
//
//  Created by Aliya on 07/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

//  Email validation.
+ (BOOL)isValidEmail:(NSString *)email {
    BOOL result;
    NSString* emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    result = [emailTest evaluateWithObject:email];
    return result;
}

// Alphabetic string validation.
+ (BOOL)isValidAlphaNumericString:(NSString *)string {
    BOOL result;
    NSString* nameRegex = @"[A-Z0-9a-z._%+-]+([\\s]+[A-Z0-9a-z._%+-]*)?";
    NSPredicate* nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
    result = [nameTest evaluateWithObject:string];
    return result;
}

//  Removes blank space and new line characters from the begining and end of a string
+ (NSString *)cleanString:(NSString *)string {
    return[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

//  Shows an alert view with the given title and message.
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

// Set border colour for a view
+ (void)setBorderColor:(UIColor *)color forView:(UIView *)view {
    view.layer.borderColor = [color CGColor];
    view.layer.borderWidth = 1.0f;
}

// Validate Mobile Number
+ (BOOL)stringIsValidMobileNumber:(NSString *)checkString{
    NSString *phoneRegex = @"^[0-9]{6,14}$";
    NSPredicate *mobileNumberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [mobileNumberTest evaluateWithObject:checkString];
}

@end
