//
//  ACIdentityProvider.h
//  Adcash
//
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACIdentityProvider : NSObject

+ (NSString *)identifier;
+ (NSString *)obfuscatedIdentifier;
+ (BOOL)advertisingTrackingEnabled;

@end
