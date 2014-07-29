//
//  ACNativeAdRendering.h
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ACNativeAd.h"

/**
 * The ACNativeAdRendering protocol provides methods for displaying ad content in
 * custom view classes.
 */

@protocol ACNativeAdRendering <NSObject>

/**
 * Populates a view's relevant subviews with ad content.
 *
 * Your implementation of this method should call one or more of the methods listed below.
 *
 * @param adObject An object containing ad assets (text, images) which may be loaded
 * into appropriate subviews (UILabel, UIImageView) via convenience methods.
 * @see [ACNativeAd loadTextIntoLabel:]
 * @see [ACNativeAd loadTitleIntoLabel:]
 * @see [ACNativeAd loadIconIntoImageView:]
 * @see [ACNativeAd loadImageIntoImageView:]
 * @see [ACNativeAd loadCallToActionTextIntoLabel:]
 * @see [ACNativeAd loadCallToActionTextIntoButton:]
 * @see [ACNativeAd loadImageForURL:intoImageView:]
 */
- (void)layoutAdAssets:(ACNativeAd *)adObject;

@end
