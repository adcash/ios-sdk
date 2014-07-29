//
//  ACSessionTracker.m
//  Adcash
//
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import "ACSessionTracker.h"
#import "ACConstants.h"
#import "ACIdentityProvider.h"
#import "ACGlobal.h"
#import "ACCoreInstanceProvider.h"

@implementation ACSessionTracker

+ (void)load
{
    if (SESSION_TRACKING_ENABLED) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(trackEvent)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(trackEvent)
                                                     name:UIApplicationDidFinishLaunchingNotification
                                                   object:nil];
    }
}

+ (void)trackEvent
{
    [NSURLConnection connectionWithRequest:[[ACCoreInstanceProvider sharedProvider] buildConfiguredURLRequestWithURL:[self URL]]
                                  delegate:nil];
}

+ (NSURL *)URL
{
    NSString *path = [NSString stringWithFormat:@"http://%@/open.php?v=%@&udid=%@&id=%@&av=%@&st=1&sdk=ios",
                      HOSTNAME,
                      AC_SERVER_VERSION,
                      [ACIdentityProvider identifier],
                      [[[NSBundle mainBundle] bundleIdentifier] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                      [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                      ];

    return [NSURL URLWithString:path];
}

@end
