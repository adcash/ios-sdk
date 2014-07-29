//
//  ACInstanceProvider.m
//  Adcash
//
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import "ACInstanceProvider.h"
#import "ACAdWebView.h"
#import "ACAdWebViewAgent.h"
#import "ACInterstitialAdManager.h"
#import "ACInterstitialCustomEventAdapter.h"
#import "ACLegacyInterstitialCustomEventAdapter.h"
#import "ACHTMLInterstitialViewController.h"
#import "ACMRAIDInterstitialViewController.h"
#import "ACInterstitialCustomEvent.h"
#import "ACBaseBannerAdapter.h"
#import "ACBannerCustomEventAdapter.h"
#import "ACLegacyBannerCustomEventAdapter.h"
#import "ACBannerCustomEvent.h"
#import "ACBannerAdManager.h"
#import "ACLogging.h"
#import "MRJavaScriptEventEmitter.h"
#import "MRImageDownloader.h"
#import "MRBundleManager.h"
#import "MRCalendarManager.h"
#import "MRPictureManager.h"
#import "MRVideoPlayerManager.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ACNativeCustomEvent.h"



@interface ACInstanceProvider ()

@property (nonatomic, retain) NSMutableDictionary *singletons;

@end


@implementation ACInstanceProvider

static ACInstanceProvider *sharedAdProvider = nil;

+ (instancetype)sharedProvider
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedAdProvider = [[self alloc] init];
    });

    return sharedAdProvider;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.singletons = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc
{
    self.singletons = nil;
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

#pragma mark - Banners

- (ACBannerAdManager *)buildACBannerAdManagerWithDelegate:(id<ACBannerAdManagerDelegate>)delegate
{
    return [[(ACBannerAdManager *)[ACBannerAdManager alloc] initWithDelegate:delegate] autorelease];
}

- (ACBaseBannerAdapter *)buildBannerAdapterForConfiguration:(ACAdConfiguration *)configuration
                                                   delegate:(id<ACBannerAdapterDelegate>)delegate
{
    if (configuration.customEventClass) {
        return [[(ACBannerCustomEventAdapter *)[ACBannerCustomEventAdapter alloc] initWithDelegate:delegate] autorelease];
    } else if (configuration.customSelectorName) {
        return [[(ACLegacyBannerCustomEventAdapter *)[ACLegacyBannerCustomEventAdapter alloc] initWithDelegate:delegate] autorelease];
    }

    return nil;
}

- (ACBannerCustomEvent *)buildBannerCustomEventFromCustomClass:(Class)customClass
                                                      delegate:(id<ACBannerCustomEventDelegate>)delegate
{
    ACBannerCustomEvent *customEvent = [[[customClass alloc] init] autorelease];
    if (![customEvent isKindOfClass:[ACBannerCustomEvent class]]) {
        ACLogError(@"**** Custom Event Class: %@ does not extend ACBannerCustomEvent ****", NSStringFromClass(customClass));
        return nil;
    }
    customEvent.delegate = delegate;
    return customEvent;
}

#pragma mark - Interstitials

- (ACInterstitialAdManager *)buildACInterstitialAdManagerWithDelegate:(id<ACInterstitialAdManagerDelegate>)delegate
{
    return [[(ACInterstitialAdManager *)[ACInterstitialAdManager alloc] initWithDelegate:delegate] autorelease];
}


- (ACBaseInterstitialAdapter *)buildInterstitialAdapterForConfiguration:(ACAdConfiguration *)configuration
                                                               delegate:(id<ACInterstitialAdapterDelegate>)delegate
{
    if (configuration.customEventClass) {
        return [[(ACInterstitialCustomEventAdapter *)[ACInterstitialCustomEventAdapter alloc] initWithDelegate:delegate] autorelease];
    } else if (configuration.customSelectorName) {
        return [[(ACLegacyInterstitialCustomEventAdapter *)[ACLegacyInterstitialCustomEventAdapter alloc] initWithDelegate:delegate] autorelease];
    }

    return nil;
}

- (ACInterstitialCustomEvent *)buildInterstitialCustomEventFromCustomClass:(Class)customClass
                                                                  delegate:(id<ACInterstitialCustomEventDelegate>)delegate
{
    ACInterstitialCustomEvent *customEvent = [[[customClass alloc] init] autorelease];
    if (![customEvent isKindOfClass:[ACInterstitialCustomEvent class]]) {
        ACLogError(@"**** Custom Event Class: %@ does not extend ACInterstitialCustomEvent ****", NSStringFromClass(customClass));
        return nil;
    }
    if ([customEvent respondsToSelector:@selector(customEventDidUnload)]) {
        ACLogWarn(@"**** Custom Event Class: %@ implements the deprecated -customEventDidUnload method.  This is no longer called.  Use -dealloc for cleanup instead ****", NSStringFromClass(customClass));
    }
    customEvent.delegate = delegate;
    return customEvent;
}

- (ACHTMLInterstitialViewController *)buildACHTMLInterstitialViewControllerWithDelegate:(id<ACInterstitialViewControllerDelegate>)delegate
                                                                        orientationType:(ACInterstitialOrientationType)type
                                                                   customMethodDelegate:(id)customMethodDelegate
{
    ACHTMLInterstitialViewController *controller = [[[ACHTMLInterstitialViewController alloc] init] autorelease];
    controller.delegate = delegate;
    controller.orientationType = type;
    controller.customMethodDelegate = customMethodDelegate;
    return controller;
}

- (ACMRAIDInterstitialViewController *)buildACMRAIDInterstitialViewControllerWithDelegate:(id<ACInterstitialViewControllerDelegate>)delegate
                                                                            configuration:(ACAdConfiguration *)configuration
{
    ACMRAIDInterstitialViewController *controller = [[[ACMRAIDInterstitialViewController alloc] initWithAdConfiguration:configuration] autorelease];
    controller.delegate = delegate;
    return controller;
}

#pragma mark - HTML Ads

- (ACAdWebView *)buildACAdWebViewWithFrame:(CGRect)frame delegate:(id<UIWebViewDelegate>)delegate
{
    ACAdWebView *webView = [[[ACAdWebView alloc] initWithFrame:frame] autorelease];
    webView.delegate = delegate;
    return webView;
}

- (ACAdWebViewAgent *)buildACAdWebViewAgentWithAdWebViewFrame:(CGRect)frame delegate:(id<ACAdWebViewAgentDelegate>)delegate customMethodDelegate:(id)customMethodDelegate
{
    return [[[ACAdWebViewAgent alloc] initWithAdWebViewFrame:frame delegate:delegate customMethodDelegate:customMethodDelegate] autorelease];
}

#pragma mark - MRAID

- (MRAdView *)buildMRAdViewWithFrame:(CGRect)frame
                     allowsExpansion:(BOOL)allowsExpansion
                    closeButtonStyle:(MRAdViewCloseButtonStyle)style
                       placementType:(MRAdViewPlacementType)type
                            delegate:(id<MRAdViewDelegate>)delegate
{
    MRAdView *mrAdView = [[[MRAdView alloc] initWithFrame:frame allowsExpansion:allowsExpansion closeButtonStyle:style placementType:type] autorelease];
    mrAdView.delegate = delegate;
    return mrAdView;
}

- (MRBundleManager *)buildMRBundleManager
{
    return [MRBundleManager sharedManager];
}

- (UIWebView *)buildUIWebViewWithFrame:(CGRect)frame
{
    return [[[UIWebView alloc] initWithFrame:frame] autorelease];
}

- (MRJavaScriptEventEmitter *)buildMRJavaScriptEventEmitterWithWebView:(UIWebView *)webView
{
    return [[[MRJavaScriptEventEmitter alloc] initWithWebView:webView] autorelease];
}

- (MRCalendarManager *)buildMRCalendarManagerWithDelegate:(id<MRCalendarManagerDelegate>)delegate
{
    return [[[MRCalendarManager alloc] initWithDelegate:delegate] autorelease];
}

- (EKEventEditViewController *)buildEKEventEditViewControllerWithEditViewDelegate:(id<EKEventEditViewDelegate>)editViewDelegate
{
    EKEventEditViewController *controller = [[[EKEventEditViewController alloc] init] autorelease];
    controller.editViewDelegate = editViewDelegate;
    controller.eventStore = [self buildEKEventStore];
    return controller;
}

- (EKEventStore *)buildEKEventStore
{
    return [[[EKEventStore alloc] init] autorelease];
}

- (MRPictureManager *)buildMRPictureManagerWithDelegate:(id<MRPictureManagerDelegate>)delegate
{
    return [[[MRPictureManager alloc] initWithDelegate:delegate] autorelease];
}

- (MRImageDownloader *)buildMRImageDownloaderWithDelegate:(id<MRImageDownloaderDelegate>)delegate
{
    return [[[MRImageDownloader alloc] initWithDelegate:delegate] autorelease];
}

- (MRVideoPlayerManager *)buildMRVideoPlayerManagerWithDelegate:(id<MRVideoPlayerManagerDelegate>)delegate
{
    return [[[MRVideoPlayerManager alloc] initWithDelegate:delegate] autorelease];
}

- (MPMoviePlayerViewController *)buildACMoviePlayerViewControllerWithURL:(NSURL *)URL
{
    // ImageContext used to avoid CGErrors
    // http://stackoverflow.com/questions/13203336/iphone-mpmovieplayerviewcontroller-cgcontext-errors/14669166#14669166
    UIGraphicsBeginImageContext(CGSizeMake(1,1));
    MPMoviePlayerViewController *playerViewController = [[[MPMoviePlayerViewController alloc] initWithContentURL:URL] autorelease];
    UIGraphicsEndImageContext();

    return playerViewController;
}

#pragma mark - Native

- (ACNativeCustomEvent *)buildNativeCustomEventFromCustomClass:(Class)customClass
                                                      delegate:(id<ACNativeCustomEventDelegate>)delegate
{
    ACNativeCustomEvent *customEvent = [[[customClass alloc] init] autorelease];
    if (![customEvent isKindOfClass:[ACNativeCustomEvent class]]) {
        ACLogError(@"**** Custom Event Class: %@ does not extend ACNativeCustomEvent ****", NSStringFromClass(customClass));
        return nil;
    }
    customEvent.delegate = delegate;
    return customEvent;
}


@end

