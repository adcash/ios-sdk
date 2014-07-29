//
//  ACNativeCustomEvent.m
//  Copyright (c) 2014 Adcash. All rights reserved.
//

#import "ACNativeCustomEvent.h"
#import "ACNativeAdError.h"
#import "ACImageDownloadQueue.h"
#import "ACLogging.h"

@interface ACNativeCustomEvent ()

@property (nonatomic, retain) ACImageDownloadQueue *imageDownloadQueue;

@end

@implementation ACNativeCustomEvent

- (id)init
{
    self = [super init];
    if (self) {
        _imageDownloadQueue = [[ACImageDownloadQueue alloc] init];
    }

    return self;
}

- (void)dealloc
{
    [_imageDownloadQueue release];

    [super dealloc];
}

- (void)precacheImagesWithURLs:(NSArray *)imageURLs completionBlock:(void (^)(NSArray *errors))completionBlock
{
    if (imageURLs.count > 0) {
        [_imageDownloadQueue addDownloadImageURLs:imageURLs completionBlock:^(NSArray *errors) {
            if (completionBlock) {
                completionBlock(errors);
            }
        }];
    }
    else {
        if (completionBlock) {
            completionBlock(nil);
        }
    }
}

- (void)requestAdWithCustomEventInfo:(NSDictionary *)info
{
    /*override with custom network behavior*/
}

@end
