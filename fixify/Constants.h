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
#define kReviewListCellID @"REVIEW_CELL"
#define kCommentListCellID @"COMMENTS_LIST"
#define kEstimateCellID @"ESTIMATE_CELL"
#define kCategoryCellID @"categoryCell"
#define kJObImageCellID @"JOB_IMAGE"
#define kSearchAddressCellID @"SEARCH_ADDRESS"
#define kCommentListID @"COMMENTS_LIST"
#define kJobOppurtunityCellID @"JOB_OPPURTUNITY_CELL"
#define kCustomPinAnnotation @"CustomPinAnnotationView"
#define kLoginStatus @"LOGIN_STATUS"
#define kLoggedInWithFacebook @"IS_FACEBOOK_LOGIN"
#define kPinLength 4
#define kBounceValue 20.0
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
#define kEstimateDetailViewSegue @"ESTIMATE_DETAIL"
#define kChooseAddressViewSegue @"CHOOSE_ADDRESS"
#define kEditProfileViewSegue @"EDIT_PROFILE"
#define kSearchAddressDescriptionViewSegue @"SEARCH_ADDRESS_DESCRIPTION"
#define kJobDetailViewSegue @"JOB_DETAIL"
#define kSubmitQuoteViewSegue @"SUBMIT_QUOTE"
#define kMyJobDetailViewSegue @"MY_JOB_DETAIL_VIEW"
#define kMyJobsViewSegue @"MY_JOBS"
#define kTradesmanProfileView @"TRADESMAN_PROFILE_VIEW"
// storyboard IDs

#define kMyJobsViewControllerID @"MY_JOBS_STORYBOARD_ID"
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

// job status
#define kNewJob @"New"
#define kEstimatedJob @"Estimated"
#define kInProgressJob @"In Progress"
#define kPaymentRequired @"Payment Required"
#define kJobCompleted @"JobCompleted"

// image Arrays
#define kJobProgressImageArray @[@"progress_00001@2x", @"progress_00002@2x",@"progress_00003@2x", @"progress_00004@2x", @"progress_00005@2x", @"progress_00006@2x", @"progress_00007@2x", @"progress_00008@2x", @"progress_00009@2x", @"progress_00010@2x", @"progress_00011@2x", @"progress_00012@2x", @"progress_00013@2x", @"progress_00014@2x", @"progress_00015@2x", @"progress_00016@2x", @"progress_00017@2x", @"progress_00018@2x"]

#define kJobPaymentRequiredImageArray @[@"coin_rotate_0000@2x",@"coin_rotate_0001@2x",@"coin_rotate_0002@2x",@"coin_rotate_0003@2x",@"coin_rotate_0004@2x",@"coin_rotate_0005@2x",@"coin_rotate_0006@2x",@"coin_rotate_0007@2x",@"coin_rotate_0008@2x",@"coin_rotate_0009@2x",@"coin_rotate_0010@2x",@"coin_rotate_0011@2x",@"coin_rotate_0012@2x",@"coin_rotate_0013@2x",@"coin_rotate_0014@2x",@"coin_rotate_0015@2x",@"coin_rotate_0016@2x",@"coin_rotate_0017@2x",@"coin_rotate_0018@2x",@"coin_rotate_0019@2x",@"coin_rotate_0020@2x"]

#endif
