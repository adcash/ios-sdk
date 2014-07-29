//
//  ACAdWebView.m
//  Adcash
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import "ACAdWebView.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation ACAdWebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= AC_IOS_4_0
        if ([self respondsToSelector:@selector(allowsInlineMediaPlayback)]) {
            [self setAllowsInlineMediaPlayback:YES];
            [self setMediaPlaybackRequiresUserAction:NO];
        }
#endif
    }
    return self;
}

@end
