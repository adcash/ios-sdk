//
//  ACInterstitialViewController.h
//  Adcash
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACGlobal.h"

@class CLLocation;

@protocol ACInterstitialViewControllerDelegate;

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface ACInterstitialViewController : UIViewController

@property (nonatomic, assign) ACInterstitialCloseButtonStyle closeButtonStyle;
@property (nonatomic, assign) ACInterstitialOrientationType orientationType;
@property (nonatomic, retain) UIButton *closeButton;
@property (nonatomic, assign) id<ACInterstitialViewControllerDelegate> delegate;

- (void)presentInterstitialFromViewController:(UIViewController *)controller;
- (void)dismissInterstitialAnimated:(BOOL)animated;
- (BOOL)shouldDisplayCloseButton;
- (void)willPresentInterstitial;
- (void)didPresentInterstitial;
- (void)willDismissInterstitial;
- (void)didDismissInterstitial;
- (void)layoutCloseButton;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@protocol ACInterstitialViewControllerDelegate <NSObject>

- (NSString *)adUnitId;
- (CLLocation *)location;
- (void)interstitialDidLoadAd:(ACInterstitialViewController *)interstitial;
- (void)interstitialDidFailToLoadAd:(ACInterstitialViewController *)interstitial;
- (void)interstitialWillAppear:(ACInterstitialViewController *)interstitial;
- (void)interstitialDidAppear:(ACInterstitialViewController *)interstitial;
- (void)interstitialWillDisappear:(ACInterstitialViewController *)interstitial;
- (void)interstitialDidDisappear:(ACInterstitialViewController *)interstitial;
- (void)interstitialWillLeaveApplication:(ACInterstitialViewController *)interstitial;

@end
