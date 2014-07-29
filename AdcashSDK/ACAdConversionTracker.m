//
//  ACAdConversionTracker.m
//  Adcash
//
//  Created by Andrew He on 2/4/11.
//  Copyright (c) 2014, Adcash OU and MoPub Inc.
//

#import "ACAdConversionTracker.h"
#import "ACConstants.h"
#import "ACGlobal.h"
#import "ACLogging.h"
#import "ACIdentityProvider.h"
#import "ACCoreInstanceProvider.h"
#import "ACAdServerURLBuilder.h"

#define ADCASH_CONVERSION_DEFAULTS_KEY @"com.adcash.conversion"

@interface ACAdConversionTracker ()

@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, assign) int statusCode;

- (NSURL *)URLForAppID:(NSString *)appID;

@end

@implementation ACAdConversionTracker

@synthesize responseData = _responseData;
@synthesize statusCode = _statusCode;

+ (ACAdConversionTracker *)sharedConversionTracker
{
    static ACAdConversionTracker *sharedConversionTracker;

    @synchronized(self)
    {
        if (!sharedConversionTracker)
            sharedConversionTracker = [[ACAdConversionTracker alloc] init];
        return sharedConversionTracker;
    }
}

- (void)dealloc
{
    self.responseData = nil;
    [super dealloc];
}

- (void)reportApplicationOpenForApplicationID:(NSString *)appID
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:ADCASH_CONVERSION_DEFAULTS_KEY]) {
        ACLogInfo(@"Tracking conversion");
        NSMutableURLRequest *request = [[ACCoreInstanceProvider sharedProvider] buildConfiguredURLRequestWithURL:[self URLForAppID:appID]];
        self.responseData = [NSMutableData data];
        [NSURLConnection connectionWithRequest:request delegate:self];
    }
}

#pragma mark - <NSURLConnectionDataDelegate>

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.statusCode = [(NSHTTPURLResponse *)response statusCode];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //NOOP
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.statusCode == 200 && [self.responseData length] > 0) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ADCASH_CONVERSION_DEFAULTS_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark -
#pragma mark Internal

- (NSURL *)URLForAppID:(NSString *)appID
{
    // by default firstRun is 1
    NSInteger firstRun = 1;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"firstRun"])
    {
        // if there's a key for first run, means app has already been started
        firstRun = 0;
    }
     
    NSString *path = [NSString stringWithFormat:@"http://%@/open.php?v=%@&udid=%@&id=%@&av=%@&fo=%d",
                      HOSTNAME,
                      AC_SERVER_VERSION,
                      [ACIdentityProvider identifier],
                      appID,
                      [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                      firstRun
                      ];
     
     NSString *bundleName = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     
     path = [path stringByAppendingString:[NSString stringWithFormat:@"&bn=%@", bundleName]];
     
     path = [path stringByAppendingString:[ACAdServerURLBuilder queryParameterForOrientation]];
     path = [path stringByAppendingString:[ACAdServerURLBuilder queryParameterForScaleFactor]];
     path = [path stringByAppendingString:[ACAdServerURLBuilder queryParameterForTimeZone]];
     path = [path stringByAppendingString:[ACAdServerURLBuilder queryParameterForMRAID]];
     path = [path stringByAppendingString:[ACAdServerURLBuilder queryParameterForDNT]];
     path = [path stringByAppendingString:[ACAdServerURLBuilder queryParameterForConnectionType]];
     path = [path stringByAppendingString:[ACAdServerURLBuilder queryParameterForApplicationVersion]];
     path = [path stringByAppendingString:[ACAdServerURLBuilder queryParameterForCarrierName]];
     path = [path stringByAppendingString:[ACAdServerURLBuilder queryParameterForISOCountryCode]];
     path = [path stringByAppendingString:[ACAdServerURLBuilder queryParameterForMobileNetworkCode]];
     path = [path stringByAppendingString:[ACAdServerURLBuilder queryParameterForMobileCountryCode]];
     path = [path stringByAppendingString:[ACAdServerURLBuilder queryParameterForDeviceName]];
     path = [path stringByAppendingString:[ACAdServerURLBuilder queryParameterForTwitterAvailability]];
     
     path = [path stringByAppendingString:@"&sdk=ios"];
     
     NSLog(@"%@", path);

    return [NSURL URLWithString:path];
}
@end
