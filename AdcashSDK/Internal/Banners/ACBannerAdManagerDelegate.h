//
//  ACBannerAdManagerDelegate.h
//  Adcash
//
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ACAdView;
@protocol ACAdViewDelegate;

@protocol ACBannerAdManagerDelegate <NSObject>

- (NSString *)adUnitId;
- (ACNativeAdOrientation)allowedNativeAdsOrientation;
- (ACAdView *)banner;
- (id<ACAdViewDelegate>)bannerDelegate;
- (CGSize)containerSize;
- (BOOL)ignoresAutorefresh;
- (NSString *)keywords;
- (CLLocation *)location;
- (BOOL)isTesting;
- (UIViewController *)viewControllerForPresentingModalView;

- (void)invalidateContentView;

- (void)managerDidLoadAd:(UIView *)ad;
- (void)managerDidFailToLoadAd;
- (void)userActionWillBegin;
- (void)userActionDidFinish;
- (void)userWillLeaveApplication;

@end
