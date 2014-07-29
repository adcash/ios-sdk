//
//  MRBundleManager.m
//  Adcash
//
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import "MRBundleManager.h"

@implementation MRBundleManager

static MRBundleManager *sharedManager = nil;

+ (MRBundleManager *)sharedManager
{
    if (!sharedManager) {
        sharedManager = [[MRBundleManager alloc] init];
    }
    return sharedManager;
}

- (NSString *)mraidPath
{
    NSString *mraidBundlePath = [[NSBundle mainBundle] pathForResource:@"MRAID" ofType:@"bundle"];
    NSBundle *mraidBundle = [NSBundle bundleWithPath:mraidBundlePath];
    return [mraidBundle pathForResource:@"mraid" ofType:@"js"];
}

@end

