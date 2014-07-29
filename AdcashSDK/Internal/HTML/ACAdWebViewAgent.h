//
//  ACAdWebViewAgent.h
//  Adcash
//
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACAdDestinationDisplayAgent.h"

enum {
    ACAdWebViewEventAdDidAppear     = 0,
    ACAdWebViewEventAdDidDisappear  = 1
};
typedef NSUInteger ACAdWebViewEvent;

@protocol ACAdWebViewAgentDelegate;

@class ACAdConfiguration;
@class ACAdWebView;
@class CLLocation;

@interface ACAdWebViewAgent : NSObject <UIWebViewDelegate, ACAdDestinationDisplayAgentDelegate>

@property (nonatomic, assign) id customMethodDelegate;
@property (nonatomic, retain) ACAdWebView *view;
@property (nonatomic, assign) id<ACAdWebViewAgentDelegate> delegate;

- (id)initWithAdWebViewFrame:(CGRect)frame delegate:(id<ACAdWebViewAgentDelegate>)delegate customMethodDelegate:(id)customMethodDelegate;
- (void)loadConfiguration:(ACAdConfiguration *)configuration;
- (void)rotateToOrientation:(UIInterfaceOrientation)orientation;
- (void)invokeJavaScriptForEvent:(ACAdWebViewEvent)event;
- (void)forceRedraw;

- (void)stopHandlingRequests;
- (void)continueHandlingRequests;

@end

@class ACAdWebView;

@protocol ACAdWebViewAgentDelegate <NSObject>

- (NSString *)adUnitId;
- (CLLocation *)location;
- (UIViewController *)viewControllerForPresentingModalView;
- (void)adDidClose:(ACAdWebView *)ad;
- (void)adDidFinishLoadingAd:(ACAdWebView *)ad;
- (void)adDidFailToLoadAd:(ACAdWebView *)ad;
- (void)adActionWillBegin:(ACAdWebView *)ad;
- (void)adActionWillLeaveApplication:(ACAdWebView *)ad;
- (void)adActionDidFinish:(ACAdWebView *)ad;

@end
