//
//  ACBannerAdManager.h
//  Adcash
//
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACAdServerCommunicator.h"
#import "ACBaseBannerAdapter.h"

@protocol ACBannerAdManagerDelegate;

@interface ACBannerAdManager : NSObject <ACAdServerCommunicatorDelegate, ACBannerAdapterDelegate>

@property (nonatomic, assign) id<ACBannerAdManagerDelegate> delegate;

- (id)initWithDelegate:(id<ACBannerAdManagerDelegate>)delegate;

- (void)loadAd;
- (void)forceRefreshAd;
- (void)stopAutomaticallyRefreshingContents;
- (void)startAutomaticallyRefreshingContents;
- (void)rotateToOrientation:(UIInterfaceOrientation)orientation;

// Deprecated.
- (void)customEventDidLoadAd;
- (void)customEventDidFailToLoadAd;
- (void)customEventActionWillBegin;
- (void)customEventActionDidEnd;

@end
