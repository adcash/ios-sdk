//
//  ACInterstitialCustomEvent.h
//  Adcash
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACInterstitialCustomEventDelegate.h"

/**
 * The Adcash iOS SDK mediates third party Ad Networks using custom events.  The custom events are
 * responsible for instantiating and manipulating objects in the third party SDK and translating
 * and communicating events from those objects back to the Adcash SDK by notifying a delegate.
 *
 * `ACInterstitialCustomEvent` is a base class for custom events that support full-screen interstitial ads.
 * By implementing subclasses of `ACInterstitialCustomEvent` you can enable the Adcash SDK to
 * natively support a wide variety of third-party ad networks.
 *
 * At runtime, the Adcash SDK will find and instantiate an `ACInterstitialCustomEvent` subclass as needed and
 * invoke its `-requestInterstitialWithCustomEventInfo:` method.
 */


@interface ACInterstitialCustomEvent : NSObject

/** @name Requesting and Displaying an Interstitial Ad */

/**
 * Called when the Adcash SDK requires a new interstitial ad.
 *
 * When the Adcash SDK receives a response indicating it should load a custom event, it will send
 * this message to your custom event class. Your implementation of this method can either load an
 * interstitial ad from a third-party ad network, or execute any application code. It must also notify the
 * `ACInterstitialCustomEventDelegate` of certain lifecycle events.
 *
 * @param info A  dictionary containing additional custom data associated with a given custom event
 * request. This data is configurable on the Adcash website, and may be used to pass dynamic information, such as publisher IDs.
 */

- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info;

/**
 * Called when the interstitial should be displayed.
 *
 * This message is sent sometime after an interstitial has been successfully loaded, as a result
 * of your code calling `-[ACInterstitialAdController showFromViewController:]`. Your implementation
 * of this method should present the interstitial ad from the specified view controller.
 *
 * If you decide to [opt out of automatic impression tracking](enableAutomaticImpressionAndClickTracking), you should place your
 * manual calls to [-trackImpression]([ACInterstitialCustomEventDelegate trackImpression]) in this method to ensure correct metrics.
 *
 * @param rootViewController The controller to use to present the interstitial modally.
 *
 * @warning **Important**: You should not attempt to display the interstitial until you receive this message.
 */
- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController;

/** @name Impression and Click Tracking */

/**
 * Override to opt out of automatic impression and click tracking.
 *
 * By default, the  ACInterstitialCustomEventDelegate will automatically record impressions and clicks in
 * response to the appropriate callbacks. You may override this behavior by implementing this method
 * to return `NO`.
 *
 * @warning **Important**: If you do this, you are responsible for calling the `[-trackImpression]([ACInterstitialCustomEventDelegate trackImpression])` and
 * `[-trackClick]([ACInterstitialCustomEventDelegate trackClick])` methods on the custom event delegate. Additionally, you should make sure that these
 * methods are only called **once** per ad.
 */
- (BOOL)enableAutomaticImpressionAndClickTracking;

/** @name Communicating with the Adcash SDK */

/**
 * The `ACInterstitialCustomEventDelegate` to send messages to as events occur.
 *
 * The `delegate` object defines several methods that you should call in order to inform both Adcash
 * and your `ACInterstitialAdController`'s delegate of the progress of your custom event.
 *
 */

@property (nonatomic, assign) id<ACInterstitialCustomEventDelegate> delegate;

@end
