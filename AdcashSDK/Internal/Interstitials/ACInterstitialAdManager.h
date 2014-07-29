//
//  ACInterstitialAdManager.h
//  Adcash
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import "ACAdServerCommunicator.h"
#import "ACBaseInterstitialAdapter.h"

@class CLLocation;
@protocol ACInterstitialAdManagerDelegate;

@interface ACInterstitialAdManager : NSObject <ACAdServerCommunicatorDelegate,
    ACInterstitialAdapterDelegate>

@property (nonatomic, assign) id<ACInterstitialAdManagerDelegate> delegate;
@property (nonatomic, assign, readonly) BOOL ready;

- (id)initWithDelegate:(id<ACInterstitialAdManagerDelegate>)delegate;

- (void)loadInterstitialWithAdUnitID:(NSString *)ID
                            keywords:(NSString *)keywords
                            location:(CLLocation *)location
                             testing:(BOOL)testing;
- (void)presentInterstitialFromViewController:(UIViewController *)controller;

// Deprecated
- (void)customEventDidLoadAd;
- (void)customEventDidFailToLoadAd;
- (void)customEventActionWillBegin;

@end
