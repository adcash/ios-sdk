//
//  ACAdServerURLBuilder.h
//  Adcash
//
//  Copyright (c) 2012 Adcash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ACAdServerURLBuilder : NSObject

+ (NSURL *)URLWithAdUnitID:(NSString *)adUnitID
                  keywords:(NSString *)keywords
                  location:(CLLocation *)location
                   testing:(BOOL)testing;

+ (NSURL *)URLWithAdUnitID:(NSString *)adUnitID
                  keywords:(NSString *)keywords
                  location:(CLLocation *)location
      versionParameterName:(NSString *)versionParameterName
                   version:(NSString *)version
                   testing:(BOOL)testing
             desiredAssets:(NSArray *)assets;

+ (NSString *)queryParameterForKeywords:(NSString *)keywords;
+ (NSString *)queryParameterForOrientation;
+ (NSString *)queryParameterForScaleFactor;
+ (NSString *)queryParameterForTimeZone;
+ (NSString *)queryParameterForLocation:(CLLocation *)location;
+ (NSString *)queryParameterForMRAID;
+ (NSString *)queryParameterForDNT;
+ (NSString *)queryParameterForConnectionType;
+ (NSString *)queryParameterForApplicationVersion;
+ (NSString *)queryParameterForCarrierName;
+ (NSString *)queryParameterForISOCountryCode;
+ (NSString *)queryParameterForMobileNetworkCode;
+ (NSString *)queryParameterForMobileCountryCode;
+ (NSString *)queryParameterForDeviceName;
+ (NSString *)queryParameterForTwitterAvailability;

@end
