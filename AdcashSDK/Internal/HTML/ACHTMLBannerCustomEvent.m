//
//  ACHTMLBannerCustomEvent.m
//  Adcash
//
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import "ACHTMLBannerCustomEvent.h"
#import "ACAdWebView.h"
#import "ACLogging.h"
#import "ACAdConfiguration.h"
#import "ACInstanceProvider.h"

@interface ACHTMLBannerCustomEvent ()

@property (nonatomic, retain) ACAdWebViewAgent *bannerAgent;

@end

@implementation ACHTMLBannerCustomEvent

@synthesize bannerAgent = _bannerAgent;

- (BOOL)enableAutomaticImpressionAndClickTracking
{
    return NO;
}

- (void)requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info
{
    ACLogInfo(@"Loading Adcash HTML banner");
    ACLogTrace(@"Loading banner with HTML source: %@", [[self.delegate configuration] adResponseHTMLString]);

    CGRect adWebViewFrame = CGRectMake(0, 0, size.width, size.height);
    self.bannerAgent = [[ACInstanceProvider sharedProvider] buildACAdWebViewAgentWithAdWebViewFrame:adWebViewFrame
                                                                                           delegate:self
                                                                               customMethodDelegate:[self.delegate bannerDelegate]];
    [self.bannerAgent loadConfiguration:[self.delegate configuration]];
}

- (void)dealloc
{
    self.bannerAgent.delegate = nil;
    self.bannerAgent.customMethodDelegate = nil;
    self.bannerAgent = nil;

    [super dealloc];
}

- (void)rotateToOrientation:(UIInterfaceOrientation)newOrientation
{
    [self.bannerAgent rotateToOrientation:newOrientation];
}

#pragma mark - ACAdWebViewAgentDelegate

- (CLLocation *)location
{
    return [self.delegate location];
}

- (NSString *)adUnitId
{
    return [self.delegate adUnitId];
}

- (UIViewController *)viewControllerForPresentingModalView
{
    return [self.delegate viewControllerForPresentingModalView];
}

- (void)adDidFinishLoadingAd:(ACAdWebView *)ad
{
    ACLogInfo(@"Adcash HTML banner did load");
    [self.delegate bannerCustomEvent:self didLoadAd:ad];
}

- (void)adDidFailToLoadAd:(ACAdWebView *)ad
{
    ACLogInfo(@"Adcash HTML banner did fail");
    [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:nil];
}

- (void)adDidClose:(ACAdWebView *)ad
{
    ACLogInfo(@"Adcash HTML banner had close button pressed");
    [ad setHidden: YES];
}

- (void)adActionWillBegin:(ACAdWebView *)ad
{
    ACLogInfo(@"Adcash HTML banner will begin action");
    [self.delegate bannerCustomEventWillBeginAction:self];
}

- (void)adActionDidFinish:(ACAdWebView *)ad
{
    ACLogInfo(@"Adcash HTML banner did finish action");
    [self.delegate bannerCustomEventDidFinishAction:self];
}

- (void)adActionWillLeaveApplication:(ACAdWebView *)ad
{
    ACLogInfo(@"Adcash HTML banner will leave application");
    [self.delegate bannerCustomEventWillLeaveApplication:self];
}


@end
