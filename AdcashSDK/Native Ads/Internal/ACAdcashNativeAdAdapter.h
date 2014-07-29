//
//  ACAdcashNativeAdAdapter.h
//
//  Copyright (c) 2014 Adcash. All rights reserved.
//

#import "ACNativeAdAdapter.h"

@interface ACAdcashNativeAdAdapter : NSObject <ACNativeAdAdapter>

@property (nonatomic, retain) NSArray *impressionTrackers;
@property (nonatomic, retain) NSURL *engagementTrackingURL;

- (instancetype)initWithAdProperties:(NSMutableDictionary *)properties;

@end
