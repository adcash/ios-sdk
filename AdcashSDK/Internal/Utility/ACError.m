//
//  ACAdRequestError.m
//  Adcash
//
//  Copyright (c) 2012 Adcash. All rights reserved.
//

#import "ACError.h"

NSString * const kACErrorDomain = @"com.adcash.iossdk";

@implementation ACError

+ (ACError *)errorWithCode:(ACErrorCode)code
{
    return [self errorWithDomain:kACErrorDomain code:code userInfo:nil];
}

@end
