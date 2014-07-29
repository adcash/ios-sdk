//
//  ACPrivateBannerCustomEventDelegate.h
//  Adcash
//
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACBannerCustomEventDelegate.h"

@class ACAdConfiguration;

@protocol ACPrivateBannerCustomEventDelegate <ACBannerCustomEventDelegate>

- (NSString *)adUnitId;
- (ACAdConfiguration *)configuration;
- (id)bannerDelegate;

@end
