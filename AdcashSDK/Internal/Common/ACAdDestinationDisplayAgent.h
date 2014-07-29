//
//  ACAdDestinationDisplayAgent.h
//  Adcash
//
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACURLResolver.h"
#import "ACProgressOverlayView.h"
#import "ACAdBrowserController.h"
#import "ACStoreKitProvider.h"

@protocol ACAdDestinationDisplayAgentDelegate;

@interface ACAdDestinationDisplayAgent : NSObject <ACURLResolverDelegate, ACProgressOverlayViewDelegate, ACAdBrowserControllerDelegate, ACSKStoreProductViewControllerDelegate>

@property (nonatomic, assign) id<ACAdDestinationDisplayAgentDelegate> delegate;

+ (ACAdDestinationDisplayAgent *)agentWithDelegate:(id<ACAdDestinationDisplayAgentDelegate>)delegate;
- (void)displayDestinationForURL:(NSURL *)URL;
- (void)cancel;

@end

@protocol ACAdDestinationDisplayAgentDelegate <NSObject>

- (UIViewController *)viewControllerForPresentingModalView;
- (void)displayAgentWillPresentModal;
- (void)displayAgentWillLeaveApplication;
- (void)displayAgentDidDismissModal;

@end
