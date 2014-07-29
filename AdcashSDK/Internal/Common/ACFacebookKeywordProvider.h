//
//  ACFacebookAttributionIdProvider.h
//  Adcash
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACKeywordProvider.h"

/*
 * This class enables the Adcash SDK to deliver targeted ads from Facebook via Adcash Marketplace
 * (Adcash's real-time bidding ad exchange) as part of a test program. This class sends an identifier
 * to Facebook so Facebook can select the ad Adcash will serve in your app through Adcash Marketplace.
 * If this class is removed from the SDK, your application will not receive targeted ads from
 * Facebook.
 */

@interface ACFacebookKeywordProvider : NSObject <ACKeywordProvider>

@end
