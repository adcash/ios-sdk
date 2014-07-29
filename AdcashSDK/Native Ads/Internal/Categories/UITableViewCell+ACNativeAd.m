//
//  UITableViewCell+ACNativeAd.m
//  Copyright (c) 2014 Adcash. All rights reserved.
//

#import "UITableViewCell+ACNativeAd.h"
#import <objc/runtime.h>

static char ACNativeAdKey;

@implementation UITableViewCell (ACNativeAd)

- (void)mp_removeNativeAd
{
    [self mp_setNativeAd:nil];
}

- (void)mp_setNativeAd:(ACNativeAd *)adObject
{
    objc_setAssociatedObject(self, &ACNativeAdKey, adObject, OBJC_ASSOCIATION_ASSIGN);
}

- (ACNativeAd *)mp_nativeAd
{
    return (ACNativeAd *)objc_getAssociatedObject(self, &ACNativeAdKey);
}

@end
