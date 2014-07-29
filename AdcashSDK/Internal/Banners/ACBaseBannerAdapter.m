//
//  ACBaseBannerAdapter.m
//  Adcash
//
//  Created by Nafis Jamal on 1/19/11.
//  Copyright (c) 2014, Adcash OU and MoPub Inc.
//

#import "ACBaseBannerAdapter.h"
#import "ACConstants.h"

#import "ACAdConfiguration.h"
#import "ACLogging.h"
#import "ACCoreInstanceProvider.h"
#import "ACAnalyticsTracker.h"
#import "ACTimer.h"

@interface ACBaseBannerAdapter ()

@property (nonatomic, retain) ACAdConfiguration *configuration;
@property (nonatomic, retain) ACTimer *timeoutTimer;

- (void)startTimeoutTimer;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation ACBaseBannerAdapter

@synthesize delegate = _delegate;
@synthesize configuration = _configuration;
@synthesize timeoutTimer = _timeoutTimer;

- (id)initWithDelegate:(id<ACBannerAdapterDelegate>)delegate
{
    if (self = [super init]) {
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

#pragma mark - Requesting Ads

- (void)getAdWithConfiguration:(ACAdConfiguration *)configuration containerSize:(CGSize)size
{
    // To be implemented by subclasses.
    [self doesNotRecognizeSelector:_cmd];
}

- (void)_getAdWithConfiguration:(ACAdConfiguration *)configuration containerSize:(CGSize)size
{
    self.configuration = configuration;

    [self startTimeoutTimer];

    [self retain];
    [self getAdWithConfiguration:configuration containerSize:size];
    [self release];
}

- (void)didStopLoading
{
    [self.timeoutTimer invalidate];
}

- (void)didDisplayAd
{
    [self trackImpression];
}

- (void)startTimeoutTimer
{
    NSTimeInterval timeInterval = (self.configuration && self.configuration.adTimeoutInterval >= 0) ?
    self.configuration.adTimeoutInterval : BANNER_TIMEOUT_INTERVAL;
    
    if (timeInterval > 0) {
        self.timeoutTimer = [[ACCoreInstanceProvider sharedProvider] buildACTimerWithTimeInterval:timeInterval
                                                                                       target:self
                                                                                     selector:@selector(timeout)
                                                                                      repeats:NO];
        
        [self.timeoutTimer scheduleNow];
    }
}

- (void)timeout
{
    [self.delegate adapter:self didFailToLoadAdWithError:nil];
}

#pragma mark - Rotation

- (void)rotateToOrientation:(UIInterfaceOrientation)newOrientation
{
    // Do nothing by default. Subclasses can override.
    ACLogDebug(@"rotateToOrientation %d called for adapter %@ (%p)",
          newOrientation, NSStringFromClass([self class]), self);
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
