//
//  ACAnalyticsTracker.h
//  Adcash
//
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ACAdConfiguration;

@interface ACAnalyticsTracker : NSObject

+ (ACAnalyticsTracker *)tracker;

- (void)trackImpressionForConfiguration:(ACAdConfiguration *)configuration;
- (void)trackClickForConfiguration:(ACAdConfiguration *)configuration;

@end
