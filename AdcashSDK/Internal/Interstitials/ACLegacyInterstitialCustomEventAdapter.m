//
//  ACLegacyInterstitialCustomEventAdapter.m
//  Adcash
//
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import "ACLegacyInterstitialCustomEventAdapter.h"
#import "ACAdConfiguration.h"
#import "ACLogging.h"

@interface ACLegacyInterstitialCustomEventAdapter ()

@property (nonatomic, assign) BOOL hasTrackedImpression;
@property (nonatomic, assign) BOOL hasTrackedClick;

@end

@implementation ACLegacyInterstitialCustomEventAdapter

@synthesize hasTrackedImpression = _hasTrackedImpression;
@synthesize hasTrackedClick = _hasTrackedClick;

- (void)getAdWithConfiguration:(ACAdConfiguration *)configuration
{
    ACLogInfo(@"Looking for custom event selector named %@.", configuration.customSelectorName);

    SEL customEventSelector = NSSelectorFromString(configuration.customSelectorName);
    if ([self.delegate.interstitialDelegate respondsToSelector:customEventSelector]) {
        [self.delegate.interstitialDelegate performSelector:customEventSelector];
        return;
    }

    NSString *oneArgumentSelectorName = [configuration.customSelectorName
                                         stringByAppendingString:@":"];

    ACLogInfo(@"Looking for custom event selector named %@.", oneArgumentSelectorName);

    SEL customEventOneArgumentSelector = NSSelectorFromString(oneArgumentSelectorName);
    if ([self.delegate.interstitialDelegate respondsToSelector:customEventOneArgumentSelector]) {
        [self.delegate.interstitialDelegate performSelector:customEventOneArgumentSelector
                                                 withObject:self.delegate.interstitialAdController];
        return;
    }

    [self.delegate adapter:self didFailToLoadAdWithError:nil];
}

- (void)startTimeoutTimer
{
    // Override to do nothing as we don't want to time out these legacy custom events.
}

- (void)customEventDidLoadAd
{
    if (!self.hasTrackedImpression) {
        self.hasTrackedImpression = YES;
        [self trackImpression];
    }
}

- (void)customEventDidFailToLoadAd
{
    [self.delegate adapter:self didFailToLoadAdWithError:nil];
}

- (void)customEventActionWillBegin
{
    if (!self.hasTrackedClick) {
        self.hasTrackedClick = YES;
        [self trackClick];
    }
}

@end
