//
//  ADCError.h
//  adcash-ios-sdk
//
//  Created by Martin on 1/23/15.
//  Copyright (c) 2015 AdCash. All rights reserved.
//
#import <Foundation/Foundation.h>

/**
 Adcash error domain.
 @since 2.0.0
 */
extern NSString *const ADCErrorDomain;



/**
 Error codes for ADCErrorDomain error domain
 @since 2.0.0
 */
typedef NS_ENUM(NSUInteger, ADCErrorCode){
    /**
     @brief  Indicates that there is no ad available to show.
     
     @since 2.0.0
     */
    ADCErrorNoFill,
    
    
    /**
     @brief  Internal error.
     
     @since 2.0.0
     */
    ADCErrorInternalError,
    
    /**
     @brief  The ad request is invalid. Typically this is because the ad
     did not have zoneID or root view controller set.
     
     @since 2.0.0
     */
    ADCErrorInvalidRequest,
};
