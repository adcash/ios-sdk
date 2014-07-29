//
//  ACNativeAdRequest.m
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import "ACNativeAdRequest.h"

#import "ACAdServerURLBuilder.h"
#import "ACCoreInstanceProvider.h"
#import "ACNativeAdError.h"
#import "ACNativeAd+Internal.h"
#import "ACNativeAdRequestTargeting.h"
#import "ACLogging.h"
#import "ACImageDownloadQueue.h"
#import "ACConstants.h"
#import "ACNativeCustomEventDelegate.h"
#import "ACNativeCustomEvent.h"
#import "ACInstanceProvider.h"
#import "NSJSONSerialization+ACAdditions.h"
#import "ACAdServerCommunicator.h"

#import "ACAdcashNativeCustomEvent.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface ACNativeAdRequest () <ACNativeCustomEventDelegate, ACAdServerCommunicatorDelegate>

@property (nonatomic, copy) NSString *adUnitIdentifier;
@property (nonatomic, retain) NSURL *URL;
@property (nonatomic, retain) ACAdServerCommunicator *communicator;
@property (nonatomic, copy) ACNativeAdRequestHandler completionHandler;
@property (nonatomic, retain) ACNativeCustomEvent *nativeCustomEvent;
@property (nonatomic, retain) ACAdConfiguration *adConfiguration;
@property (nonatomic, assign) BOOL loading;

@end

@implementation ACNativeAdRequest

- (id)initWithAdUnitIdentifier:(NSString *)identifier
{
    self = [super init];
    if (self) {
        _adUnitIdentifier = [identifier copy];
        _communicator = [[[ACCoreInstanceProvider sharedProvider] buildACAdServerCommunicatorWithDelegate:self] retain];
    }
    return self;
}

- (void)dealloc
{
    [_adConfiguration release];
    [_adUnitIdentifier release];
    [_URL release];
    [_communicator cancel];
    [_communicator setDelegate:nil];
    [_communicator release];
    [_completionHandler release];
    [_targeting release];
    [_nativeCustomEvent setDelegate:nil];
    [_nativeCustomEvent release];
    [super dealloc];
}

#pragma mark - Public

+ (ACNativeAdRequest *)requestWithAdUnitIdentifier:(NSString *)identifier
{
    return [[[self alloc] initWithAdUnitIdentifier:identifier] autorelease];
}

- (void)startWithCompletionHandler:(ACNativeAdRequestHandler)handler
{
    if (handler)
    {
        self.URL = [ACAdServerURLBuilder URLWithAdUnitID:self.adUnitIdentifier
                                                keywords:self.targeting.keywords
                                                location:self.targeting.location
                                    versionParameterName:@"nsv"
                                                 version:AC_SDK_VERSION
                                                 testing:NO
                                           desiredAssets:[self.targeting.desiredAssets allObjects]];

        self.completionHandler = handler;

        [self loadAdWithURL:self.URL];
    }
    else
    {
        ACLogWarn(@"Native Ad Request did not start - requires completion handler block.");
    }
}

#pragma mark - Private

- (void)loadAdWithURL:(NSURL *)URL
{
    if (self.loading) {
        ACLogWarn(@"Native ad request is already loading an ad. Wait for previous load to finish.");
        return;
    }

    [self retain];

    ACLogInfo(@"Starting ad request with URL: %@", self.URL);

    self.loading = YES;
    [self.communicator loadURL:URL];
}

- (void)getAdWithConfiguration:(ACAdConfiguration *)configuration
{
    ACLogInfo(@"Looking for custom event class named %@.", configuration.customEventClass);\
    // Adserver doesn't return a customEventClass for Adcash native ads
    if([configuration.networkType isEqualToString:kAdTypeNative] && configuration.customEventClass == nil) {
        configuration.customEventClass = [ACAdcashNativeCustomEvent class];
        NSDictionary *classData = [NSJSONSerialization mp_JSONObjectWithData:configuration.adResponseData options:0 clearNullObjects:YES error:nil];
        configuration.customEventClassData = classData;
    }

    self.nativeCustomEvent = [[ACInstanceProvider sharedProvider] buildNativeCustomEventFromCustomClass:configuration.customEventClass delegate:self];

    if (self.nativeCustomEvent) {
        [self.nativeCustomEvent requestAdWithCustomEventInfo:configuration.customEventClassData];
    } else if ([[self.adConfiguration.failoverURL absoluteString] length]) {
        self.loading = NO;
        [self loadAdWithURL:self.adConfiguration.failoverURL];
        [self release];
    } else {
        [self completeAdRequestWithAdObject:nil error:[NSError errorWithDomain:AdcashNativeAdsSDKDomain code:ACNativeAdErrorInvalidServerResponse userInfo:nil]];
        [self release];
    }
}

- (void)completeAdRequestWithAdObject:(ACNativeAd *)adObject error:(NSError *)error
{
    self.loading = NO;
    if (self.completionHandler) {
        self.completionHandler(self, adObject, error);
        self.completionHandler = nil;
    }
}

#pragma mark - <ACAdServerCommunicatorDelegate>

- (void)communicatorDidReceiveAdConfiguration:(ACAdConfiguration *)configuration
{
    self.adConfiguration = configuration;

    if ([configuration.networkType isEqualToString:kAdTypeClear]) {
        ACLogInfo(@"No inventory available for ad unit: %@", self.adUnitIdentifier);

        [self completeAdRequestWithAdObject:nil error:[NSError errorWithDomain:AdcashNativeAdsSDKDomain code:ACNativeAdErrorNoInventory userInfo:nil]];
        [self release];
    }
    else {
        ACLogInfo(@"Received data from Adcash to construct Native ad.");

        [self getAdWithConfiguration:configuration];
    }
}

- (void)communicatorDidFailWithError:(NSError *)error
{
    ACLogDebug(@"Error: Couldn't retrieve an ad from Adcash. Message: %@", error);

    [self completeAdRequestWithAdObject:nil error:[NSError errorWithDomain:AdcashNativeAdsSDKDomain code:ACNativeAdErrorHTTPError userInfo:nil]];
    [self release];
}

#pragma mark - <ACNativeCustomEventDelegate>

- (void)nativeCustomEvent:(ACNativeCustomEvent *)event didLoadAd:(ACNativeAd *)adObject
{
    // Take the click tracking URL from the header if the ad object doesn't already have one.
    [adObject setEngagementTrackingURL:(adObject.engagementTrackingURL ? : self.adConfiguration.clickTrackingURL)];

    // Add the impression tracker from the header to our set.
    if (self.adConfiguration.impressionTrackingURL) {
        [adObject.impressionTrackers addObject:[self.adConfiguration.impressionTrackingURL absoluteString]];
    }

    // Error if we don't have click tracker or impression trackers.
    if (!adObject.engagementTrackingURL || adObject.impressionTrackers.count < 1) {
        [self completeAdRequestWithAdObject:nil error:[NSError errorWithDomain:AdcashNativeAdsSDKDomain code:ACNativeAdErrorInvalidServerResponse userInfo:nil]];
    } else {
        [self completeAdRequestWithAdObject:adObject error:nil];
    }

    [self release];

}

- (void)nativeCustomEvent:(ACNativeCustomEvent *)event didFailToLoadAdWithError:(NSError *)error
{
    if ([[self.adConfiguration.failoverURL absoluteString] length]) {
        self.loading = NO;
        [self loadAdWithURL:self.adConfiguration.failoverURL];
    } else {
        [self completeAdRequestWithAdObject:nil error:error];
    }

    [self release];
}


@end
