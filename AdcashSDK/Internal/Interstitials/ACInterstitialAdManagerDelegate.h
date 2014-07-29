//
//  ACInterstitialAdManagerDelegate.h
//  Adcash
//
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ACInterstitialAdManager;
@class ACInterstitialAdController;
@class CLLocation;

@protocol ACInterstitialAdManagerDelegate <NSObject>

- (ACInterstitialAdController *)interstitialAdController;
- (CLLocation *)location;
- (id)interstitialDelegate;
- (void)managerDidLoadInterstitial:(ACInterstitialAdManager *)manager;
- (void)manager:(ACInterstitialAdManager *)manager
didFailToLoadInterstitialWithError:(NSError *)error;
- (void)managerWillPresentInterstitial:(ACInterstitialAdManager *)manager;
- (void)managerDidPresentInterstitial:(ACInterstitialAdManager *)manager;
- (void)managerWillDismissInterstitial:(ACInterstitialAdManager *)manager;
- (void)managerDidDismissInterstitial:(ACInterstitialAdManager *)manager;
- (void)managerDidExpireInterstitial:(ACInterstitialAdManager *)manager;

@end
