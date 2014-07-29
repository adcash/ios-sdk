//
//  ACFeatureDetector.h
//  Adcash
//
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACGlobal.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= AC_IOS_6_0
#import <StoreKit/StoreKit.h>
#endif

@class SKStoreProductViewController;

@interface ACStoreKitProvider : NSObject

+ (BOOL)deviceHasStoreKit;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= AC_IOS_6_0
+ (SKStoreProductViewController *)buildController;
#endif

@end

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= AC_IOS_6_0
@protocol ACSKStoreProductViewControllerDelegate <SKStoreProductViewControllerDelegate>
#else
@protocol ACSKStoreProductViewControllerDelegate
#endif
@end
