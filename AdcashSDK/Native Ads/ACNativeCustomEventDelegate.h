//
//  ACNativeCustomEventDelegate.h
//  Copyright (c) 2014 Adcash. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ACNativeAd;
@class ACNativeCustomEvent;

/**
 * Instances of your custom subclass of `ACNativeCustomEvent` will have an `ACNativeCustomEventDelegate` delegate.
 * You use this delegate to communicate ad events back to the Adcash SDK.
 */
@protocol ACNativeCustomEventDelegate <NSObject>

/**
 * This method is called when the ad and all required ad assets are loaded.
 *
 * @param event You should pass `self` to allow the Adcash SDK to associate this event with the correct
 * instance of your custom event.
 * @param adObject An ACNativeAd object, representing the ad that was retrieved.
 */
- (void)nativeCustomEvent:(ACNativeCustomEvent *)event didLoadAd:(ACNativeAd *)adObject;

/**
 * This method is called when the ad or any required ad assets fail to load.
 *
 * @param event You should pass `self` to allow the Adcash SDK to associate this event with the correct
 * instance of your custom event.
 * @param error (*optional*) You may pass an error describing the failure.
 */
- (void)nativeCustomEvent:(ACNativeCustomEvent *)event didFailToLoadAdWithError:(NSError *)error;

@end
