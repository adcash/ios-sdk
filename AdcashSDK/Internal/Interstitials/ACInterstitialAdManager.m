//
//  ACInterstitialAdManager.m
//  Adcash
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import <objc/runtime.h>

#import "ACInterstitialAdManager.h"

#import "ACAdServerURLBuilder.h"
#import "ACInterstitialAdController.h"
#import "ACInterstitialCustomEventAdapter.h"
#import "ACInstanceProvider.h"
#import "ACCoreInstanceProvider.h"
#import "ACInterstitialAdManagerDelegate.h"
#import "ACLogging.h"

@interface ACInterstitialAdManager ()

@property (nonatomic, assign) BOOL loading;
@property (nonatomic, assign, readwrite) BOOL ready;
@property (nonatomic, retain) ACBaseInterstitialAdapter *adapter;
@property (nonatomic, retain) ACAdServerCommunicator *communicator;
@property (nonatomic, retain) ACAdConfiguration *configuration;

- (void)setUpAdapterWithConfiguration:(ACAdConfiguration *)configuration;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation ACInterstitialAdManager

@synthesize loading = _loading;
@synthesize ready = _ready;
@synthesize delegate = _delegate;
@synthesize communicator = _communicator;
@synthesize adapter = _adapter;
@synthesize configuration = _configuration;

- (id)initWithDelegate:(id<ACInterstitialAdManagerDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.communicator = [[ACCoreInstanceProvider sharedProvider] buildACAdServerCommunicatorWithDelegate:self];
        self.delegate = delegate;
    }
    return self;
}

- (void)dealloc
{
    [self.communicator cancel];
    [self.communicator setDelegate:nil];
    self.communicator = nil;

    self.adapter = nil;

    self.configuration = nil;

    [super dealloc];
}

- (void)setAdapter:(ACBaseInterstitialAdapter *)adapter
{
    if (self.adapter != adapter) {
        [self.adapter unregisterDelegate];
        [_adapter release];
        _adapter = [adapter retain];
    }
}

#pragma mark - Public

- (void)loadAdWithURL:(NSURL *)URL
{
    if (self.loading) {
        ACLogWarn(@"Interstitial controller is already loading an ad. "
                  @"Wait for previous load to finish.");
        return;
    }

    ACLogInfo(@"Interstitial controller is loading ad with Adcash server URL: %@", URL);

    self.loading = YES;
    [self.communicator loadURL:URL];
}


- (void)loadInterstitialWithAdUnitID:(NSString *)ID keywords:(NSString *)keywords location:(CLLocation *)location testing:(BOOL)testing
{
    if (self.ready) {
        [self.delegate managerDidLoadInterstitial:self];
    } else {
        [self loadAdWithURL:[ACAdServerURLBuilder URLWithAdUnitID:ID
                                                         keywords:keywords
                                                         location:location
                                                          testing:testing]];
    }
}

- (void)presentInterstitialFromViewController:(UIViewController *)controller
{
    if (self.ready) {
        [self.adapter showInterstitialFromViewController:controller];
    }
}

- (CLLocation *)location
{
    return [self.delegate location];
}

- (ACInterstitialAdController *)interstitialAdController
{
    return [self.delegate interstitialAdController];
}

- (id)interstitialDelegate
{
    return [self.delegate interstitialDelegate];
}

#pragma mark - ACAdServerCommunicatorDelegate

- (void)communicatorDidReceiveAdConfiguration:(ACAdConfiguration *)configuration
{
    self.configuration = configuration;

    ACLogInfo(@"Interstitial ad view is fetching ad network type: %@", self.configuration.networkType);

    if ([self.configuration.networkType isEqualToString:@"clear"]) {
        ACLogInfo(@"Ad server response indicated no ad available.");
        self.loading = NO;
        [self.delegate manager:self didFailToLoadInterstitialWithError:nil];
        return;
    }

    if (self.configuration.adType != ACAdTypeInterstitial) {
        ACLogWarn(@"Could not load ad: interstitial object received a non-interstitial ad unit ID.");
        self.loading = NO;
        [self.delegate manager:self didFailToLoadInterstitialWithError:nil];
        return;
    }

    [self setUpAdapterWithConfiguration:self.configuration];
}

- (void)communicatorDidFailWithError:(NSError *)error
{
    self.ready = NO;
    self.loading = NO;

    [self.delegate manager:self didFailToLoadInterstitialWithError:error];
}

- (void)setUpAdapterWithConfiguration:(ACAdConfiguration *)configuration;
{
    ACBaseInterstitialAdapter *adapter = [[ACInstanceProvider sharedProvider] buildInterstitialAdapterForConfiguration:configuration
                                                                                                              delegate:self];
    if (!adapter) {
        [self adapter:nil didFailToLoadAdWithError:nil];
        return;
    }

    self.adapter = adapter;
    [self.adapter _getAdWithConfiguration:configuration];
}

#pragma mark - ACInterstitialAdapterDelegate

- (void)adapterDidFinishLoadingAd:(ACBaseInterstitialAdapter *)adapter
{
    self.ready = YES;
    self.loading = NO;
    [self.delegate managerDidLoadInterstitial:self];
}

- (void)adapter:(ACBaseInterstitialAdapter *)adapter didFailToLoadAdWithError:(NSError *)error
{
    self.ready = NO;
    self.loading = NO;
    [self loadAdWithURL:self.configuration.failoverURL];
}

- (void)interstitialWillAppearForAdapter:(ACBaseInterstitialAdapter *)adapter
{
    [self.delegate managerWillPresentInterstitial:self];
}

- (void)interstitialDidAppearForAdapter:(ACBaseInterstitialAdapter *)adapter
{
    [self.delegate managerDidPresentInterstitial:self];
}

- (void)interstitialWillDisappearForAdapter:(ACBaseInterstitialAdapter *)adapter
{
    [self.delegate managerWillDismissInterstitial:self];
}

- (void)interstitialDidDisappearForAdapter:(ACBaseInterstitialAdapter *)adapter
{
    self.ready = NO;
    [self.delegate managerDidDismissInterstitial:self];
}

- (void)interstitialDidExpireForAdapter:(ACBaseInterstitialAdapter *)adapter
{
    self.ready = NO;
    [self.delegate managerDidExpireInterstitial:self];
}

- (void)interstitialWillLeaveApplicationForAdapter:(ACBaseInterstitialAdapter *)adapter
{
    // TODO: Signal to delegate.
}

#pragma mark - Legacy Custom Events

- (void)customEventDidLoadAd
{
    // XXX: The deprecated custom event behavior is to report an impression as soon as an ad loads,
    // rather than when the ad is actually displayed. Because of this, you may see impression-
    // reporting discrepancies between Adcash and your custom ad networks.
    if ([self.adapter respondsToSelector:@selector(customEventDidLoadAd)]) {
        self.loading = NO;
        [self.adapter performSelector:@selector(customEventDidLoadAd)];
    }
}

- (void)customEventDidFailToLoadAd
{
    if ([self.adapter respondsToSelector:@selector(customEventDidFailToLoadAd)]) {
        self.loading = NO;
        [self.adapter performSelector:@selector(customEventDidFailToLoadAd)];
    }
}

- (void)customEventActionWillBegin
{
    if ([self.adapter respondsToSelector:@selector(customEventActionWillBegin)]) {
        [self.adapter performSelector:@selector(customEventActionWillBegin)];
    }
}

@end
