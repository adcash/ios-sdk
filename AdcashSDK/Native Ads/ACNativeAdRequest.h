//
//  ACNativeAdRequest.h
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ACNativeAd;
@class ACNativeAdRequest;
@class ACNativeAdRequestTargeting;

typedef void(^ACNativeAdRequestHandler)(ACNativeAdRequest *request,
                                      ACNativeAd *response,
                                      NSError *error);

////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * The ACNativeAdRequest class is used to manage requests to the Adcash ad server for native ads.
 */

@interface ACNativeAdRequest : NSObject

/** @name Targeting Information */

/**
 * An object representing targeting parameters that can be passed to the Adcash ad server to
 * serve more relevant advertising.
 */
@property (nonatomic, retain) ACNativeAdRequestTargeting *targeting;

/** @name Initializing and Starting an Ad Request */

/**
 * Initializes a request object.
 *
 * @param identifier The ad unit identifier for this request. An ad unit is a defined placement in
 * your application set aside for advertising. Ad unit IDs are created on the Adcash website.
 *
 * @return An ACNativeAdRequest object.
 */
+ (ACNativeAdRequest *)requestWithAdUnitIdentifier:(NSString *)identifier;

/**
 * Executes a request to the Adcash ad server.
 *
 * @param handler A block to execute when the request finishes. The block includes as parameters the
 * request itself and either a valid ACNativeAd or an NSError object indicating failure.
 */
- (void)startWithCompletionHandler:(ACNativeAdRequestHandler)handler;

@end
