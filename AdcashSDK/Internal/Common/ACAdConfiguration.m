//
//  ACAdConfiguration.m
//  Adcash
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import "ACAdConfiguration.h"

#import "ACConstants.h"
#import "ACLogging.h"
#import "math.h"
#import "NSJSONSerialization+ACAdditions.h"

NSString * const kAdTypeHeaderKey = @"X-Adtype";
NSString * const kClickthroughHeaderKey = @"X-Clickthrough";
NSString * const kCustomSelectorHeaderKey = @"X-Customselector";
NSString * const kCustomEventClassNameHeaderKey = @"X-Custom-Event-Class-Name";
NSString * const kCustomEventClassDataHeaderKey = @"X-Custom-Event-Class-Data";
NSString * const kFailUrlHeaderKey = @"X-Failurl";
NSString * const kHeightHeaderKey = @"X-Height";
NSString * const kImpressionTrackerHeaderKey = @"X-Imptracker";
NSString * const kInterceptLinksHeaderKey = @"X-Interceptlinks";
NSString * const kLaunchpageHeaderKey = @"X-Launchpage";
NSString * const kNativeSDKParametersHeaderKey = @"X-Nativeparams";
NSString * const kNetworkTypeHeaderKey = @"X-Networktype";
NSString * const kRefreshTimeHeaderKey = @"X-Refreshtime";
NSString * const kAdTimeoutHeaderKey = @"X-AdTimeout";
NSString * const kScrollableHeaderKey = @"X-Scrollable";
NSString * const kWidthHeaderKey = @"X-Width";
NSString * const kDspCreativeIdKey = @"X-DspCreativeid";
NSString * const kPrecacheRequiredKey = @"X-PrecacheRequired";

NSString * const kInterstitialAdTypeHeaderKey = @"X-Fulladtype";
NSString * const kOrientationTypeHeaderKey = @"X-Orientation";

NSString * const kAdTypeHtml = @"html";
NSString * const kAdTypeInterstitial = @"interstitial";
NSString * const kAdTypeMraid = @"mraid";
NSString * const kAdTypeClear = @"clear";
NSString * const kAdTypeNative = @"json";

@interface ACAdConfiguration ()

@property (nonatomic, copy) NSString *adResponseHTMLString;

- (ACAdType)adTypeFromHeaders:(NSDictionary *)headers;
- (NSString *)networkTypeFromHeaders:(NSDictionary *)headers;
- (NSTimeInterval)refreshIntervalFromHeaders:(NSDictionary *)headers;
- (NSDictionary *)dictionaryFromHeaders:(NSDictionary *)headers forKey:(NSString *)key;
- (NSURL *)URLFromHeaders:(NSDictionary *)headers forKey:(NSString *)key;
- (Class)setUpCustomEventClassFromHeaders:(NSDictionary *)headers;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation ACAdConfiguration

@synthesize adType = _adType;
@synthesize networkType = _networkType;
@synthesize preferredSize = _preferredSize;
@synthesize clickTrackingURL = _clickTrackingURL;
@synthesize impressionTrackingURL = _impressionTrackingURL;
@synthesize failoverURL = _failoverURL;
@synthesize interceptURLPrefix = _interceptURLPrefix;
@synthesize shouldInterceptLinks = _shouldInterceptLinks;
@synthesize scrollable = _scrollable;
@synthesize refreshInterval = _refreshInterval;
@synthesize adTimeoutInterval = _adTimeoutInterval;
@synthesize adResponseData = _adResponseData;
@synthesize adResponseHTMLString = _adResponseHTMLString;
@synthesize nativeSDKParameters = _nativeSDKParameters;
@synthesize orientationType = _orientationType;
@synthesize customEventClass = _customEventClass;
@synthesize customEventClassData = _customEventClassData;
@synthesize customSelectorName = _customSelectorName;
@synthesize dspCreativeId = _dspCreativeId;
@synthesize precacheRequired = _precacheRequired;
@synthesize creationTimestamp = _creationTimestamp;

- (id)initWithHeaders:(NSDictionary *)headers data:(NSData *)data
{
    self = [super init];
    if (self) {
        self.adResponseData = data;

        self.adType = [self adTypeFromHeaders:headers];

        self.networkType = [self networkTypeFromHeaders:headers];
        self.networkType = self.networkType ? self.networkType : @"";

        self.preferredSize = CGSizeMake([[headers objectForKey:kWidthHeaderKey] floatValue],
                                        [[headers objectForKey:kHeightHeaderKey] floatValue]);

        self.clickTrackingURL = [self URLFromHeaders:headers
                                              forKey:kClickthroughHeaderKey];
        self.impressionTrackingURL = [self URLFromHeaders:headers
                                                   forKey:kImpressionTrackerHeaderKey];
        self.failoverURL = [self URLFromHeaders:headers
                                         forKey:kFailUrlHeaderKey];
        self.interceptURLPrefix = [self URLFromHeaders:headers
                                                forKey:kLaunchpageHeaderKey];

        NSNumber *shouldInterceptLinks = [headers objectForKey:kInterceptLinksHeaderKey];
        self.shouldInterceptLinks = shouldInterceptLinks ? [shouldInterceptLinks boolValue] : YES;
        self.scrollable = [[headers objectForKey:kScrollableHeaderKey] boolValue];
        self.refreshInterval = [self refreshIntervalFromHeaders:headers];
        self.adTimeoutInterval = [self adTimeoutIntervalFromHeaders:headers];


        self.nativeSDKParameters = [self dictionaryFromHeaders:headers
                                                        forKey:kNativeSDKParametersHeaderKey];
        self.customSelectorName = [headers objectForKey:kCustomSelectorHeaderKey];

        self.orientationType = [self orientationTypeFromHeaders:headers];

        self.customEventClass = [self setUpCustomEventClassFromHeaders:headers];

        self.customEventClassData = [self customEventClassDataFromHeaders:headers];

        self.dspCreativeId = [headers objectForKey:kDspCreativeIdKey];

        self.precacheRequired = [[headers objectForKey:kPrecacheRequiredKey] boolValue];

        self.creationTimestamp = [NSDate date];
    }
    return self;
}

- (Class)setUpCustomEventClassFromHeaders:(NSDictionary *)headers
{
    NSString *customEventClassName = [headers objectForKey:kCustomEventClassNameHeaderKey];

    NSMutableDictionary *convertedCustomEvents = [NSMutableDictionary dictionary];
    if (self.adType == ACAdTypeBanner) {
        [convertedCustomEvents setObject:@"ACiAdBannerCustomEvent" forKey:@"iAd"];
        [convertedCustomEvents setObject:@"ACGoogleAdMobBannerCustomEvent" forKey:@"admob_native"];
        [convertedCustomEvents setObject:@"ACMillennialBannerCustomEvent" forKey:@"millennial_native"];
        [convertedCustomEvents setObject:@"ACHTMLBannerCustomEvent" forKey:@"html"];
        [convertedCustomEvents setObject:@"ACMRAIDBannerCustomEvent" forKey:@"mraid"];
    } else if (self.adType == ACAdTypeInterstitial) {
        [convertedCustomEvents setObject:@"ACiAdInterstitialCustomEvent" forKey:@"iAd_full"];
        [convertedCustomEvents setObject:@"ACGoogleAdMobInterstitialCustomEvent" forKey:@"admob_full"];
        [convertedCustomEvents setObject:@"ACMillennialInterstitialCustomEvent" forKey:@"millennial_full"];
        [convertedCustomEvents setObject:@"ACHTMLInterstitialCustomEvent" forKey:@"html"];
        [convertedCustomEvents setObject:@"ACMRAIDInterstitialCustomEvent" forKey:@"mraid"];
    }
    if ([convertedCustomEvents objectForKey:self.networkType]) {
        customEventClassName = [convertedCustomEvents objectForKey:self.networkType];
    }

    Class customEventClass = NSClassFromString(customEventClassName);

    if (customEventClassName && !customEventClass) {
        ACLogWarn(@"Could not find custom event class named %@", customEventClassName);
    }

    return customEventClass;
}



- (NSDictionary *)customEventClassDataFromHeaders:(NSDictionary *)headers
{
    NSDictionary *result = [self dictionaryFromHeaders:headers forKey:kCustomEventClassDataHeaderKey];
    if (!result) {
        result = [self dictionaryFromHeaders:headers forKey:kNativeSDKParametersHeaderKey];
    }
    return result;
}

- (void)dealloc
{
    self.networkType = nil;
    self.clickTrackingURL = nil;
    self.impressionTrackingURL = nil;
    self.failoverURL = nil;
    self.interceptURLPrefix = nil;
    self.adResponseData = nil;
    self.adResponseHTMLString = nil;
    self.nativeSDKParameters = nil;
    self.customSelectorName = nil;
    self.customEventClassData = nil;
    self.dspCreativeId = nil;
    self.creationTimestamp = nil;

    [super dealloc];
}

- (BOOL)hasPreferredSize
{
    return (self.preferredSize.width > 0 && self.preferredSize.height > 0);
}

- (NSString *)adResponseHTMLString
{
    if (!_adResponseHTMLString) {
        self.adResponseHTMLString = [[[NSString alloc] initWithData:self.adResponseData
                                                           encoding:NSUTF8StringEncoding] autorelease];
    }

    return _adResponseHTMLString;
}

- (NSString *)clickDetectionURLPrefix
{
    return self.interceptURLPrefix.absoluteString ? self.interceptURLPrefix.absoluteString : @"";
}

#pragma mark - Private

- (ACAdType)adTypeFromHeaders:(NSDictionary *)headers
{
    NSString *adTypeString = [headers objectForKey:kAdTypeHeaderKey];

    if ([adTypeString isEqualToString:@"interstitial"]) {
        return ACAdTypeInterstitial;
    } else if (adTypeString &&
               [headers objectForKey:kOrientationTypeHeaderKey]) {
        return ACAdTypeInterstitial;
    } else if (adTypeString) {
        return ACAdTypeBanner;
    } else {
        return ACAdTypeUnknown;
    }
}

- (NSString *)networkTypeFromHeaders:(NSDictionary *)headers
{
    NSString *adTypeString = [headers objectForKey:kAdTypeHeaderKey];
    if ([adTypeString isEqualToString:@"interstitial"]) {
        return [headers objectForKey:kInterstitialAdTypeHeaderKey];
    } else {
        return adTypeString;
    }
}

- (NSURL *)URLFromHeaders:(NSDictionary *)headers forKey:(NSString *)key
{
    NSString *URLString = [headers objectForKey:key];
    return URLString ? [NSURL URLWithString:URLString] : nil;
}

- (NSDictionary *)dictionaryFromHeaders:(NSDictionary *)headers forKey:(NSString *)key
{
    NSData *data = [(NSString *)[headers objectForKey:key] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *JSONFromHeaders = nil;
    if (data) {
        JSONFromHeaders = [NSJSONSerialization mp_JSONObjectWithData:data options:NSJSONReadingMutableContainers clearNullObjects:YES error:nil];
    }
    return JSONFromHeaders;
}

- (NSTimeInterval)refreshIntervalFromHeaders:(NSDictionary *)headers
{
    NSString *intervalString = [headers objectForKey:kRefreshTimeHeaderKey];
    NSTimeInterval interval = -1;
    if (intervalString) {
        interval = [intervalString doubleValue];
        if (interval < MINIMUM_REFRESH_INTERVAL) {
            interval = MINIMUM_REFRESH_INTERVAL;
        }
    }
    return interval;
}

- (NSTimeInterval)adTimeoutIntervalFromHeaders:(NSDictionary *)headers
{
    NSString *intervalString = [headers objectForKey:kAdTimeoutHeaderKey];
    NSTimeInterval interval = -1;
    if (intervalString) {
        int parsedInt = -1;
        BOOL isNumber = [[NSScanner scannerWithString:intervalString] scanInt:&parsedInt];
        if (isNumber && parsedInt >= 0) {
            interval = parsedInt;
        }
    }

    return interval;
}

- (ACInterstitialOrientationType)orientationTypeFromHeaders:(NSDictionary *)headers
{
    NSString *orientation = [headers objectForKey:kOrientationTypeHeaderKey];
    if ([orientation isEqualToString:@"p"]) {
        return ACInterstitialOrientationTypePortrait;
    } else if ([orientation isEqualToString:@"l"]) {
        return ACInterstitialOrientationTypeLandscape;
    } else {
        return ACInterstitialOrientationTypeAll;
    }
}

@end