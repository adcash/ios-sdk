//
//  ACBaseInterstitialAdapter.h
//  Adcash
//
//  Created by Nafis Jamal on 4/27/11.
//  Copyright 2011 Adcash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ACAdConfiguration, CLLocation;

@protocol ACInterstitialAdapterDelegate;

@interface ACBaseInterstitialAdapter : NSObject

@property (nonatomic, assign) id<ACInterstitialAdapterDelegate> delegate;

/*
 * Creates an adapter with a reference to an ACInterstitialAdManager.
 */
- (id)initWithDelegate:(id<ACInterstitialAdapterDelegate>)delegate;

/*
 * Sets the adapter's delegate to nil.
 */
- (void)unregisterDelegate;

- (void)getAdWithConfiguration:(ACAdConfiguration *)configuration;
- (void)_getAdWithConfiguration:(ACAdConfiguration *)configuration;

- (void)didStopLoading;

/*
 * Presents the interstitial from the specified view controller.
 */
- (void)showInterstitialFromViewController:(UIViewController *)controller;

@end

@interface ACBaseInterstitialAdapter (ProtectedMethods)

- (void)trackImpression;
- (void)trackClick;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@class ACInterstitialAdController;

@protocol ACInterstitialAdapterDelegate

- (ACInterstitialAdController *)interstitialAdController;
- (id)interstitialDelegate;
- (CLLocation *)location;

- (void)adapterDidFinishLoadingAd:(ACBaseInterstitialAdapter *)adapter;
- (void)adapter:(ACBaseInterstitialAdapter *)adapter didFailToLoadAdWithError:(NSError *)error;
- (void)interstitialWillAppearForAdapter:(ACBaseInterstitialAdapter *)adapter;
- (void)interstitialDidAppearForAdapter:(ACBaseInterstitialAdapter *)adapter;
- (void)interstitialWillDisappearForAdapter:(ACBaseInterstitialAdapter *)adapter;
- (void)interstitialDidDisappearForAdapter:(ACBaseInterstitialAdapter *)adapter;
- (void)interstitialDidExpireForAdapter:(ACBaseInterstitialAdapter *)adapter;
- (void)interstitialWillLeaveApplicationForAdapter:(ACBaseInterstitialAdapter *)adapter;

@end
