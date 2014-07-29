//
//  ACLastResortDelegate.h
//  Adcash
//
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface ACLastResortDelegate : NSObject
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
<SKStoreProductViewControllerDelegate>
#endif

+ (id)sharedDelegate;

@end
