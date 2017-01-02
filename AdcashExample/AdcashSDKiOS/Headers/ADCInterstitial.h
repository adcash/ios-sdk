//
//  ADCInterstitial.h
//  adcash-ios-sdk
//
//  Created by Martin on 11/23/14.
//  Copyright (c) 2014 AdCash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ADCInterstitial;

/**
 ADCInterstitialDelegate is the delegate class for receiving
 state change events from ADCInterstitial instances. Use it to receive
 state callbacks for interstitial ad request success, fail, or any other event
 triggered by the user.
 @since 2.0.0
 */
@protocol ADCInterstitialDelegate <NSObject>

@optional
/**
 @brief  Sent when the ad request has succeeded and the interstitial is ready to be shown.
 
 @param interstitial An ADCInterstitial instance that succeeded to load.
 @discussion
 When the interstitial is loaded, you can use this callback to present the interstitial in
 your view controller, like so:
 
    - (void) interstitialDidReceiveAd:(ADCInterstitial *)interstitial
    {
        [interstitial presentFromViewController:self];
    }

 @since 2.0.0
 */
- (void) interstitialDidReceiveAd:(ADCInterstitial *)interstitial;

/**
 @brief  Sent when the interstitial has failed to load.
 Use error param to determine what is the cause. Usually this is because there is no
 internet connectivity or because there are no more interstitial ads to show.
 
 @param interstitial An ADCInterstitial instance that failed to load.
 @param error        A NSError instance. Use it to determine why the loading has failed.
 
 @since 2.0.0
 */
- (void) interstitial:(ADCInterstitial *)interstitial didFailToReceiveAdWithError:(NSError *)error;

/**
 @brief  Sent just before presenting the interstitial.
 
 @param interstitial An ADCInterstitial instance that is about to be shown.
 
 @since 2.0.0
 */
- (void) interstitialWillPresentScreen:(ADCInterstitial *)interstitial;

/**
 @brief  Sent just before the interstitial is to be dismissed.
 
 @param interstitial An ADCInterstitial instance that is about to be dismissed.
 
 @since 2.0.0
 */
- (void) interstitialWillDismissScreen:(ADCInterstitial *)interstitial;


/**
 @brief  Sent when the app is about to enter in background because the user
 has clicked on an ad that navigates outside of the app to another application (e.g. App Store).
 Method `applicationDidEnterBackground:` of your app delegate is called immediately after this.
 @note The method is called before calling `[[UIApplication sharedApplication] openURL:]`.
 Therefore, the application will not enter in background if `openURL:` does not succeed.
 Do not rely on the assumption that `interstitialWillLeaveApplication:` will always be followed by
 entering the application in background mode.
 
 @param interstitial An ADCInterstitial instance.
 
 @since 2.0.0
 */
- (void) interstitialWillLeaveApplication:(ADCInterstitial *)interstitial;

@end



/**
 Class to display an Interstitial Ad.
 Interstitials are full screen advertisements that are shown at natural
 transition points in your application such as between game levels, when
 switching news stories, in general when transitioning from one view controller
 to another. It is best to request for an interstitial several seconds before
 when it is actually needed, so that it can preload its content and become
 ready to present, and when the time comes, it can be immediately presented to
 the user with a smooth experience.
 @since 2.0.0
 */
@interface ADCInterstitial : NSObject

/**
 This is the value of the zone id that you created in adcash.com portal.
 A new zone id should be created for every unique placement of an ad in your app.
 @since 2.0.0
 */
@property (nonatomic, copy, readonly) NSString * zoneID;

/**
 Indicates whether the interstitial is ready to be presented.
 @since 2.0.0
 */
@property (nonatomic, readonly, assign) BOOL isReady;

/**
 Indicates whether the dynamic interstitial(video) is ready to be presented.
 @since 2.2.2
 */
@property (nonatomic, readonly, assign) BOOL isVideoReady;

/**
 An object that conforms to the ADCInterstitialDelegate and can receive callbacks
 for interstitial state change. May be nil.
 @since 2.0.0
 */
@property (nonatomic, weak) id<ADCInterstitialDelegate> delegate;

/**
 This is the designated initializer for the ADCInterstitial class.
 @param zoneID Unique zone id that is created in Adcash Publisher portal.
 
 @return An initialized ADCInterstitial instance
 
 @since 2.0.0
 */
- (instancetype) initWithZoneID:(NSString *)zoneID;

/**
 This is a convenience class method that calls initWithZoneID: internally.
 @param zoneID Unique zone id that is created in Adcash Publisher portal.
 
 @return An initialized ADCInterstitial instance.
 
 @since 2.0.0
 */
+ (instancetype) interstitialWithZoneID:(NSString *)zoneID;

/**
 Call to start loading the interstitial.
 @since 2.0.0
 */
- (void) load;

/**
 Call when the interstitial is loaded successfully to present it on screen.
 @param rootViewController An UIViewController instance that is used to present modal overlay.
 
 @since 2.0.0
 */
- (void) presentFromRootViewController:(UIViewController *)rootViewController;

@end
