//
//  ACMRAIDBannerCustomEvent.m
//  Adcash
//
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import "ACMRAIDBannerCustomEvent.h"
#import "ACLogging.h"
#import "ACAdConfiguration.h"
#import "ACInstanceProvider.h"

@interface ACMRAIDBannerCustomEvent ()

@property (nonatomic, retain) MRAdView *banner;

@end

@implementation ACMRAIDBannerCustomEvent

@synthesize banner = _banner;

- (void)requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info
{
    ACLogInfo(@"Loading Adcash MRAID banner");
    ACAdConfiguration *configuration = [self.delegate configuration];

    CGRect adViewFrame = CGRectZero;
    if ([configuration hasPreferredSize]) {
        adViewFrame = CGRectMake(0, 0, configuration.preferredSize.width,
                                 configuration.preferredSize.height);
    }

    self.banner = [[ACInstanceProvider sharedProvider] buildMRAdViewWithFrame:adViewFrame
                                                              allowsExpansion:YES
                                                             closeButtonStyle:MRAdViewCloseButtonStyleAdControlled
                                                                placementType:MRAdViewPlacementTypeInline
                                                                     delegate:self];
    
    self.banner.delegate = self;
    [self.banner loadCreativeWithHTMLString:[configuration adResponseHTMLString]
                                    baseURL:nil];
}

- (void)dealloc
{
    self.banner.delegate = nil;
    self.banner = nil;

    [super dealloc];
}

- (void)rotateToOrientation:(UIInterfaceOrientation)newOrientation
{
    [self.banner rotateToOrientation:newOrientation];
}

#pragma mark - MRAdViewDelegate

- (CLLocation *)location
{
    return [self.delegate location];
}

- (NSString *)adUnitId
{
    return [self.delegate adUnitId];
}

- (ACAdConfiguration *)adConfiguration
{
    return [self.delegate configuration];
}

- (UIViewController *)viewControllerForPresentingModalView
{
    return [self.delegate viewControllerForPresentingModalView];
}

- (void)adDidLoad:(MRAdView *)adView
{
    ACLogInfo(@"Adcash MRAID banner did load");
    [self.delegate bannerCustomEvent:self didLoadAd:adView];
}

- (void)adDidFailToLoad:(MRAdView *)adView
{
    ACLogInfo(@"Adcash MRAID banner did fail");
    [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:nil];
}

- (void)closeButtonPressed:(MRAdView *)adView
{
    // we care
    ACLogInfo(@"Adcash MRAID banner had close button pressed");
    [adView setHidden: YES];
}

- (void)appShouldSuspendForAd:(MRAdView *)adView
{
    ACLogInfo(@"Adcash MRAID banner will begin action");
    [self.delegate bannerCustomEventWillBeginAction:self];
}

- (void)appShouldResumeFromAd:(MRAdView *)adView
{
    ACLogInfo(@"Adcash MRAID banner did end action");
    [self.delegate bannerCustomEventDidFinishAction:self];
}

@end
