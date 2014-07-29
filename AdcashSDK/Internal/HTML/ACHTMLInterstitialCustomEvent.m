//
//  ACHTMLInterstitialCustomEvent.m
//  Adcash
//
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import "ACHTMLInterstitialCustomEvent.h"
#import "ACLogging.h"
#import "ACAdConfiguration.h"
#import "ACInstanceProvider.h"

@interface ACHTMLInterstitialCustomEvent ()

@property (nonatomic, retain) ACHTMLInterstitialViewController *interstitial;

@end

@implementation ACHTMLInterstitialCustomEvent

@synthesize interstitial = _interstitial;

- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info
{
    ACLogInfo(@"Loading Adcash HTML interstitial");
    ACAdConfiguration *configuration = [self.delegate configuration];
    ACLogTrace(@"Loading HTML interstitial with source: %@", [configuration adResponseHTMLString]);

    self.interstitial = [[ACInstanceProvider sharedProvider] buildACHTMLInterstitialViewControllerWithDelegate:self
                                                                                               orientationType:configuration.orientationType
                                                                                          customMethodDelegate:[self.delegate interstitialDelegate]];
    [self.interstitial loadConfiguration:configuration];
}

- (void)dealloc
{
    [self.interstitial setDelegate:nil];
    [self.interstitial setCustomMethodDelegate:nil];
    self.interstitial = nil;
    [super dealloc];
}

- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController
{
    [self.interstitial presentInterstitialFromViewController:rootViewController];
}

#pragma mark - ACInterstitialViewControllerDelegate

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
    ACLogInfo(@"Adcash HTML interstitial did load");
    [self.delegate interstitialCustomEvent:self didLoadAd:self.interstitial];
}

- (void)interstitialDidFailToLoadAd:(ACInterstitialViewController *)interstitial
{
    ACLogInfo(@"Adcash HTML interstitial did fail");
    [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
}

- (void)interstitialWillAppear:(ACInterstitialViewController *)interstitial
{
    ACLogInfo(@"Adcash HTML interstitial will appear");
    [self.delegate interstitialCustomEventWillAppear:self];
}

- (void)interstitialDidAppear:(ACInterstitialViewController *)interstitial
{
    ACLogInfo(@"Adcash HTML interstitial did appear");
    [self.delegate interstitialCustomEventDidAppear:self];
}

- (void)interstitialWillDisappear:(ACInterstitialViewController *)interstitial
{
    ACLogInfo(@"Adcash HTML interstitial will disappear");
    [self.delegate interstitialCustomEventWillDisappear:self];
}

- (void)interstitialDidDisappear:(ACInterstitialViewController *)interstitial
{
    ACLogInfo(@"Adcash HTML interstitial did disappear");
    [self.delegate interstitialCustomEventDidDisappear:self];
}

- (void)interstitialWillLeaveApplication:(ACInterstitialViewController *)interstitial
{
    ACLogInfo(@"Adcash HTML interstitial will leave application");
    [self.delegate interstitialCustomEventWillLeaveApplication:self];
}

@end
