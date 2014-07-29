//
//  ACAdServerCommunicator.h
//  Adcash
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ACAdConfiguration.h"
#import "ACGlobal.h"

@protocol ACAdServerCommunicatorDelegate;

////////////////////////////////////////////////////////////////////////////////////////////////////

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= AC_IOS_5_0
@interface ACAdServerCommunicator : NSObject <NSURLConnectionDataDelegate>
#else
@interface ACAdServerCommunicator : NSObject
#endif

@property (nonatomic, assign) id<ACAdServerCommunicatorDelegate> delegate;
@property (nonatomic, assign, readonly) BOOL loading;

- (id)initWithDelegate:(id<ACAdServerCommunicatorDelegate>)delegate;

- (void)loadURL:(NSURL *)URL;
- (void)cancel;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@protocol ACAdServerCommunicatorDelegate <NSObject>

@required
- (void)communicatorDidReceiveAdConfiguration:(ACAdConfiguration *)configuration;
- (void)communicatorDidFailWithError:(NSError *)error;

@end
