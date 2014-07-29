//
//  ACHTMLBannerCustomEvent.h
//  Adcash
//
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import "ACBannerCustomEvent.h"
#import "ACAdWebViewAgent.h"
#import "ACPrivateBannerCustomEventDelegate.h"

@interface ACHTMLBannerCustomEvent : ACBannerCustomEvent <ACAdWebViewAgentDelegate>

@property (nonatomic, assign) id<ACPrivateBannerCustomEventDelegate> delegate;

@end
