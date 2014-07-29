//
//  ACBannerCustomEvent.m
//  Adcash
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import "ACBannerCustomEvent.h"

@implementation ACBannerCustomEvent

@synthesize delegate;

- (void)requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info
{
    // The default implementation of this method does nothing. Subclasses must override this method
    // and implement code to load a banner here.
}

- (void)didDisplayAd
{
    // The default implementation of this method does nothing. Subclasses may override this method
    // to be notified when the ad is actually displayed on screen.
}

- (BOOL)enableAutomaticImpressionAndClickTracking
{
    // Subclasses may override this method to return NO to perform impression and click tracking
    // manually.
    return YES;
}

- (void)rotateToOrientation:(UIInterfaceOrientation)newOrientation
{
    // The default implementation of this method does nothing. Subclasses may override this method
    // to be notified when the parent ACAdView receives -rotateToOrientation: calls.
}

@end
