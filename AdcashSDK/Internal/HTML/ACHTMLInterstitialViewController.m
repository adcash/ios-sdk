//
//  ACHTMLInterstitialViewController.m
//  Adcash
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import "ACHTMLInterstitialViewController.h"
#import "ACAdWebView.h"
#import "ACAdDestinationDisplayAgent.h"
#import "ACInstanceProvider.h"

@interface ACHTMLInterstitialViewController ()

@property (nonatomic, retain) ACAdWebView *backingView;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation ACHTMLInterstitialViewController

@synthesize delegate = _delegate;
@synthesize backingViewAgent = _backingViewAgent;
@synthesize customMethodDelegate = _customMethodDelegate;
@synthesize backingView = _backingView;

- (void)dealloc
{
    self.backingViewAgent.delegate = nil;
    self.backingViewAgent.customMethodDelegate = nil;
    self.backingViewAgent = nil;

    self.backingView.delegate = nil;
    self.backingView = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];
    self.backingViewAgent = [[ACInstanceProvider sharedProvider] buildACAdWebViewAgentWithAdWebViewFrame:self.view.bounds
                                                                                                delegate:self
                                                                                    customMethodDelegate:self.customMethodDelegate];
    self.backingView = self.backingViewAgent.view;
    self.backingView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.backingView];
}

#pragma mark - Public

- (void)loadConfiguration:(ACAdConfiguration *)configuration
{
    [self view];
    [self.backingViewAgent loadConfiguration:configuration];
}

- (void)willPresentInterstitial
{
    self.backingView.alpha = 0.0;
    [self.delegate interstitialWillAppear:self];
}

- (void)didPresentInterstitial
{
    [self.backingViewAgent continueHandlingRequests];
    [self.backingViewAgent invokeJavaScriptForEvent:ACAdWebViewEventAdDidAppear];

    // XXX: In certain cases, UIWebView's content appears off-center due to rotation / auto-
    // resizing while off-screen. -forceRedraw corrects this issue, but there is always a brief
    // instant when the old content is visible. We mask this using a short fade animation.
    [self.backingViewAgent forceRedraw];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.backingView.alpha = 1.0;
    [UIView commitAnimations];

    [self.delegate interstitialDidAppear:self];
}

- (void)willDismissInterstitial
{
    [self.backingViewAgent stopHandlingRequests];
    [self.delegate interstitialWillDisappear:self];
}

- (void)didDismissInterstitial
{
    [self.backingViewAgent invokeJavaScriptForEvent:ACAdWebViewEventAdDidDisappear];
    [self.delegate interstitialDidDisappear:self];
}

#pragma mark - Autorotation

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];

    [self.backingViewAgent rotateToOrientation:self.interfaceOrientation];
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
    return self;
}

- (void)adDidFinishLoadingAd:(ACAdWebView *)ad
{
    [self.delegate interstitialDidLoadAd:self];
}

- (void)adDidFailToLoadAd:(ACAdWebView *)ad
{
    [self.delegate interstitialDidFailToLoadAd:self];
}

- (void)adActionWillBegin:(ACAdWebView *)ad
{
    // No need to tell anyone.
}

- (void)adActionWillLeaveApplication:(ACAdWebView *)ad
{
    [self.delegate interstitialWillLeaveApplication:self];
    [self dismissInterstitialAnimated:NO];
}

- (void)adActionDidFinish:(ACAdWebView *)ad
{
    //NOOP: the landing page is going away, but not the interstitial.
}

- (void)adDidClose:(ACAdWebView *)ad
{
    //NOOP: the ad is going away, but not the interstitial.
}

@end
