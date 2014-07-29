//
//  ACNativeAdError.h
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const AdcashNativeAdsSDKDomain;

typedef enum ACNativeAdErrorCode {
    ACNativeAdErrorUnknown = -1,
    
    ACNativeAdErrorHTTPError = -1000,
    ACNativeAdErrorInvalidServerResponse = -1001,
    ACNativeAdErrorNoInventory = -1002,
    ACNativeAdErrorImageDownloadFailed = -1003,
    
    ACNativeAdErrorContentDisplayError = -1100,
} ACNativeAdErrorCode;

extern NSString *const ACNativeAdErrorContentDisplayErrorReasonKey;
