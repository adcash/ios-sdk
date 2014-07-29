//
//  ACLegacyBannerCustomEventAdapter.m
//  Adcash
//
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import "ACLegacyBannerCustomEventAdapter.h"
#import "ACAdConfiguration.h"
#import "ACLogging.h"

@implementation ACLegacyBannerCustomEventAdapter

- (void)getAdWithConfiguration:(ACAdConfiguration *)configuration containerSize:(CGSize)size
{
    ACLogInfo(@"Looking for custom event selector named %@.", configuration.customSelectorName);

    SEL customEventSelector = NSSelectorFromString(configuration.customSelectorName);
    if ([self.delegate.bannerDelegate respondsToSelector:customEventSelector]) {
        [self.delegate.bannerDelegate performSelector:customEventSelector];
        return;
    }

    NSString *oneArgumentSelectorName = [configuration.customSelectorName
                                         stringByAppendingString:@":"];

    ACLogInfo(@"Looking for custom event selector named %@.", oneArgumentSelectorName);

    SEL customEventOneArgumentSelector = NSSelectorFromString(oneArgumentSelectorName);
    if ([self.delegate.bannerDelegate respondsToSelector:customEventOneArgumentSelector]) {
        [self.delegate.bannerDelegate performSelector:customEventOneArgumentSelector
                                           withObject:self.delegate.banner];
        return;
    }

    [self.delegate adapter:self didFailToLoadAdWithError:nil];
}

- (void)startTimeoutTimer
{
    // Override to do nothing as we don't want to time out these legacy custom events.
}

@end
