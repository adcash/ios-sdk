//
//  ACMRAIDInterstitialViewController.h
//  Adcash
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import "ACInterstitialViewController.h"

#import "MRAdView.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

@protocol ACMRAIDInterstitialViewControllerDelegate;
@class ACAdConfiguration;

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface ACMRAIDInterstitialViewController : ACInterstitialViewController <MRAdViewDelegate>

- (id)initWithAdConfiguration:(ACAdConfiguration *)configuration;
- (void)startLoading;

@end

