//
//  ACMRAIDBannerCustomEvent.h
//  Adcash
//
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import "ACBannerCustomEvent.h"
#import "MRAdView.h"
#import "ACPrivateBannerCustomEventDelegate.h"

@interface ACMRAIDBannerCustomEvent : ACBannerCustomEvent <MRAdViewDelegate>

@property (nonatomic, assign) id<ACPrivateBannerCustomEventDelegate> delegate;

@end
