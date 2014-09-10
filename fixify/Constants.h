//
//  Constants.h
//  fixify
//
//  Created by Aliya on 05/08/14.
//  Copyright (c) 2014 qburst. All rights reserved.
//

#ifndef fixify_Constants_h
#define fixify_Constants_h

// Parse Id

#define ParseApplicationID @"J8Tgeys63fSsOo87OQxzOsklJrqf6CyyqJEiSS12"
#define ParseClientKey @"6FuE9TxfGolNvrwxCmq9gAKdZW4MNljdWr8YERym"

//Facebook

#define FACEBOOK_APP_ID @"627081887405413"

//constants

#define kCategoryCellID @"categoryCell"
#define kJObImageCellID @"JOB_IMAGE"
#define kSearchAddressCellID @"SEARCH_ADDRESS"
#define kCommentListID @"COMMENTS_LIST"
#define kJobOppurtunityCellID @"JOB_OPPURTUNITY_CELL"
#define kCustomPinAnnotation @"CustomPinAnnotationView"
#define kLoginStatus @"LOGIN_STATUS"
#define kLoggedInWithFacebook @"IS_FACEBOOK_LOGIN"
#define kPinLength 4

//colors

#define kThemeBrown   [UIColor colorWithRed:(float)140/255 green:(float)131/255 blue:(float)123/255 alpha:1]      

//fonts

#define kThemeFont [UIFont fontWithName:@"DINAlternate-Bold" size:12.0f]

//Background images

#define kThemeBackground [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_blurred"]]

// plist attributes

#define kPlistName @"JobList"
#define kPlistTitle @"title"
#define kPlistImage @"image"

//segue identifiers

#define kChooseAddressSegue @"CHOOSE_ADDRESS"
#define kEditProfileSegue @"EDIT_PROFILE"
#define kSearchAddressDescription @"SEARCH_ADDRESS_DESCRIPTION"

// storyboard IDs

#define kMyJobsViewControllerID @"MY_JOBS"
#define kCategoryListingViewControllerID @"CategoryListingViewControllerStoryBoardID"
#define kEditProfileViewControllerID @"EditProfileViewStoryBoardID"
#define kAddJobViewControllerID @"AddJobViewControllerStoryBoardID"
#define kTradesmanViewControllerID @"TradesmanViewControllerID"

// Animation durations
#define kMenuViewAnimationDuration .75
#define kMapGeocodeDelay 0.3

// strings
#define kViewTitle @"Add a Job"

//map span cordinates
#define kSpanX 0.00725
#define kSpanY 0.00725

// user default keys
#define kSearchIndex @"SEARCH_INDEX"
#define kRecentSearch @"RECENT_SEARCHES"

// errors
#define kError @"ERROR"
#define kLocationDenied @"Location Services Denied by User"
#define kNoNetwork @"No Network"
#define kNoResultsFound @"No Result Found"

//notification names
#define kFilterSelectionNotification @"FILTER SELECTION NOTIFICATION"
#define kCategorySelectedNotification @"SubCategoryItemSelected"
#endif
