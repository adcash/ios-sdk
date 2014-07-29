//
//  ACNativeAd+Internal.h
//  Copyright (c) 2014 Adcash. All rights reserved.
//

#import "ACNativeAd.h"

@interface ACNativeAd (Internal)

- (NSTimeInterval)requiredSecondsForImpression;
- (void)willAttachToView:(UIView *)view;
- (void)setVisible:(BOOL)visible;
- (NSMutableSet *)impressionTrackers;
- (NSURL *)engagementTrackingURL;

- (void)setEngagementTrackingURL:(NSURL *)engagementTrackingURL;

@end
