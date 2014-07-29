//
//  ACImageDownloadQueue.h
// 
//  Copyright (c) 2014 Adcash. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ACImageDownloadQueueCompletionBlock)(NSArray *errors);

@interface ACImageDownloadQueue : NSObject

// pass useCachedImage:NO to force download of images. default is YES, cached images will not be re-downloaded
- (void)addDownloadImageURLs:(NSArray *)imageURLs completionBlock:(ACImageDownloadQueueCompletionBlock)completionBlock;
- (void)addDownloadImageURLs:(NSArray *)imageURLs completionBlock:(ACImageDownloadQueueCompletionBlock)completionBlock useCachedImage:(BOOL)useCachedImage;

- (void)cancelAllDownloads;

@end
