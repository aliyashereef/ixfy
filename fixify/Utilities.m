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
+ (BOOL)isValidMobileNumber:(NSString *)mobileNumber{
    NSString *phoneRegex = @"^[0-9]{6,14}$";
    NSPredicate *mobileNumberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [mobileNumberPredicate evaluateWithObject:mobileNumber];
}

//  Returns required size for text with max width and font.
+ (CGSize)getRequiredSizeForText:(NSString *)text font:(UIFont *)font maxWidth:(CGFloat)width {
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil];
    return textRect.size;
}

// Validate a numeric string.
+ (BOOL)isValidNumber:(NSString *)Number{
    NSString *phoneRegex = @"^(?:|0|[1-9]\\d*)(?:\\.\\d*)?$";
    NSPredicate *NumberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [NumberPredicate evaluateWithObject:Number];
}

// Returns an array with location details.
+ (NSArray *)getArrayForLocation :(CLPlacemark *)placemark{
    NSArray *locationArray;
    NSDictionary *dictionary = [placemark addressDictionary];
    NSString *addressString = [NSString stringWithFormat:@"%@, %@, %@",[dictionary valueForKey:@"Street"],
                               [dictionary valueForKey:@"City"],
                               [dictionary valueForKey:@"State"]];
    NSString *locationLatitude = [NSString stringWithFormat:@"%f",placemark.location.coordinate.latitude];
    NSString *locationLongitude = [NSString stringWithFormat:@"%f",placemark.location.coordinate.longitude];
    locationArray = @[locationLatitude,locationLongitude,addressString];
    return locationArray;
}

@end
