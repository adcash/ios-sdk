//
//  ACAdDestinationDisplayAgent.m
//  Adcash
//
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import "ACAdDestinationDisplayAgent.h"
#import "UIViewController+ACAdditions.h"
#import "ACCoreInstanceProvider.h"
#import "ACLastResortDelegate.h"
#import "NSURL+ACAdditions.h"

@interface ACAdDestinationDisplayAgent ()

@property (nonatomic, retain) ACURLResolver *resolver;
@property (nonatomic, retain) ACProgressOverlayView *overlayView;
@property (nonatomic, assign) BOOL isLoadingDestination;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= AC_IOS_6_0
@property (nonatomic, retain) SKStoreProductViewController *storeKitController;
#endif

@property (nonatomic, retain) ACAdBrowserController *browserController;
@property (nonatomic, retain) ACTelephoneConfirmationController *telephoneConfirmationController;

- (void)presentStoreKitControllerWithItemIdentifier:(NSString *)identifier fallbackURL:(NSURL *)URL;
- (void)hideOverlay;
- (void)hideModalAndNotifyDelegate;
- (void)dismissAllModalContent;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation ACAdDestinationDisplayAgent

@synthesize delegate = _delegate;
@synthesize resolver = _resolver;
@synthesize isLoadingDestination = _isLoadingDestination;

+ (ACAdDestinationDisplayAgent *)agentWithDelegate:(id<ACAdDestinationDisplayAgentDelegate>)delegate
{
    ACAdDestinationDisplayAgent *agent = [[[ACAdDestinationDisplayAgent alloc] init] autorelease];
    agent.delegate = delegate;
    agent.resolver = [[ACCoreInstanceProvider sharedProvider] buildACURLResolver];
    agent.overlayView = [[[ACProgressOverlayView alloc] initWithDelegate:agent] autorelease];
    return agent;
}

- (void)dealloc
{
    [self dismissAllModalContent];

    self.telephoneConfirmationController = nil;
    self.overlayView.delegate = nil;
    self.overlayView = nil;
    self.resolver.delegate = nil;
    self.resolver = nil;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= AC_IOS_6_0
    // XXX: If this display agent is deallocated while a StoreKit controller is still on-screen,
    // nil-ing out the controller's delegate would leave us with no way to dismiss the controller
    // in the future. Therefore, we change the controller's delegate to a singleton object which
    // implements SKStoreProductViewControllerDelegate and is always around.
    self.storeKitController.delegate = [ACLastResortDelegate sharedDelegate];
    self.storeKitController = nil;
#endif
    self.browserController.delegate = nil;
    self.browserController = nil;

    [super dealloc];
}

- (void)dismissAllModalContent
{
    [self.overlayView hide];
}

- (void)displayDestinationForURL:(NSURL *)URL
{
    if (self.isLoadingDestination) return;
    self.isLoadingDestination = YES;

    [self.delegate displayAgentWillPresentModal];
    [self.overlayView show];

    [self.resolver startResolvingWithURL:URL delegate:self];
}

- (void)cancel
{
    if (self.isLoadingDestination) {
        self.isLoadingDestination = NO;
        [self.resolver cancel];
        [self hideOverlay];
        [self.delegate displayAgentDidDismissModal];
    }
}

#pragma mark - <ACURLResolverDelegate>

- (void)showWebViewWithHTMLString:(NSString *)HTMLString baseURL:(NSURL *)URL
{
    [self hideOverlay];

    self.browserController = [[[ACAdBrowserController alloc] initWithURL:URL
                                                              HTMLString:HTMLString
                                                                delegate:self] autorelease];
    self.browserController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [[self.delegate viewControllerForPresentingModalView] mp_presentModalViewController:self.browserController
                                                                               animated:AC_ANIMATED];
}

- (void)showStoreKitProductWithParameter:(NSString *)parameter fallbackURL:(NSURL *)URL
{
    if ([ACStoreKitProvider deviceHasStoreKit]) {
        [self presentStoreKitControllerWithItemIdentifier:parameter fallbackURL:URL];
    } else {
        [self openURLInApplication:URL];
    }
}

- (void)openURLInApplication:(NSURL *)URL
{
    [self hideOverlay];

    if ([URL mp_hasTelephoneScheme] || [URL mp_hasTelephonePromptScheme]) {
        [self interceptTelephoneURL:URL];
    } else {
        [self.delegate displayAgentWillLeaveApplication];
        [[UIApplication sharedApplication] openURL:URL];
        self.isLoadingDestination = NO;
    }
}

- (void)interceptTelephoneURL:(NSURL *)URL
{
    __block ACAdDestinationDisplayAgent *blockSelf = self;
    self.telephoneConfirmationController = [[[ACTelephoneConfirmationController alloc] initWithURL:URL clickHandler:^(NSURL *targetTelephoneURL, BOOL confirmed) {
        if (confirmed) {
            [blockSelf.delegate displayAgentWillLeaveApplication];
            [[UIApplication sharedApplication] openURL:targetTelephoneURL];
        }
        blockSelf.isLoadingDestination = NO;
        [blockSelf.delegate displayAgentDidDismissModal];
    }] autorelease];

    [self.telephoneConfirmationController show];
}

- (void)failedToResolveURLWithError:(NSError *)error
{
    self.isLoadingDestination = NO;
    [self hideOverlay];
    [self.delegate displayAgentDidDismissModal];
}

- (void)presentStoreKitControllerWithItemIdentifier:(NSString *)identifier fallbackURL:(NSURL *)URL
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= AC_IOS_6_0
    self.storeKitController = [ACStoreKitProvider buildController];
    self.storeKitController.delegate = self;

    NSDictionary *parameters = [NSDictionary dictionaryWithObject:identifier
                                                           forKey:SKStoreProductParameterITunesItemIdentifier];
    [self.storeKitController loadProductWithParameters:parameters completionBlock:nil];

    [self hideOverlay];
    [[self.delegate viewControllerForPresentingModalView] mp_presentModalViewController:self.storeKitController
                                                                               animated:AC_ANIMATED];
#endif
}

#pragma mark - <ACSKStoreProductViewControllerDelegate>
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    self.isLoadingDestination = NO;
    [self hideModalAndNotifyDelegate];
}

#pragma mark - <ACAdBrowserControllerDelegate>
- (void)dismissBrowserController:(ACAdBrowserController *)browserController animated:(BOOL)animated
{
    self.isLoadingDestination = NO;
    [self hideModalAndNotifyDelegate];
}

#pragma mark - <ACProgressOverlayViewDelegate>
- (void)overlayCancelButtonPressed
{
    [self cancel];
}

#pragma mark - Convenience Methods
- (void)hideModalAndNotifyDelegate
{
    [[self.delegate viewControllerForPresentingModalView] mp_dismissModalViewControllerAnimated:AC_ANIMATED];
    [self.delegate displayAgentDidDismissModal];
}

- (void)hideOverlay
{
    [self.overlayView hide];
}

@end
