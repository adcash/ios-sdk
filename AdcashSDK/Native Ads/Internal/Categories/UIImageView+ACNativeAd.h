//
//  UIImageView+ACNativeAd.h
//  Copyright (c) 2014 Adcash All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACNativeAd;

@interface UIImageView (ACNativeAd)

- (void)mp_setNativeAd:(ACNativeAd *)adObject;
- (void)mp_removeNativeAd;
- (ACNativeAd *)mp_nativeAd;

@end
