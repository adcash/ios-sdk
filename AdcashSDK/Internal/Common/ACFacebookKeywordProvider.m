//
//  ACFacebookAttributionIdProvider.m
//  Adcash
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import "ACFacebookKeywordProvider.h"
#import <UIKit/UIKit.h>

static NSString *kFacebookAttributionIdPasteboardKey = @"fb_app_attribution";
static NSString *kFacebookAttributionIdPrefix = @"FBATTRID:";

@implementation ACFacebookKeywordProvider

#pragma mark - ACKeywordProvider

+ (NSString *)keyword {
    NSString *facebookAttributionId = [[UIPasteboard pasteboardWithName:kFacebookAttributionIdPasteboardKey
                                                                 create:NO] string];
    if (!facebookAttributionId) {
        return nil;
    }

    return [NSString stringWithFormat:@"%@%@", kFacebookAttributionIdPrefix, facebookAttributionId];
}

@end
