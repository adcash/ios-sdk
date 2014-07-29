//
//  ACAnalyticsTracker.m
//  Adcash
//
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import "ACAnalyticsTracker.h"
#import "ACAdConfiguration.h"
#import "ACCoreInstanceProvider.h"
#import "ACLogging.h"

@interface ACAnalyticsTracker ()

- (NSURLRequest *)requestForURL:(NSURL *)URL;

@end

@implementation ACAnalyticsTracker

+ (ACAnalyticsTracker *)tracker
{
    return [[[ACAnalyticsTracker alloc] init] autorelease];
}

- (void)trackImpressionForConfiguration:(ACAdConfiguration *)configuration
{
    ACLogDebug(@"Tracking impression: %@", configuration.impressionTrackingURL);
    [NSURLConnection connectionWithRequest:[self requestForURL:configuration.impressionTrackingURL]
                                  delegate:nil];
}

- (void)trackClickForConfiguration:(ACAdConfiguration *)configuration
{
    ACLogDebug(@"Tracking click: %@", configuration.clickTrackingURL);
    [NSURLConnection connectionWithRequest:[self requestForURL:configuration.clickTrackingURL]
                                  delegate:nil];
}

- (NSURLRequest *)requestForURL:(NSURL *)URL
{
    NSMutableURLRequest *request = [[ACCoreInstanceProvider sharedProvider] buildConfiguredURLRequestWithURL:URL];
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    return request;
}

@end
