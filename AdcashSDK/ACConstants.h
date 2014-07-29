//
//  ACConstants.h
//  Adcash
//
//  Created by Nafis Jamal on 2/9/11.
//  Copyright (c) 2014, Adcash OU and MoPub Inc.
//

#import <UIKit/UIKit.h>

#define AC_DEBUG_MODE               1

#define HOSTNAME                    @"m.adcash.com"
#define HOSTNAME_FOR_TESTING        @"testing.adcash.com"
#define DEFAULT_PUB_ID              @"default_pub_id"
#define AC_SERVER_VERSION           @"8"
#define AC_SDK_VERSION              @"2.2.0"

// Sizing constants.
#define ADCASH_BANNER_SIZE           CGSizeMake(320, 50)
#define ADCASH_MEDIUM_RECT_SIZE      CGSizeMake(300, 250)
#define ADCASH_LEADERBOARD_SIZE      CGSizeMake(728, 90)
#define ADCASH_WIDE_SKYSCRAPER_SIZE  CGSizeMake(160, 600)

// Miscellaneous constants.
#define MINIMUM_REFRESH_INTERVAL            5.0
#define DEFAULT_BANNER_REFRESH_INTERVAL     60
#define BANNER_TIMEOUT_INTERVAL             10
#define INTERSTITIAL_TIMEOUT_INTERVAL       30

// Feature Flags
#define SESSION_TRACKING_ENABLED            1
