//
//  ACBannerCustomEventAdapter.h
//  Adcash
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import "ACBaseBannerAdapter.h"

#import "ACPrivateBannerCustomEventDelegate.h"

@class ACBannerCustomEvent;

@interface ACBannerCustomEventAdapter : ACBaseBannerAdapter <ACPrivateBannerCustomEventDelegate>

@end
