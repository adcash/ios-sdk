//
//  ACPrivateInterstitialcustomEventDelegate.h
//  Adcash
//
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACInterstitialCustomEventDelegate.h"

@class ACAdConfiguration;
@class CLLocation;

@protocol ACPrivateInterstitialCustomEventDelegate <ACInterstitialCustomEventDelegate>

- (NSString *)adUnitId;
- (ACAdConfiguration *)configuration;
- (id)interstitialDelegate;

@end
