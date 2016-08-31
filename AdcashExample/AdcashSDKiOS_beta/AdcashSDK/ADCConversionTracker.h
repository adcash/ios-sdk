//
//  ADCConversionTracker.h
//  adcash-ios-sdk
//
//  Created by Martin on 12/22/14.
//  Copyright (c) 2014 AdCash. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 Reports conversion in your app to Adcash.
 
 Sample usage:
 
    - (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)options
    {
        // Track launching the app
        [ADCConversionTracker reportConversionWithId:@"<YOUR_CONVERSION_ID_HERE>" campaignID:<YOUR_CAMPAIGN_ID> parameters:nil];
        return YES;
    }
*/
@interface ADCConversionTracker : NSObject


/**
 @brief Use this method to report for an occurred conversion to Adcash' server.
 
 @param conversionType Your conversion type, generated in Adcash Self Service website.
 @param campaignID Your campaign ID,
 @param parameters An optional NSDictionary with additional keys and values to send to the server.
 
 @discussion Use this method to report for a conversion to Adcash. conversion type must not be nil.
 parameters is an optional NSDictionary with keys and values of type NSString that are sent to the Adcash server.
 parameters may be nil.
 @since 2.0.0
 */
+ (void) reportConversionWithId:(NSString *)conversionType campaignID:(int)campaignID parameters:(NSDictionary *)parameters;

@end
