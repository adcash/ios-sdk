//
//  ACLegacyInterstitialCustomEventAdapter.h
//  Adcash
//
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import "ACBaseInterstitialAdapter.h"

@interface ACLegacyInterstitialCustomEventAdapter : ACBaseInterstitialAdapter

- (void)customEventDidLoadAd;
- (void)customEventDidFailToLoadAd;
- (void)customEventActionWillBegin;

@end
