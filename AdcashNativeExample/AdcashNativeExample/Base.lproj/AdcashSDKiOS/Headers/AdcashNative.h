//
//  AdcashNative.h
//  adcash-ios-sdk
//
//  Created by Mert on 03/01/17.
//  Copyright © 2017 Adcash. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AdcashNative;

/**
 AdcashNativeDelegate is the delegate class for receiving
 state change events from
 */
@protocol AdcashNativeDelegate <NSObject>

@optional
/**
 @brief Sent when the native ad request has succeeded with response.
 
 @discussion
 When the native ad loaded, you can use this callback to built your native ad view.
 -(void)AdcashNativeAdReceived:(AdcashNative *)native
 {
 //now you have NativeJSON dictionary filled with information of the native ad.
 }
 @since 2.3.0
 */
-(void)AdcashNativeAdReceived:(AdcashNative *)native;

/**
 @brief Sent when the native ad request failed to response.
 Use error parameter to determine what is the cause. Usually this is because there is no
 internet connectivity or there are no ads to serve.
 @since 2.3.0
 */
-(void)AdcashNativeFailedToReceiveAd:(AdcashNative *)native withError:(NSError *)error;

@end


/**
 Class to request a Native Ad.
 */
@interface AdcashNative : NSObject


/**
 An object that comforms to the AdcashNativeDelegate and can receive callbacks for native
 ad request states. May be nil.
 */
@property(nonatomic, strong) id <AdcashNativeDelegate> delegate;

/**
 This is the designated initializer for the AdcashNative class.
 @return An initialized AdcashNative instance.
 @since 2.3.0
 */
-(instancetype)initAdcashNativeWithZoneID:(NSString *)zoneID;

/**
 Get functions for fetched values.
 */
-(NSURL *)getAdImageURL;
-(NSURL *)getAdIconURL;
-(NSString *)getAdDescription;
-(NSString *)getAdTitle;
-(NSString *)getAdRating;
-(NSString *)getAdRatingPc;
-(NSString *)getAdButtonText;
-(void)openClick;
-(void)trackImpression;
@end

