//
//  ACNativeAdRequestTargeting.m
//  Copyright (c) 2014 Adcash. All rights reserved.
//

#import "ACNativeAdRequestTargeting.h"
#import "ACNativeAdConstants.h"

@implementation ACNativeAdRequestTargeting

+ (ACNativeAdRequestTargeting *)targeting
{
    return [[[ACNativeAdRequestTargeting alloc] init] autorelease];
}

- (void)setDesiredAssets:(NSSet *)desiredAssets
{
    if (_desiredAssets != desiredAssets) {
        [_desiredAssets release];

        NSMutableSet *allowedAdAssets = [NSMutableSet setWithObjects:kAdTitleKey,
                                         kAdTextKey,
                                         kAdIconImageKey,
                                         kAdMainImageKey,
                                         kAdCTATextKey,
                                         kAdStarRatingKey,
                                         nil];
        [allowedAdAssets intersectSet:desiredAssets];
        _desiredAssets = [allowedAdAssets retain];
    }
}

- (void)dealloc
{
    [_keywords release];
    [_location release];
    [_desiredAssets release];
    [super dealloc];
}

@end
