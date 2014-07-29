//
//  ACInterstitialCustomEventAdapter.m
//  Adcash
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import "ACInterstitialCustomEventAdapter.h"

#import "ACAdConfiguration.h"
#import "ACLogging.h"
#import "ACInstanceProvider.h"
#import "ACInterstitialCustomEvent.h"
#import "ACInterstitialAdController.h"

@interface ACInterstitialCustomEventAdapter ()

@property (nonatomic, retain) ACInterstitialCustomEvent *interstitialCustomEvent;
@property (nonatomic, retain) ACAdConfiguration *configuration;
@property (nonatomic, assign) BOOL hasTrackedImpression;
@property (nonatomic, assign) BOOL hasTrackedClick;

@end

@implementation ACInterstitialCustomEventAdapter
@synthesize hasTrackedImpression = _hasTrackedImpression;
@synthesize hasTrackedClick = _hasTrackedClick;

@synthesize interstitialCustomEvent = _interstitialCustomEvent;

- (void)dealloc
{
    if ([self.interstitialCustomEvent respondsToSelector:@selector(invalidate)]) {
        // Secret API to allow us to detach the custom event from (shared instance) routers synchronously
        // See the chartboost interstitial custom event for an example use case.
        [self.interstitialCustomEvent performSelector:@selector(invalidate)];
    }
    self.interstitialCustomEvent.delegate = nil;
    [[_interstitialCustomEvent retain] autorelease];
    self.interstitialCustomEvent = nil;
    self.configuration = nil;

    [super dealloc];
}

- (void)getAdWithConfiguration:(ACAdConfiguration *)configuration
{
    ACLogInfo(@"Looking for custom event class named %@.", configuration.customEventClass);
    self.configuration = configuration;

    self.interstitialCustomEvent = [[ACInstanceProvider sharedProvider] buildInterstitialCustomEventFromCustomClass:configuration.customEventClass delegate:self];

    if (self.interstitialCustomEvent) {
        [self.interstitialCustomEvent requestInterstitialWithCustomEventInfo:configuration.customEventClassData];
    } else {
        [self.delegate adapter:self didFailToLoadAdWithError:nil];
    }
}

- (void)showInterstitialFromViewController:(UIViewController *)controller
{
    [self.interstitialCustomEvent showInterstitialFromRootViewController:controller];
}

#pragma mark - ACInterstitialCustomEventDelegate

- (NSString *)adUnitId
{
    return [self.delegate interstitialAdController].adUnitId;
}

- (CLLocation *)location
{
    return [self.delegate location];
}

- (id)interstitialDelegate
{
    return [self.delegate interstitialDelegate];
}

- (void)interstitialCustomEvent:(ACInterstitialCustomEvent *)customEvent
                      didLoadAd:(id)ad
{
    [self didStopLoading];
    [self.delegate adapterDidFinishLoadingAd:self];
}

- (void)interstitialCustomEvent:(ACInterstitialCustomEvent *)customEvent
       didFailToLoadAdWithError:(NSError *)error
{
    [self didStopLoading];
    [self.delegate adapter:self didFailToLoadAdWithError:error];
}

- (void)interstitialCustomEventWillAppear:(ACInterstitialCustomEvent *)customEvent
{
    [self.delegate interstitialWillAppearForAdapter:self];
}

- (void)interstitialCustomEventDidAppear:(ACInterstitialCustomEvent *)customEvent
{
    if ([self.interstitialCustomEvent enableAutomaticImpressionAndClickTracking] && !self.hasTrackedImpression) {
        self.hasTrackedImpression = YES;
        [self trackImpression];
    }
    [self.delegate interstitialDidAppearForAdapter:self];
}

- (void)interstitialCustomEventWillDisappear:(ACInterstitialCustomEvent *)customEvent
{
    [self.delegate interstitialWillDisappearForAdapter:self];
}

- (void)interstitialCustomEventDidDisappear:(ACInterstitialCustomEvent *)customEvent
{
    [self.delegate interstitialDidDisappearForAdapter:self];
}

- (void)interstitialCustomEventDidExpire:(ACInterstitialCustomEvent *)customEvent
{
    [self.delegate interstitialDidExpireForAdapter:self];
}

- (void)interstitialCustomEventDidReceiveTapEvent:(ACInterstitialCustomEvent *)customEvent
{
    if ([self.interstitialCustomEvent enableAutomaticImpressionAndClickTracking] && !self.hasTrackedClick) {
        self.hasTrackedClick = YES;
        [self trackClick];
    }
}

- (void)interstitialCustomEventWillLeaveApplication:(ACInterstitialCustomEvent *)customEvent
{
    [self.delegate interstitialWillLeaveApplicationForAdapter:self];
}

@end
