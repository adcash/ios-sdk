//
//  ADCSDK.h
//  adcash-ios-sdk
//
//  Created by Martin Marinov on 11/25/15.
//  Copyright © 2015 Adcash. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The ADCSDK is a global singleton that provides information about the Adcash SDK.
 
 @since 2.0.0
 */
@interface ADCSDK : NSObject

/**
 The ADCSDK shared instance.
 
 @return The ADCSDK singleton object.
 
 @since 2.0.0
 
 */
+ (instancetype) sharedInstance;

/**
 The version of the Adcash iOS SDK.
 
 @return The semantic version of the Adcash SDK, returned as string.
 
 @since 2.0.0
 */
- (NSString *)version;

@end
