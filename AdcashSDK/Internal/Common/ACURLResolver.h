//
//  ACURLResolver.h
//  Adcash
//
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACGlobal.h"

@protocol ACURLResolverDelegate;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= AC_IOS_5_0
@interface ACURLResolver : NSObject <NSURLConnectionDataDelegate>
#else
@interface ACURLResolver : NSObject
#endif

@property (nonatomic, assign) id<ACURLResolverDelegate> delegate;

+ (ACURLResolver *)resolver;
- (void)startResolvingWithURL:(NSURL *)URL delegate:(id<ACURLResolverDelegate>)delegate;
- (void)cancel;

@end

@protocol ACURLResolverDelegate <NSObject>

- (void)showWebViewWithHTMLString:(NSString *)HTMLString baseURL:(NSURL *)URL;
- (void)showStoreKitProductWithParameter:(NSString *)parameter fallbackURL:(NSURL *)URL;
- (void)openURLInApplication:(NSURL *)URL;
- (void)failedToResolveURLWithError:(NSError *)error;

@end
