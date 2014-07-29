//
//  ACAdServerCommunicator.m
//  Adcash
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import "ACAdServerCommunicator.h"

#import "ACAdConfiguration.h"
#import "ACLogging.h"
#import "ACCoreInstanceProvider.h"

const NSTimeInterval kRequestTimeoutInterval = 10.0;

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface ACAdServerCommunicator ()

@property (nonatomic, assign, readwrite) BOOL loading;
@property (nonatomic, copy) NSURL *URL;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) NSDictionary *responseHeaders;

- (NSError *)errorForStatusCode:(NSInteger)statusCode;
- (NSURLRequest *)adRequestForURL:(NSURL *)URL;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation ACAdServerCommunicator

@synthesize delegate = _delegate;
@synthesize URL = _URL;
@synthesize connection = _connection;
@synthesize responseData = _responseData;
@synthesize responseHeaders = _responseHeaders;
@synthesize loading = _loading;

- (id)initWithDelegate:(id<ACAdServerCommunicatorDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)dealloc
{
    self.URL = nil;
    [self.connection cancel];
    self.connection = nil;
    self.responseData = nil;
    self.responseHeaders = nil;

    [super dealloc];
}

#pragma mark - Public

- (void)loadURL:(NSURL *)URL
{
    [self cancel];
    self.URL = URL;
    self.connection = [NSURLConnection connectionWithRequest:[self adRequestForURL:URL]
                                                    delegate:self];
    self.loading = YES;
}

- (void)cancel
{
    self.loading = NO;
    [self.connection cancel];
    self.connection = nil;
    self.responseData = nil;
    self.responseHeaders = nil;
}

#pragma mark - NSURLConnection delegate (NSURLConnectionDataDelegate in iOS 5.0+)

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if ([response respondsToSelector:@selector(statusCode)]) {
        int statusCode = [(NSHTTPURLResponse *)response statusCode];
        if (statusCode >= 400) {
            [connection cancel];
            self.loading = NO;
            [self.delegate communicatorDidFailWithError:[self errorForStatusCode:statusCode]];
            return;
        }
    }

    self.responseData = [NSMutableData data];
    self.responseHeaders = [(NSHTTPURLResponse *)response allHeaderFields];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.loading = NO;
    [self.delegate communicatorDidFailWithError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    ACAdConfiguration *configuration = [[[ACAdConfiguration alloc]
                                         initWithHeaders:self.responseHeaders
                                         data:self.responseData] autorelease];
    self.loading = NO;
    [self.delegate communicatorDidReceiveAdConfiguration:configuration];
}

#pragma mark - Internal

- (NSError *)errorForStatusCode:(NSInteger)statusCode
{
    NSString *errorMessage = [NSString stringWithFormat:
                              NSLocalizedString(@"Adcash returned status code %d.",
                                                @"Status code error"),
                              statusCode];
    NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:errorMessage
                                                          forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:@"adcash.com" code:statusCode userInfo:errorInfo];
}

- (NSURLRequest *)adRequestForURL:(NSURL *)URL
{
    NSMutableURLRequest *request = [[ACCoreInstanceProvider sharedProvider] buildConfiguredURLRequestWithURL:URL];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval:kRequestTimeoutInterval];
    return request;
}

@end
