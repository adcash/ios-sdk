//
//  ACInterstitialAdController.m
//  Adcash
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import "ACInterstitialAdController.h"

#import "ACLogging.h"
#import "ACInstanceProvider.h"
#import "ACInterstitialAdManager.h"
#import "ACInterstitialAdManagerDelegate.h"

@interface ACInterstitialAdController () <ACInterstitialAdManagerDelegate>

@property (nonatomic, retain) ACInterstitialAdManager *manager;

+ (NSMutableArray *)sharedInterstitials;
- (id)initWithAdUnitId:(NSString *)adUnitId;

@end

@implementation ACInterstitialAdController

@synthesize manager = _manager;
@synthesize delegate = _delegate;
@synthesize adUnitId = _adUnitId;
@synthesize keywords = _keywords;
@synthesize location = _location;
@synthesize testing = _testing;

- (id)initWithAdUnitId:(NSString *)adUnitId
{
    if (self = [super init]) {
        self.manager = [[ACInstanceProvider sharedProvider] buildACInterstitialAdManagerWithDelegate:self];
        self.adUnitId = adUnitId;
    }
    return self;
}

- (void)dealloc
{
    self.delegate = nil;

    [self.manager setDelegate:nil];
    self.manager = nil;

    self.adUnitId = nil;
    self.keywords = nil;
    self.location = nil;

    [super dealloc];
}

#pragma mark - Public

+ (ACInterstitialAdController *)interstitialAdControllerForAdUnitId:(NSString *)adUnitId
{
    NSMutableArray *interstitials = [[self class] sharedInterstitials];

    @synchronized(self) {
        // Find the correct ad controller based on the ad unit ID.
        ACInterstitialAdController *interstitial = nil;
        for (ACInterstitialAdController *currentInterstitial in interstitials) {
            if ([currentInterstitial.adUnitId isEqualToString:adUnitId]) {
                interstitial = currentInterstitial;
                break;
            }
        }

        // Create a new ad controller for this ad unit ID if one doesn't already exist.
        if (!interstitial) {
            interstitial = [[[[self class] alloc] initWithAdUnitId:adUnitId] autorelease];
            [interstitials addObject:interstitial];
        }

        return interstitial;
    }
}

- (BOOL)ready
{
    return self.manager.ready;
}

- (void)loadAd
{
    [self.manager loadInterstitialWithAdUnitID:self.adUnitId
                                      keywords:self.keywords
                                      location:self.location
                                       testing:self.testing];
}

- (void)showFromViewController:(UIViewController *)controller
{
    if (!controller) {
        ACLogWarn(@"The interstitial could not be shown: "
                  @"a nil view controller was passed to -showFromViewController:.");
        return;
    }
    
    if (![controller.view.window isKeyWindow]) {
        ACLogWarn(@"Attempted to present an interstitial ad in non-key window. The ad may not render properly");
    }

    [self.manager presentInterstitialFromViewController:controller];
}

#pragma mark - Internal

+ (NSMutableArray *)sharedInterstitials
{
    static NSMutableArray *sharedInterstitials;

    @synchronized(self) {
        if (!sharedInterstitials) {
            sharedInterstitials = [[NSMutableArray array] retain];
        }
    }

    return sharedInterstitials;
}

#pragma mark - ACInterstitialAdManagerDelegate

- (ACInterstitialAdController *)interstitialAdController
{
    return self;
}

- (id)interstitialDelegate
{
    return self.delegate;
}

- (void)managerDidLoadInterstitial:(ACInterstitialAdManager *)manager
{
    if ([self.delegate respondsToSelector:@selector(interstitialDidLoadAd:)]) {
        [self.delegate interstitialDidLoadAd:self];
    }
}

- (void)manager:(ACInterstitialAdManager *)manager
        didFailToLoadInterstitialWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(interstitialDidFailToLoadAd:)]) {
        [self.delegate interstitialDidFailToLoadAd:self];
    }
}

- (void)managerWillPresentInterstitial:(ACInterstitialAdManager *)manager
{
    if ([self.delegate respondsToSelector:@selector(interstitialWillAppear:)]) {
        [self.delegate interstitialWillAppear:self];
    }
}

- (void)managerDidPresentInterstitial:(ACInterstitialAdManager *)manager
{
    if ([self.delegate respondsToSelector:@selector(interstitialDidAppear:)]) {
        [self.delegate interstitialDidAppear:self];
    }
}

- (void)managerWillDismissInterstitial:(ACInterstitialAdManager *)manager
{
    if ([self.delegate respondsToSelector:@selector(interstitialWillDisappear:)]) {
        [self.delegate interstitialWillDisappear:self];
    }
}

- (void)managerDidDismissInterstitial:(ACInterstitialAdManager *)manager
{
    if ([self.delegate respondsToSelector:@selector(interstitialDidDisappear:)]) {
        [self.delegate interstitialDidDisappear:self];
    }
}

- (void)managerDidExpireInterstitial:(ACInterstitialAdManager *)manager
{
    if ([self.delegate respondsToSelector:@selector(interstitialDidExpire:)]) {
        [self.delegate interstitialDidExpire:self];
    }
}

#pragma mark - Deprecated

+ (NSMutableArray *)sharedInterstitialAdControllers
{
    return [[self class] sharedInterstitials];
}

+ (void)removeSharedInterstitialAdController:(ACInterstitialAdController *)controller
{
    [[[self class] sharedInterstitials] removeObject:controller];
}

- (void)customEventDidLoadAd
{
    [self.manager customEventDidLoadAd];
}

- (void)customEventDidFailToLoadAd
{
    [self.manager customEventDidFailToLoadAd];
}

- (void)customEventActionWillBegin
{
    [self.manager customEventActionWillBegin];
}

@end
