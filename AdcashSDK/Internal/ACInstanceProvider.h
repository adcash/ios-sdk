//
//  ACInstanceProvider.h
//  Adcash
//
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import "ACGlobal.h"
#import "ACCoreInstanceProvider.h"

// Banners
@class ACBannerAdManager;
@protocol ACBannerAdManagerDelegate;
@class ACBaseBannerAdapter;
@protocol ACBannerAdapterDelegate;
@class ACBannerCustomEvent;
@protocol ACBannerCustomEventDelegate;

// Interstitials
@class ACInterstitialAdManager;
@protocol ACInterstitialAdManagerDelegate;
@class ACBaseInterstitialAdapter;
@protocol ACInterstitialAdapterDelegate;
@class ACInterstitialCustomEvent;
@protocol ACInterstitialCustomEventDelegate;
@class ACHTMLInterstitialViewController;
@class ACMRAIDInterstitialViewController;
@protocol ACInterstitialViewControllerDelegate;

// HTML Ads
@class ACAdWebView;
@class ACAdWebViewAgent;
@protocol ACAdWebViewAgentDelegate;

// MRAID
@class MRAdView;
@protocol MRAdViewDelegate;
@class MRBundleManager;
@class MRJavaScriptEventEmitter;
@class MRCalendarManager;
@protocol MRCalendarManagerDelegate;
@class EKEventStore;
@class EKEventEditViewController;
@protocol EKEventEditViewDelegate;
@class MRPictureManager;
@protocol MRPictureManagerDelegate;
@class MRImageDownloader;
@protocol MRImageDownloaderDelegate;
@class MRVideoPlayerManager;
@protocol MRVideoPlayerManagerDelegate;
@class ACMoviePlayerViewController;

//Native
@protocol ACNativeCustomEventDelegate;
@class ACNativeCustomEvent;


@interface ACInstanceProvider : NSObject

+(instancetype)sharedProvider;
- (id)singletonForClass:(Class)klass provider:(ACSingletonProviderBlock)provider;

#pragma mark - Banners
- (ACBannerAdManager *)buildACBannerAdManagerWithDelegate:(id<ACBannerAdManagerDelegate>)delegate;
- (ACBaseBannerAdapter *)buildBannerAdapterForConfiguration:(ACAdConfiguration *)configuration
                                                   delegate:(id<ACBannerAdapterDelegate>)delegate;
- (ACBannerCustomEvent *)buildBannerCustomEventFromCustomClass:(Class)customClass
                                                      delegate:(id<ACBannerCustomEventDelegate>)delegate;

#pragma mark - Interstitials
- (ACInterstitialAdManager *)buildACInterstitialAdManagerWithDelegate:(id<ACInterstitialAdManagerDelegate>)delegate;
- (ACBaseInterstitialAdapter *)buildInterstitialAdapterForConfiguration:(ACAdConfiguration *)configuration
                                                               delegate:(id<ACInterstitialAdapterDelegate>)delegate;
- (ACInterstitialCustomEvent *)buildInterstitialCustomEventFromCustomClass:(Class)customClass
                                                                  delegate:(id<ACInterstitialCustomEventDelegate>)delegate;
- (ACHTMLInterstitialViewController *)buildACHTMLInterstitialViewControllerWithDelegate:(id<ACInterstitialViewControllerDelegate>)delegate
                                                                        orientationType:(ACInterstitialOrientationType)type
                                                                   customMethodDelegate:(id)customMethodDelegate;
- (ACMRAIDInterstitialViewController *)buildACMRAIDInterstitialViewControllerWithDelegate:(id<ACInterstitialViewControllerDelegate>)delegate
                                                                            configuration:(ACAdConfiguration *)configuration;

#pragma mark - HTML Ads
- (ACAdWebView *)buildACAdWebViewWithFrame:(CGRect)frame
                                  delegate:(id<UIWebViewDelegate>)delegate;
- (ACAdWebViewAgent *)buildACAdWebViewAgentWithAdWebViewFrame:(CGRect)frame
                                                     delegate:(id<ACAdWebViewAgentDelegate>)delegate
                                         customMethodDelegate:(id)customMethodDelegate;

#pragma mark - MRAID
- (MRAdView *)buildMRAdViewWithFrame:(CGRect)frame
                     allowsExpansion:(BOOL)allowsExpansion
                    closeButtonStyle:(NSUInteger)style
                       placementType:(NSUInteger)type
                            delegate:(id<MRAdViewDelegate>)delegate;
- (MRBundleManager *)buildMRBundleManager;
- (UIWebView *)buildUIWebViewWithFrame:(CGRect)frame;
- (MRJavaScriptEventEmitter *)buildMRJavaScriptEventEmitterWithWebView:(UIWebView *)webView;
- (MRCalendarManager *)buildMRCalendarManagerWithDelegate:(id<MRCalendarManagerDelegate>)delegate;
- (EKEventEditViewController *)buildEKEventEditViewControllerWithEditViewDelegate:(id<EKEventEditViewDelegate>)editViewDelegate;
- (EKEventStore *)buildEKEventStore;
- (MRPictureManager *)buildMRPictureManagerWithDelegate:(id<MRPictureManagerDelegate>)delegate;
- (MRImageDownloader *)buildMRImageDownloaderWithDelegate:(id<MRImageDownloaderDelegate>)delegate;
- (MRVideoPlayerManager *)buildMRVideoPlayerManagerWithDelegate:(id<MRVideoPlayerManagerDelegate>)delegate;
- (ACMoviePlayerViewController *)buildACMoviePlayerViewControllerWithURL:(NSURL *)URL;

#pragma mark - Native

- (ACNativeCustomEvent *)buildNativeCustomEventFromCustomClass:(Class)customClass
                                                      delegate:(id<ACNativeCustomEventDelegate>)delegate;


@end
