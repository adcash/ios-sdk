//
//  ACBaseInterstitialAdapter.m
//  Adcash
//
//  Created by Nafis Jamal on 4/27/11.
//  Copyright 2011 Adcash. All rights reserved.
//

#import "ACBaseInterstitialAdapter.h"
#import "ACAdConfiguration.h"
#import "ACGlobal.h"
#import "ACAnalyticsTracker.h"
#import "ACCoreInstanceProvider.h"
#import "ACTimer.h"
#import "ACConstants.h"

@interface ACBaseInterstitialAdapter ()

@property (nonatomic, retain) ACAdConfiguration *configuration;
@property (nonatomic, retain) ACTimer *timeoutTimer;

- (void)startTimeoutTimer;

@end

@implementation ACBaseInterstitialAdapter

@synthesize delegate = _delegate;
@synthesize configuration = _configuration;
@synthesize timeoutTimer = _timeoutTimer;

- (id)initWithDelegate:(id<ACInterstitialAdapterDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)dealloc
{
    [self unregisterDelegate];
    self.configuration = nil;

    [self.timeoutTimer invalidate];
    self.timeoutTimer = nil;

    [super dealloc];
}

- (void)unregisterDelegate
{
    self.delegate = nil;
}

- (void)getAdWithConfiguration:(ACAdConfiguration *)configuration
{
    // To be implemented by subclasses.
    [self doesNotRecognizeSelector:_cmd];
}

- (void)_getAdWithConfiguration:(ACAdConfiguration *)configuration
{
    self.configuration = configuration;

    [self startTimeoutTimer];

    [self retain];
    [self getAdWithConfiguration:configuration];
    [self release];
}

- (void)startTimeoutTimer
{
    NSTimeInterval timeInterval = (self.configuration && self.configuration.adTimeoutInterval >= 0) ?
            self.configuration.adTimeoutInterval : INTERSTITIAL_TIMEOUT_INTERVAL;
    
    if (timeInterval > 0) {
        self.timeoutTimer = [[ACCoreInstanceProvider sharedProvider] buildACTimerWithTimeInterval:timeInterval
                                                                                       target:self
                                                                                     selector:@selector(timeout)
                                                                                      repeats:NO];
        
        [self.timeoutTimer scheduleNow];
    }
}

- (void)didStopLoading
{
    [self.timeoutTimer invalidate];
}

- (void)timeout
{
    [self.delegate adapter:self didFailToLoadAdWithError:nil];
}

#pragma mark - Presentation

- (void)showInterstitialFromViewController:(UIViewController *)controller
{
    [self doesNotRecognizeSelector:_cmd];
}

#pragma mark - Metrics

- (void)trackImpression
{
    [[[ACCoreInstanceProvider sharedProvider] sharedACAnalyticsTracker] trackImpressionForConfiguration:self.configuration];
}

- (void)trackClick
{
    [[[ACCoreInstanceProvider sharedProvider] sharedACAnalyticsTracker] trackClickForConfiguration:self.configuration];
}

@end

