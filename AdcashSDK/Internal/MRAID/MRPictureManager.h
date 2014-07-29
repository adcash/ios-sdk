//
// Copyright (c) 2013 Adcash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRImageDownloader.h"

@protocol MRPictureManagerDelegate;

@interface MRPictureManager : NSObject <UIAlertViewDelegate, MRImageDownloaderDelegate>

@property (nonatomic, assign) id<MRPictureManagerDelegate> delegate;

- (id)initWithDelegate:(id<MRPictureManagerDelegate>)delegate;
- (void)storePicture:(NSURL *)url;

@end

@protocol MRPictureManagerDelegate <NSObject>

@required
- (void)pictureManager:(MRPictureManager *)manager
        didFailToStorePictureWithErrorMessage:(NSString *)message;

@end