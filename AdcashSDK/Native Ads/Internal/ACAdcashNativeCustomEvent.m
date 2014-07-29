//
//  ACAdcashNativeCustomEvent.m
//  AdcashSDK
//
//  Copyright (c) 2014 Adcash. All rights reserved.
//

#import "ACAdcashNativeCustomEvent.h"
#import "ACAdcashNativeAdAdapter.h"
#import "ACNativeAd+Internal.h"
#import "ACNativeAdError.h"
#import "ACLogging.h"

@implementation ACAdcashNativeCustomEvent

- (void)requestAdWithCustomEventInfo:(NSDictionary *)info
{
    ACAdcashNativeAdAdapter *adAdapter = [[ACAdcashNativeAdAdapter alloc] initWithAdProperties:[[info mutableCopy] autorelease]];

    if (adAdapter.properties) {
        ACNativeAd *interfaceAd = [[[ACNativeAd alloc] initWithAdAdapter:adAdapter] autorelease];
        [interfaceAd.impressionTrackers addObjectsFromArray:adAdapter.impressionTrackers];

        // Get the image urls so we can download them prior to returning the ad.
        NSMutableArray *imageURLs = [NSMutableArray array];
        for (NSString *key in [info allKeys]) {
            if ([[key lowercaseString] hasSuffix:@"image"] && [[info objectForKey:key] isKindOfClass:[NSString class]]) {
                [imageURLs addObject:[NSURL URLWithString:[info objectForKey:key]]];
            }
        }
        [super precacheImagesWithURLs:imageURLs completionBlock:^(NSArray *errors) {
            if (errors) {
                ACLogDebug(@"%@", errors);
                ACLogInfo(@"Error: data received was invalid.");
                [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:[NSError errorWithDomain:AdcashNativeAdsSDKDomain code:ACNativeAdErrorInvalidServerResponse userInfo:nil]];
            } else {
                [self.delegate nativeCustomEvent:self didLoadAd:interfaceAd];
            }
        }];
    } else {
        [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:[NSError errorWithDomain:AdcashNativeAdsSDKDomain code:ACNativeAdErrorInvalidServerResponse userInfo:nil]];
    }

    [adAdapter release];
}

@end
