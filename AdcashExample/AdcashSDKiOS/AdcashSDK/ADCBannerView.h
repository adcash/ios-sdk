//
//  ADCBannerView.h
//  adcash-ios-sdk
//
//  Created by Martin on 11/23/14.
//  Copyright (c) 2014 AdCash. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Special refreshRate value, indicating that the refreshRate will be retrieved by the Adcash's server.
 
 @discussion The value that is retrieved from the server is the same as the one that you have 
 specified in your [Adcash Publisher Panel](https://www.adcash.com/console/scripts.php) for this zone id.
 
 Please note that in case you disable auto refresh
 for this zone id in your [Adcash Publisher Panel](https://www.adcash.com/console/scripts.php),
 then this ADCBannerView instance will not auto refresh anymore even though you go and revert the change.
 @since 2.0.0
 */
FOUNDATION_EXPORT NSInteger const REFRESH_RATE_USE_VALUE_FROM_SERVER;


/**
 @brief  ADCAdSize enum denotes the available sizes for banner ads that Adcash supports
 
 @since 2.0.0
 */
typedef NS_ENUM(NSUInteger, ADCAdSize){
    /**
     @brief  Smart banner "smartly" sizes ads by rendering them in screen-wide width.
Smart banners translate into the following:
     
| Size | Device | Device orientation |
|:----:|:------:|:------------------:|
|320x50| iPhone | Portrait, Landscape |
|728x90| iPad   | Portrait, Landscape |

     
     @since 2.0.0
     */
    ADCAdSizeSmartBanner,
};

@class ADCBannerView;


/**
 ADCBannerViewDelegate is the delegate class for receiving
 state change events from ADCBannerView instances. Use it to receive
 state callbacks for banner ad request success, fail, or any other event
 triggered by the user.
 
 @since 2.0.0
 */
@protocol ADCBannerViewDelegate <NSObject>

@optional
/**
 @brief Sent when the ad request has succeeded and the banner is ready to be shown.
 @param bannerView The ADCBannerView instance that succeeded to load.
 @since 2.0.0
 */
- (void) bannerViewDidReceiveAd:(ADCBannerView *)bannerView;


/**
 @brief Sent when the banner has failed to load.
 Use error param to determine what is the cause. Usually this is because there is no
 internet connectivity or because there are no more ads to show.
 @param bannerView The ADCBannerView instance that failed to load.
 @param error      NSError instance. Use it to determine why the loading has failed.
 
 @since 2.0.0
 */
- (void) bannerView:(ADCBannerView *)bannerView didFailToReceiveAdWithError:(NSError *)error;


/**
 @brief Sent just before the user is presented to a full-screen ad in response to his click action.
 Normally, the user is presented with a full-screen ad and when he taps on the close button, bannerViewWillDismissScreen: will be called.
 @param bannerView An ADCBannerView instance.
 @since 2.0.0
 */
- (void) bannerViewWillPresentScreen:(ADCBannerView *)bannerView;


/**
 @brief Sent when the app is about to enter in background mode because the user
 has clicked on an ad that navigates outside of the app to another application (e.g. App Store).
 Method `applicationDidEnterBackground:` of your app delegate is called immediately after this.
 @param bannerView An ADCBannerView instance.
 @note The method is called before calling `[[UIApplication sharedApplication] openURL:]`.
 Therefore, the application will not enter in background if `openURL:` does not succeed.
 Do not rely on the assumption that `bannerViewWillLeaveApplication:` will always be followed by
 entering the application in background mode.

 @since 2.0.0
 */
- (void) bannerViewWillLeaveApplication:(ADCBannerView *)bannerView;

/**
 @brief  Sent just before dismissing a full screen view.
 
 @param bannerView An ADCBannerView instance
 
 @since 2.0.0
 */
- (void) bannerViewWillDismissScreen:(ADCBannerView *)bannerView;

@end


/**
 ADCBannerView is a UIView subclass that display banner ads. Sample usage:
 
     // Create and initialize an instance
     ADCBannerView *bannerView = [[ADCBannerView alloc] initWithAdSize:ADCAdSizeSmartBanner
                                                                zoneID:@"YOUR_ZONE_ID_HERE"
                                                    rootViewController:self];
     // Place the ad on screen
     [self.view addSubview:bannerView];
     // Load the banner ad
     [bannerView load];
 
 @since 2.0.0
 */
@interface ADCBannerView : UIView

/**
 This is the value of the zone id that you created in adcash.com portal.
 A new zone id should be created for every unique placement of an ad in your app.
 @since 2.0.0
 */
@property (nonatomic, copy) NSString * zoneID;

/**
 An ad size of type ADCAdSize that denotes the banner size that is going to be requested.
 @since 2.0.0
 */
@property (nonatomic, assign, readonly) ADCAdSize adSize;

/**
 A UIViewController subclass that is used to show a modal overlay for the banner.
 @since 2.0.0
 */
@property (nonatomic, weak) UIViewController * rootViewController;

/**
 An object that conforms to the ADCBannerViewDelegate and can receive callbacks for banner state change.
 May be nil.
 @since 2.0.0
 */
@property (nonatomic, weak) id<ADCBannerViewDelegate> delegate;

/**
 Defaults to YES. Specifies whether the banner should auto refresh.
 @discussion The value of this property precedes the value provided by the server,
 in case refreshRate has value of REFRESH_RATE_USE_VALUE_FROM_SERVER.
 @see REFRESH_RATE_USE_VALUE_FROM_SERVER
 @see refreshRate
 @since 2.0.0
 */
@property (nonatomic, assign, readwrite) BOOL autorefreshEnabled;

/**
 This is the designated initializer for the ADCBannerView class.
 
 @param adSize             ADCAdSize type that is used to request banner size.
 @param zoneID           Unique zone id that is created in Adcash Publisher portal.
 @param rootViewController UIViewController subclass used to show a modal overlay.
 
 @return An initialized ADCBannerView instance
 
 @since 2.0.0
 */
- (instancetype) initWithAdSize:(ADCAdSize)adSize zoneID:(NSString *)zoneID rootViewController:(UIViewController *)rootViewController;

/**
 Call to start loading the banner.
 @since 2.0.0
 */
- (void) load;

@end
