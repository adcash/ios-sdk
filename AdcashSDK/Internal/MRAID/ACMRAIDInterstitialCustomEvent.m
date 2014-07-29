//
//  ACMRAIDInterstitialCustomEvent.m
//  Adcash
//
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import "ACMRAIDInterstitialCustomEvent.h"
#import "ACInstanceProvider.h"
#import "ACLogging.h"

@interface ACMRAIDInterstitialCustomEvent ()

@property (nonatomic, retain) ACMRAIDInterstitialViewController *interstitial;

@end

@implementation ACMRAIDInterstitialCustomEvent

@synthesize interstitial = _interstitial;

- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info
{
    ACLogInfo(@"Loading Adcash MRAID interstitial");
    self.interstitial = [[ACInstanceProvider sharedProvider] buildACMRAIDInterstitialViewControllerWithDelegate:self
                                                                                                  configuration:[self.delegate configuration]];
    [self.interstitial setCloseButtonStyle:ACInterstitialCloseButtonStyleAdControlled];
    [self.interstitial startLoading];
}

- (void)dealloc
{
    self.interstitial.delegate = nil;
    self.interstitial = nil;

    [super dealloc];
}

- (void)showInterstitialFromRootViewController:(UIViewController *)controller
{
    [self.interstitial presentInterstitialFromViewController:controller];
}

#pragma mark - ACMRAIDInterstitialViewControllerDelegate

- (CLLocation *)location
{
    return [self.delegate location];
}

- (NSString *)adUnitId
{
    return [self.delegate adUnitId];
}

- (void)interstitialDidLoadAd:(ACInterstitialViewController *)interstitial
{
    ACLogInfo(@"Adcash MRAID interstitial did load");
    [self.delegate interstitialCustomEvent:self didLoadAd:self.interstitial];
}

- (void)interstitialDidFailToLoadAd:(ACInterstitialViewController *)interstitial
{
    ACLogInfo(@"Adcash MRAID interstitial did fail");
    [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
}

- (void)interstitialWillAppear:(ACInterstitialViewController *)interstitial
{
    ACLogInfo(@"Adcash MRAID interstitial will appear");
    [self.delegate interstitialCustomEventWillAppear:self];
}

- (void)interstitialDidAppear:(ACInterstitialViewController *)interstitial
{
    ACLogInfo(@"Adcash MRAID interstitial did appear");
    [self.delegate interstitialCustomEventDidAppear:self];
}

- (void)interstitialWillDisappear:(ACInterstitialViewController *)interstitial
{
    ACLogInfo(@"Adcash MRAID interstitial will disappear");
    [self.delegate interstitialCustomEventWillDisappear:self];
}

- (void)interstitialDidDisappear:(ACInterstitialViewController *)interstitial
{
    ACLogInfo(@"Adcash MRAID interstitial did disappear");
    [self.delegate interstitialCustomEventDidDisappear:self];
}

- (void)interstitialWillLeaveApplication:(ACInterstitialViewController *)interstitial
{
    ACLogInfo(@"Adcash MRAID interstitial will leave application");
    [self.delegate interstitialCustomEventWillLeaveApplication:self];
}

@end
