//
//  MRBundleManager.h
//  Adcash
//
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRBundleManager : NSObject

+ (MRBundleManager *)sharedManager;
- (NSString *)mraidPath;

@end
