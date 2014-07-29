//
//  ACBaseBannerAdapter.h
//  Adcash
//
//  Created by Nafis Jamal on 1/19/11.
//  Copyright (c) 2014, Adcash OU and MoPub Inc.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ACAdView.h"

@protocol ACBannerAdapterDelegate;
@class ACAdConfiguration;

@interface ACBaseBannerAdapter : NSObject
{
    id<ACBannerAdapterDelegate> _delegate;
}

@property (nonatomic, assign) id<ACBannerAdapterDelegate> delegate;
@property (nonatomic, copy) NSURL *impressionTrackingURL;
@property (nonatomic, copy) NSURL *clickTrackingURL;

- (id)initWithDelegate:(id<ACBannerAdapterDelegate>)delegate;

/*
 * Sets the adapter's delegate to nil.
 */
- (void)unregisterDelegate;

/*
 * -_getAdWithConfiguration wraps -getAdWithConfiguration in retain/release calls to prevent the
 * adapter from being prematurely deallocated.
 */
- (void)getAdWithConfiguration:(ACAdConfiguration *)configuration containerSize:(CGSize)size;
- (void)_getAdWithConfiguration:(ACAdConfiguration *)configuration containerSize:(CGSize)size;

- (void)didStopLoading;
- (void)didDisplayAd;

/*
 * Your subclass should implement this method if your native ads vary depending on orientation.
 */
- (void)rotateToOrientation:(UIInterfaceOrientation)newOrientation;

- (void)trackImpression;

- (void)trackClick;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@protocol ACBannerAdapterDelegate

@required

- (ACAdView *)banner;
- (id<ACAdViewDelegate>)bannerDelegate;
- (UIViewController *)viewControllerForPresentingModalView;
- (ACNativeAdOrientation)allowedNativeAdsOrientation;
- (CLLocation *)location;

/*
 * These callbacks notify you that the adapter (un)successfully loaded an ad.
 */
- (void)adapter:(ACBaseBannerAdapter *)adapter didFailToLoadAdWithError:(NSError *)error;
- (void)adapter:(ACBaseBannerAdapter *)adapter didFinishLoadingAd:(UIView *)ad;

/*
 * These callbacks notify you that the user interacted (or stopped interacting) with the native ad.
 */
- (void)userActionWillBeginForAdapter:(ACBaseBannerAdapter *)adapter;
- (void)userActionDidFinishForAdapter:(ACBaseBannerAdapter *)adapter;

/*
 * This callback notifies you that user has tapped on an ad which will cause them to leave the
 * current application (e.g. the ad action opens the iTunes store, Mobile Safari, etc).
 */
- (void)userWillLeaveApplicationFromAdapter:(ACBaseBannerAdapter *)adapter;

@end
