//
//  ACHTMLInterstitialCustomEvent.h
//  Adcash
//
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import "ACInterstitialCustomEvent.h"
#import "ACHTMLInterstitialViewController.h"
#import "ACPrivateInterstitialCustomEventDelegate.h"

@interface ACHTMLInterstitialCustomEvent : ACInterstitialCustomEvent <ACInterstitialViewControllerDelegate>

@property (nonatomic, assign) id<ACPrivateInterstitialCustomEventDelegate> delegate;

@end
