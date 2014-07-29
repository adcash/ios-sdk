//
//  ACLastResortDelegate.m
//  Adcash
//
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import "ACLastResortDelegate.h"
#import "ACGlobal.h"
#import "UIViewController+ACAdditions.h"

@class MFMailComposeViewController;

@implementation ACLastResortDelegate

+ (id)sharedDelegate
{
    static ACLastResortDelegate *lastResortDelegate;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        lastResortDelegate = [[self alloc] init];
    });
    return lastResortDelegate;
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(NSInteger)result error:(NSError*)error
{
    [controller mp_dismissModalViewControllerAnimated:AC_ANIMATED];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController mp_dismissModalViewControllerAnimated:AC_ANIMATED];
}
#endif

@end
