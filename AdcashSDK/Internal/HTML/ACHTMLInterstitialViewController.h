//
//  ACHTMLInterstitialViewController.h
//  Adcash
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ACAdWebViewAgent.h"
#import "ACInterstitialViewController.h"

@class ACAdConfiguration;

@interface ACHTMLInterstitialViewController : ACInterstitialViewController <ACAdWebViewAgentDelegate>

@property (nonatomic, retain) ACAdWebViewAgent *backingViewAgent;
@property (nonatomic, assign) id customMethodDelegate;

- (void)loadConfiguration:(ACAdConfiguration *)configuration;

@end
