//
//  ACAdWebViewAgent.m
//  Adcash
//
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import "ACAdWebViewAgent.h"
#import "ACAdConfiguration.h"
#import "ACGlobal.h"
#import "ACLogging.h"
#import "ACAdDestinationDisplayAgent.h"
#import "NSURL+ACAdditions.h"
#import "UIWebView+ACAdditions.h"
#import "ACAdWebView.h"
#import "ACInstanceProvider.h"
#import "ACCoreInstanceProvider.h"
#import "NSJSONSerialization+ACAdditions.h"
#import "NSURL+ACAdditions.h"

#ifndef NSFoundationVersionNumber_iOS_6_1
#define NSFoundationVersionNumber_iOS_6_1 993.00
#endif

#define ACOffscreenWebViewNeedsRenderingWorkaround() (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)

NSString * const kAdcashURLScheme = @"adcash";
NSString * const kAdcashCloseHost = @"close";
NSString * const kAdcashFinishLoadHost = @"finishLoad";
NSString * const kAdcashFailLoadHost = @"failLoad";
NSString * const kAdcashCustomHost = @"custom";

@interface ACAdWebViewAgent ()

@property (nonatomic, retain) ACAdConfiguration *configuration;
@property (nonatomic, retain) ACAdDestinationDisplayAgent *destinationDisplayAgent;
@property (nonatomic, assign) BOOL shouldHandleRequests;
@property (nonatomic, retain) id<ACAdAlertManagerProtocol> adAlertManager;

- (void)performActionForAdcashSpecificURL:(NSURL *)URL;
- (BOOL)shouldIntercept:(NSURL *)URL navigationType:(UIWebViewNavigationType)navigationType;
- (void)interceptURL:(NSURL *)URL;
- (void)handleAdcashCustomURL:(NSURL *)URL;

@end

@implementation ACAdWebViewAgent

@synthesize configuration = _configuration;
@synthesize delegate = _delegate;
@synthesize destinationDisplayAgent = _destinationDisplayAgent;
@synthesize customMethodDelegate = _customMethodDelegate;
@synthesize shouldHandleRequests = _shouldHandleRequests;
@synthesize view = _view;
@synthesize adAlertManager = _adAlertManager;

- (id)initWithAdWebViewFrame:(CGRect)frame delegate:(id<ACAdWebViewAgentDelegate>)delegate customMethodDelegate:(id)customMethodDelegate;
{
    self = [super init];
    if (self) {
        self.view = [[ACInstanceProvider sharedProvider] buildACAdWebViewWithFrame:frame delegate:self];
        self.destinationDisplayAgent = [[ACCoreInstanceProvider sharedProvider] buildACAdDestinationDisplayAgentWithDelegate:self];
        self.delegate = delegate;
        self.customMethodDelegate = customMethodDelegate;
        self.shouldHandleRequests = YES;
        self.adAlertManager = [[ACCoreInstanceProvider sharedProvider] buildACAdAlertManagerWithDelegate:self];
    }
    return self;
}

- (void)dealloc
{
    self.adAlertManager.targetAdView = nil;
    self.adAlertManager.delegate = nil;
    self.adAlertManager = nil;
    self.configuration = nil;
    [self.destinationDisplayAgent cancel];
    [self.destinationDisplayAgent setDelegate:nil];
    self.destinationDisplayAgent = nil;
    self.view.delegate = nil;
    self.view = nil;
    [super dealloc];
}

#pragma mark - <ACAdAlertManagerDelegate>

- (UIViewController *)viewControllerForPresentingMailVC
{
    return [self.delegate viewControllerForPresentingModalView];
}

- (void)adAlertManagerDidTriggerAlert:(ACAdAlertManager *)manager
{
    [self.adAlertManager processAdAlertOnce];
}

#pragma mark - Public

- (void)loadConfiguration:(ACAdConfiguration *)configuration
{
    self.configuration = configuration;

    // Ignore server configuration size for interstitials. At this point our web view
    // is sized correctly for the device's screen. Currently the server sends down values for a 3.5in
    // screen, and they do not size correctly on a 4in screen.
    if (configuration.adType != ACAdTypeInterstitial) {
        if ([configuration hasPreferredSize]) {
            CGRect frame = self.view.frame;
            frame.size.width = configuration.preferredSize.width;
            frame.size.height = configuration.preferredSize.height;
            self.view.frame = frame;
        }
    }

    [self.view mp_setScrollable:configuration.scrollable];
  //  [self.view disableJavaScriptDialogs];
    [self.view loadHTMLString:[configuration adResponseHTMLString]
                         baseURL:nil];

    [self initAdAlertManager];
}

- (void)invokeJavaScriptForEvent:(ACAdWebViewEvent)event
{
    switch (event) {
        case ACAdWebViewEventAdDidAppear:
            [self.view stringByEvaluatingJavaScriptFromString:@"webviewDidAppear();"];
            break;
        case ACAdWebViewEventAdDidDisappear:
            [self.view stringByEvaluatingJavaScriptFromString:@"webviewDidClose();"];
            break;
        default:
            break;
    }
}

- (void)stopHandlingRequests
{
    self.shouldHandleRequests = NO;
    [self.destinationDisplayAgent cancel];
}

- (void)continueHandlingRequests
{
    self.shouldHandleRequests = YES;
}

#pragma mark - <ACAdDestinationDisplayAgentDelegate>

- (UIViewController *)viewControllerForPresentingModalView
{
    return [self.delegate viewControllerForPresentingModalView];
}

- (void)displayAgentWillPresentModal
{
    [self.delegate adActionWillBegin:self.view];
}

- (void)displayAgentWillLeaveApplication
{
    [self.delegate adActionWillLeaveApplication:self.view];
}

- (void)displayAgentDidDismissModal
{
    [self.delegate adActionDidFinish:self.view];
}

#pragma mark - <UIWebViewDelegate>

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
     ACLogDebug(@"Ad Agent ACAdWebViewAgent (%p) wanted to load URL: %@", self, request.URL);
    if (!self.shouldHandleRequests) {
        return NO;
    }

    NSURL *URL = [request URL];
    if ([[URL scheme] isEqualToString:kAdcashURLScheme]) {
        [self performActionForAdcashSpecificURL:URL];
        return NO;
    } else if ([self shouldIntercept:URL navigationType:navigationType]) {
        [self interceptURL:URL];
        return NO;
    } else {
        return YES;
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
   // [self.view disableJavaScriptDialogs];
}

#pragma mark - Adcash-specific URL handlers
- (void)performActionForAdcashSpecificURL:(NSURL *)URL
{
    ACLogDebug(@"ACAdWebView - loading Adcash URL: %@", URL);
    NSString *host = [URL host];
    if ([host isEqualToString:kAdcashCloseHost]) {
        [self.delegate adDidClose:self.view];
    } else if ([host isEqualToString:kAdcashFinishLoadHost]) {
        [self.delegate adDidFinishLoadingAd:self.view];
    } else if ([host isEqualToString:kAdcashFailLoadHost]) {
        [self.delegate adDidFailToLoadAd:self.view];
    } else if ([host isEqualToString:kAdcashCustomHost]) {
        [self handleAdcashCustomURL:URL];
    } else {
        ACLogWarn(@"ACAdWebView - unsupported Adcash URL: %@", [URL absoluteString]);
    }
}

- (void)handleAdcashCustomURL:(NSURL *)URL
{
    NSDictionary *queryParameters = [URL mp_queryAsDictionary];
    NSString *selectorName = [queryParameters objectForKey:@"fnc"];
    NSString *oneArgumentSelectorName = [selectorName stringByAppendingString:@":"];
    SEL zeroArgumentSelector = NSSelectorFromString(selectorName);
    SEL oneArgumentSelector = NSSelectorFromString(oneArgumentSelectorName);

    if ([self.customMethodDelegate respondsToSelector:zeroArgumentSelector]) {
        [self.customMethodDelegate performSelector:zeroArgumentSelector];
    } else if ([self.customMethodDelegate respondsToSelector:oneArgumentSelector]) {
        NSData *data = [[queryParameters objectForKey:@"data"] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dataDictionary = nil;
        if (data) {
            dataDictionary = [NSJSONSerialization mp_JSONObjectWithData:data options:NSJSONReadingMutableContainers clearNullObjects:YES error:nil];
        }

        [self.customMethodDelegate performSelector:oneArgumentSelector
                                        withObject:dataDictionary];
    } else {
        ACLogError(@"Custom method delegate does not implement custom selectors %@ or %@.",
                   selectorName, oneArgumentSelectorName);
    }
}

#pragma mark - URL Interception
- (BOOL)shouldIntercept:(NSURL *)URL navigationType:(UIWebViewNavigationType)navigationType
{
     ACLogDebug(@"Ad Agent ACAdWebViewAgent (%p) wanted to load URL in should Intercept");

    if ([URL mp_hasTelephoneScheme] || [URL mp_hasTelephonePromptScheme]) {
        return YES;
    } else if (!(self.configuration.shouldInterceptLinks)) {
        return NO;
    } else if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        return YES;
    } else if (navigationType == UIWebViewNavigationTypeOther) {
        return [[URL absoluteString] hasPrefix:[self.configuration clickDetectionURLPrefix]];
    } else {
        return NO;
    }
}

- (void)interceptURL:(NSURL *)URL
{
    NSURL *redirectedURL = URL;
    if (self.configuration.clickTrackingURL) {
        NSString *path = [NSString stringWithFormat:@"%@&r=%@",
                          self.configuration.clickTrackingURL.absoluteString,
                          [[URL absoluteString] URLEncodedString]];
        redirectedURL = [NSURL URLWithString:path];
    }

    [self.destinationDisplayAgent displayDestinationForURL:redirectedURL];
}

#pragma mark - Utility

- (void)initAdAlertManager
{
    self.adAlertManager.adConfiguration = self.configuration;
    self.adAlertManager.adUnitId = [self.delegate adUnitId];
    self.adAlertManager.targetAdView = self.view;
    self.adAlertManager.location = [self.delegate location];
    [self.adAlertManager beginMonitoringAlerts];
}

- (void)rotateToOrientation:(UIInterfaceOrientation)orientation
{
    [self forceRedraw];
}

- (void)forceRedraw
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    int angle = -1;
    switch (orientation)
    {
        case UIInterfaceOrientationPortrait: angle = 0; break;
        case UIInterfaceOrientationLandscapeLeft: angle = 90; break;
        case UIInterfaceOrientationLandscapeRight: angle = -90; break;
        case UIInterfaceOrientationPortraitUpsideDown: angle = 180; break;
        default: break;
    }

    if (angle == -1) return;

    // UIWebView doesn't seem to fire the 'orientationchange' event upon rotation, so we do it here.
    NSString *orientationEventScript = [NSString stringWithFormat:
                                        @"window.__defineGetter__('orientation',function(){return %d;});"
                                        @"(function(){ var evt = document.createEvent('Events');"
                                        @"evt.initEvent('orientationchange',true,true);window.dispatchEvent(evt);})();",
                                        angle];
    [self.view stringByEvaluatingJavaScriptFromString:orientationEventScript];

    // XXX: If the UIWebView is rotated off-screen (which may happen with interstitials), its
    // content may render off-center upon display. We compensate by setting the viewport meta tag's
    // 'width' attribute to be the size of the webview.
    NSString *viewportUpdateScript = [NSString stringWithFormat:
                                      @"document.querySelector('meta[name=viewport]')"
                                      @".setAttribute('content', 'width=%f;', false);",
                                      self.view.frame.size.width];
    [self.view stringByEvaluatingJavaScriptFromString:viewportUpdateScript];

    // XXX: In iOS 7, off-screen UIWebViews will fail to render certain image creatives.
    // Specifically, creatives that only contain an <img> tag whose src attribute uses a 302
    // redirect will not be rendered at all. One workaround is to temporarily change the web view's
    // internal contentInset property; this seems to force the web view to re-draw.
    if (ACOffscreenWebViewNeedsRenderingWorkaround()) {
        if ([self.view respondsToSelector:@selector(scrollView)]) {
            UIScrollView *scrollView = self.view.scrollView;
            UIEdgeInsets originalInsets = scrollView.contentInset;
            UIEdgeInsets newInsets = UIEdgeInsetsMake(originalInsets.top + 1,
                                                      originalInsets.left,
                                                      originalInsets.bottom,
                                                      originalInsets.right);
            scrollView.contentInset = newInsets;
            scrollView.contentInset = originalInsets;
        }
    }
}

@end
