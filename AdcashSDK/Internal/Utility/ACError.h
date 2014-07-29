//
//  ACAdRequestError.h
//  Adcash
//
//  Copyright (c) 2012 Adcash. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kACErrorDomain;

typedef enum {
    ACErrorNoInventory = 0,
    ACErrorNetworkTimedOut = 4,
    ACErrorServerError = 8,
    ACErrorAdapterNotFound = 16,
    ACErrorAdapterInvalid = 17,
    ACErrorAdapterHasNoInventory = 18
} ACErrorCode;

@interface ACError : NSError

+ (ACError *)errorWithCode:(ACErrorCode)code;

@end
