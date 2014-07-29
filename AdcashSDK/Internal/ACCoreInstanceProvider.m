//
//  ACCoreInstanceProvider.m
//  Adcash
//
//  Copyright (c) 2014 Adcash. All rights reserved.
//

#import "ACCoreInstanceProvider.h"

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

#import "ACAdServerCommunicator.h"
#import "ACURLResolver.h"
#import "ACAdDestinationDisplayAgent.h"
#import "ACReachability.h"
#import "ACTimer.h"
#import "ACAnalyticsTracker.h"


#define ADCASH_CARRIER_INFO_DEFAULTS_KEY @"com.adcash.carrierinfo"


typedef enum
{
    ACTwitterDeepLinkNotChecked,
    ACTwitterDeepLinkEnabled,
    ACTwitterDeepLinkDisabled
} ACTwitterDeepLink;

@interface ACCoreInstanceProvider ()

@property (nonatomic, copy) NSString *userAgent;
@property (nonatomic, retain) NSMutableDictionary *singletons;
@property (nonatomic, retain) NSMutableDictionary *carrierInfo;
@property (nonatomic, assign) ACTwitterDeepLink twitterDeepLinkStatus;

@end

@implementation ACCoreInstanceProvider

@synthesize userAgent = _userAgent;
@synthesize singletons = _singletons;
@synthesize carrierInfo = _carrierInfo;
@synthesize twitterDeepLinkStatus = _twitterDeepLinkStatus;

static ACCoreInstanceProvider *sharedProvider = nil;

+ (instancetype)sharedProvider
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedProvider = [[self alloc] init];
    });
    
    return sharedProvider;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.singletons = [NSMutableDictionary dictionary];
        
        [self initializeCarrierInfo];
    }
    return self;
}

- (void)dealloc
{
    self.singletons = nil;
    self.carrierInfo = nil;
    [super dealloc];
}

- (id)singletonForClass:(Class)klass provider:(ACSingletonProviderBlock)provider
{
    id singleton = [self.singletons objectForKey:klass];
    if (!singleton) {
        singleton = provider();
        [self.singletons setObject:singleton forKey:(id<NSCopying>)klass];
    }
    return singleton;
}

#pragma mark - Initializing Carrier Info

- (void)initializeCarrierInfo
{
    self.carrierInfo = [NSMutableDictionary dictionary];
    
    // check if we have a saved copy
    NSDictionary *saved = [[NSUserDefaults standardUserDefaults] dictionaryForKey:ADCASH_CARRIER_INFO_DEFAULTS_KEY];
    if(saved != nil) {
        [self.carrierInfo addEntriesFromDictionary:saved];
    }
    
    // now asynchronously load a fresh copy
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CTTelephonyNetworkInfo *networkInfo = [[[CTTelephonyNetworkInfo alloc] init] autorelease];
        [self performSelectorOnMainThread:@selector(updateCarrierInfoForCTCarrier:) withObject:networkInfo.subscriberCellularProvider waitUntilDone:NO];
    });
}

- (void)updateCarrierInfoForCTCarrier:(CTCarrier *)ctCarrier
{
    // use setValue instead of setObject here because ctCarrier could be nil, and any of its properties could be nil
    [self.carrierInfo setValue:ctCarrier.carrierName forKey:@"carrierName"];
    [self.carrierInfo setValue:ctCarrier.isoCountryCode forKey:@"isoCountryCode"];
    [self.carrierInfo setValue:ctCarrier.mobileCountryCode forKey:@"mobileCountryCode"];
    [self.carrierInfo setValue:ctCarrier.mobileNetworkCode forKey:@"mobileNetworkCode"];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.carrierInfo forKey:ADCASH_CARRIER_INFO_DEFAULTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Fetching Ads
- (NSMutableURLRequest *)buildConfiguredURLRequestWithURL:(NSURL *)URL
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPShouldHandleCookies:YES];
    [request setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
    return request;
}

- (NSString *)userAgent
{
    if (!_userAgent) {
        self.userAgent = [[[[UIWebView alloc] init] autorelease] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    }
    
    return _userAgent;
}

- (ACAdServerCommunicator *)buildACAdServerCommunicatorWithDelegate:(id<ACAdServerCommunicatorDelegate>)delegate
{
    return [[(ACAdServerCommunicator *)[ACAdServerCommunicator alloc] initWithDelegate:delegate] autorelease];
}


#pragma mark - URL Handling

- (ACURLResolver *)buildACURLResolver
{
    return [ACURLResolver resolver];
}

- (ACAdDestinationDisplayAgent *)buildACAdDestinationDisplayAgentWithDelegate:(id<ACAdDestinationDisplayAgentDelegate>)delegate
{
    return [ACAdDestinationDisplayAgent agentWithDelegate:delegate];
}

#pragma mark - Utilities

- (id<ACAdAlertManagerProtocol>)buildACAdAlertManagerWithDelegate:(id)delegate
{
    id<ACAdAlertManagerProtocol> adAlertManager = nil;
    
    Class adAlertManagerClass = NSClassFromString(@"ACAdAlertManager");
    if(adAlertManagerClass != nil)
    {
        adAlertManager = [[[adAlertManagerClass alloc] init] autorelease];
        [adAlertManager performSelector:@selector(setDelegate:) withObject:delegate];
    }
    
    return adAlertManager;
}

- (ACAdAlertGestureRecognizer *)buildACAdAlertGestureRecognizerWithTarget:(id)target action:(SEL)action
{
    ACAdAlertGestureRecognizer *gestureRecognizer = nil;
    
    Class gestureRecognizerClass = NSClassFromString(@"ACAdAlertGestureRecognizer");
    if(gestureRecognizerClass != nil)
    {
        gestureRecognizer = [[[gestureRecognizerClass alloc] initWithTarget:target action:action] autorelease];
    }
    
    return gestureRecognizer;
}

- (NSOperationQueue *)sharedOperationQueue
{
    static NSOperationQueue *sharedOperationQueue = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedOperationQueue = [[NSOperationQueue alloc] init];
    });
    
    return sharedOperationQueue;
}

- (ACAnalyticsTracker *)sharedACAnalyticsTracker
{
    return [self singletonForClass:[ACAnalyticsTracker class] provider:^id{
        return [ACAnalyticsTracker tracker];
    }];
}

- (ACReachability *)sharedACReachability
{
    return [self singletonForClass:[ACReachability class] provider:^id{
        return [ACReachability reachabilityForLocalWiFi];
    }];
}

- (NSDictionary *)sharedCarrierInfo
{
    return self.carrierInfo;
}

- (ACTimer *)buildACTimerWithTimeInterval:(NSTimeInterval)seconds target:(id)target selector:(SEL)selector repeats:(BOOL)repeats
{
    return [ACTimer timerWithTimeInterval:seconds target:target selector:selector repeats:repeats];
}

#pragma mark - Twitter Availability

- (void)resetTwitterAppInstallCheck
{
    self.twitterDeepLinkStatus = ACTwitterDeepLinkNotChecked;
}

- (BOOL)isTwitterInstalled
{
    
    if (self.twitterDeepLinkStatus == ACTwitterDeepLinkNotChecked)
    {
        BOOL twitterDeepLinkEnabled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://timeline"]];
        if (twitterDeepLinkEnabled)
        {
            self.twitterDeepLinkStatus = ACTwitterDeepLinkEnabled;
        }
        else
        {
            self.twitterDeepLinkStatus = ACTwitterDeepLinkDisabled;
        }
    }
    
    return (self.twitterDeepLinkStatus == ACTwitterDeepLinkEnabled);
}

+ (BOOL)deviceHasTwitterIntegration
{
    return !![ACCoreInstanceProvider tweetComposeVCClass];
}

+ (Class)tweetComposeVCClass
{
    return NSClassFromString(@"TWTweetComposeViewController");
}

- (BOOL)isNativeTwitterAccountPresent
{
    BOOL nativeTwitterAccountPresent = NO;
    if ([ACCoreInstanceProvider deviceHasTwitterIntegration])
    {
        nativeTwitterAccountPresent = (BOOL)[[ACCoreInstanceProvider tweetComposeVCClass] performSelector:@selector(canSendTweet)];
    }
    
    return nativeTwitterAccountPresent;
}

- (ACTwitterAvailability)twitterAvailabilityOnDevice
{
    ACTwitterAvailability twitterAvailability = ACTwitterAvailabilityNone;
    
    if ([self isTwitterInstalled])
    {
        twitterAvailability |= ACTwitterAvailabilityApp;
    }
    
    if ([self isNativeTwitterAccountPresent])
    {
        twitterAvailability |= ACTwitterAvailabilityNative;
    }
    
    return twitterAvailability;
}



@end
