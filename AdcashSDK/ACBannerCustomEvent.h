//
//  ACBannerCustomEvent.h
//  Adcash
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACBannerCustomEventDelegate.h"

/**
 * The Adcash iOS SDK mediates third party Ad Networks using custom events.  The custom events are
 * responsible for instantiating and manipulating objects in the third party SDK and translating
 * and communicating events from those objects back to the Adcash SDK by notifying a delegate.
 *
 * `ACBannerCustomEvent` is a base class for custom events that support banners. By implementing
 * subclasses of `ACBannerCustomEvent` you can enable the Adcash SDK to natively support a wide
 * variety of third-party ad networks.
 *
 * At runtime, the Adcash SDK will find and instantiate an `ACBannerCustomEvent` subclass as needed and
 * invoke its `-requestAdWithSize:customEventInfo:` method.
 */

@interface ACBannerCustomEvent : NSObject

/** @name Requesting a Banner Ad */

/**
 * Called when the Adcash SDK requires a new banner ad.
 *
 * When the Adcash SDK receives a response indicating it should load a custom event, it will send
 * this message to your custom event class. Your implementation of this method can either load a
 * banner ad from a third-party ad network, or execute any application code. It must also notify the
 * `ACBannerCustomEventDelegate` of certain lifecycle events.
 *
 * @param size The current size of the parent `ACAdView`.  You should use this information to create
 * and request a banner of the appropriate size.
 *
 * @param info A  dictionary containing additional custom data associated with a given custom event
 * request. This data is configurable on the Adcash website, and may be used to pass dynamic information, such as publisher IDs.
 */
- (void)requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info;

/** @name Callbacks */

/**
 * Called when a banner rotation should occur.
 *
 * If you call `-rotateToOrientation` on an `ACAdView`, it will forward the message to its custom event.
 * You can implement this method for third-party ad networks that have special behavior when
 * orientation changes happen.
 *
 * @param newOrientation The `UIInterfaceOrientation` passed to the `ACAdView`'s `rotateToOrientation` method.
 *
 */
- (void)rotateToOrientation:(UIInterfaceOrientation)newOrientation;

/**
 * Calld when the banner is presented on screen.
 *
 * If you decide to [opt out of automatic impression tracking](enableAutomaticImpressionAndClickTracking), you should place your
 * manual calls to [-trackImpression]([ACBannerCustomEventDelegate trackImpression]) in this method to ensure correct metrics.
 */
- (void)didDisplayAd;

/** @name Impression and Click Tracking */

/**
 * Override to opt out of automatic impression and click tracking.
 *
 * By default, the  ACBannerCustomEventDelegate will automatically record impressions and clicks in
 * response to the appropriate callbacks. You may override this behavior by implementing this method
 * to return `NO`.
 *
 * @warning **Important**: If you do this, you are responsible for calling the `[-trackImpression]([ACBannerCustomEventDelegate trackImpression])` and
 * `[-trackClick]([ACBannerCustomEventDelegate trackClick])` methods on the custom event delegate. Additionally, you should make sure that these
 * methods are only called **once** per ad.
 *
 */
- (BOOL)enableAutomaticImpressionAndClickTracking;

/** @name Communicating with the Adcash SDK */

/**
 * The `ACBannerCustomEventDelegate` to send messages to as events occur.
 *
 * The `delegate` object defines several methods that you should call in order to inform both Adcash
 * and your `ACAdView`'s delegate of the progress of your custom event.
 *
 */
@property (nonatomic, assign) id<ACBannerCustomEventDelegate> delegate;

@end
