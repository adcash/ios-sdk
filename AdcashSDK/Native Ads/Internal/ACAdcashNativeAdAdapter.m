//
//  ACAdcashNativeAdAdapter.m
//
//  Copyright (c) 2014 Adcash. All rights reserved.
//

#import "ACAdcashNativeAdAdapter.h"
#import "ACNativeAdError.h"
#import "ACAdDestinationDisplayAgent.h"
#import "ACCoreInstanceProvider.h"

#define kImpressionTrackerURLsKey   @"imptracker"
#define kDefaultActionURLKey        @"clk"
#define kClickTrackerURLKey         @"clktracker"

@interface ACAdcashNativeAdAdapter () <ACAdDestinationDisplayAgentDelegate>

@property (nonatomic, readonly, retain) ACAdDestinationDisplayAgent *destinationDisplayAgent;
@property (nonatomic, assign) UIViewController *rootViewController;
@property (nonatomic, copy) void (^actionCompletionBlock)(BOOL, NSError *);

@end

@implementation ACAdcashNativeAdAdapter

@synthesize properties = _properties;
@synthesize defaultActionURL = _defaultActionURL;

- (instancetype)initWithAdProperties:(NSMutableDictionary *)properties
{
    if (self = [super init]) {
        BOOL valid = YES;

        NSArray *impressionTrackers = [properties objectForKey:kImpressionTrackerURLsKey];
        if (![impressionTrackers isKindOfClass:[NSArray class]] || [impressionTrackers count] < 1) {
            valid = NO;
        } else {
            _impressionTrackers = [impressionTrackers retain];
        }

        NSString *engagementTracker = [properties objectForKey:kClickTrackerURLKey];
        if (engagementTracker == nil) {
            valid = NO;
        } else {
            _engagementTrackingURL = [[NSURL URLWithString:engagementTracker] retain];
        }

        _defaultActionURL = [[NSURL URLWithString:[properties objectForKey:kDefaultActionURLKey]] retain];

        [properties removeObjectsForKeys:[NSArray arrayWithObjects:kImpressionTrackerURLsKey, kClickTrackerURLKey, kDefaultActionURLKey, nil]];
        _properties = [properties retain];

        if (!valid) {
            [self release];
            return nil;
        }

        _destinationDisplayAgent = [[[ACCoreInstanceProvider sharedProvider] buildACAdDestinationDisplayAgentWithDelegate:self] retain];
    }

    return self;
}

- (void)dealloc
{
    [_impressionTrackers release];
    [_engagementTrackingURL release];
    [_actionCompletionBlock release];
    [_destinationDisplayAgent cancel];
    [_destinationDisplayAgent setDelegate:nil];
    [_destinationDisplayAgent release];
    [_properties release];
    [_defaultActionURL release];
    [super dealloc];
}

- (void)displayContentForURL:(NSURL *)URL rootViewController:(UIViewController *)controller
                  completion:(void (^)(BOOL success, NSError *error))completionBlock
{
    NSError *error = nil;

    if (!controller) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Cannot display content without a root view controller."
                                                             forKey:ACNativeAdErrorContentDisplayErrorReasonKey];
        error = [NSError errorWithDomain:AdcashNativeAdsSDKDomain
                                    code:ACNativeAdErrorContentDisplayError
                                userInfo:userInfo];
    }

    if (!URL || ![URL isKindOfClass:[NSURL class]] || ![URL.absoluteString length]) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Cannot display content without a valid URL."
                                                             forKey:ACNativeAdErrorContentDisplayErrorReasonKey];
        error = [NSError errorWithDomain:AdcashNativeAdsSDKDomain
                                    code:ACNativeAdErrorContentDisplayError
                                userInfo:userInfo];
    }

    if (error) {

        if (completionBlock) {
            completionBlock(NO, error);
        }

        return;
    }

    self.rootViewController = controller;
    self.actionCompletionBlock = completionBlock;

    [self.destinationDisplayAgent displayDestinationForURL:URL];
}

#pragma mark - <ACAdDestinationDisplayAgent>

- (UIViewController *)viewControllerForPresentingModalView
{
    return self.rootViewController;
}

- (void)displayAgentWillPresentModal
{

}

- (void)displayAgentWillLeaveApplication
{
    if (self.actionCompletionBlock) {
        self.actionCompletionBlock(YES, nil);
        self.actionCompletionBlock = nil;
    }

}

- (void)displayAgentDidDismissModal
{
    if (self.actionCompletionBlock) {
        self.actionCompletionBlock(YES, nil);
        self.actionCompletionBlock = nil;
    }

    self.rootViewController = nil;
}
@end
