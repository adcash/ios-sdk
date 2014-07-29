//
//  ACCoreInstanceProvider.h
//  Adcash
//
//  Copyright (c) 2014 Adcash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ACGlobal.h"


@class ACAdConfiguration;

// Fetching Ads
@class ACAdServerCommunicator;
@protocol ACAdServerCommunicatorDelegate;

// URL Handling
@class ACURLResolver;
@class ACAdDestinationDisplayAgent;
@protocol ACAdDestinationDisplayAgentDelegate;

// Utilities
@class ACAdAlertManager, ACAdAlertGestureRecognizer;
@class ACAnalyticsTracker;
@class ACReachability;
@class ACTimer;

typedef id(^ACSingletonProviderBlock)();

typedef enum {
    ACTwitterAvailabilityNone = 0,
    ACTwitterAvailabilityApp = 1 << 0,
    ACTwitterAvailabilityNative = 1 << 1,
} ACTwitterAvailability;

@interface ACCoreInstanceProvider : NSObject

+ (instancetype)sharedProvider;
- (id)singletonForClass:(Class)klass provider:(ACSingletonProviderBlock)provider;

#pragma mark - Fetching Ads
- (NSMutableURLRequest *)buildConfiguredURLRequestWithURL:(NSURL *)URL;
- (ACAdServerCommunicator *)buildACAdServerCommunicatorWithDelegate:(id<ACAdServerCommunicatorDelegate>)delegate;

#pragma mark - URL Handling
- (ACURLResolver *)buildACURLResolver;
- (ACAdDestinationDisplayAgent *)buildACAdDestinationDisplayAgentWithDelegate:(id<ACAdDestinationDisplayAgentDelegate>)delegate;

#pragma mark - Utilities
- (id<ACAdAlertManagerProtocol>)buildACAdAlertManagerWithDelegate:(id)delegate;
- (ACAdAlertGestureRecognizer *)buildACAdAlertGestureRecognizerWithTarget:(id)target action:(SEL)action;
- (NSOperationQueue *)sharedOperationQueue;
- (ACAnalyticsTracker *)sharedACAnalyticsTracker;
- (ACReachability *)sharedACReachability;

// This call may return nil and may not update if the user hot-swaps the device's sim card.
- (NSDictionary *)sharedCarrierInfo;

- (ACTimer *)buildACTimerWithTimeInterval:(NSTimeInterval)seconds target:(id)target selector:(SEL)selector repeats:(BOOL)repeats;

- (ACTwitterAvailability)twitterAvailabilityOnDevice;
- (void)resetTwitterAppInstallCheck;


@end
