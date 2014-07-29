//
//  ACMRAIDInterstitialCustomEvent.h
//  Adcash
//
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import "ACInterstitialCustomEvent.h"
#import "ACMRAIDInterstitialViewController.h"
#import "ACPrivateInterstitialCustomEventDelegate.h"

@interface ACMRAIDInterstitialCustomEvent : ACInterstitialCustomEvent <ACInterstitialViewControllerDelegate>

@property (nonatomic, assign) id<ACPrivateInterstitialCustomEventDelegate> delegate;

@end
