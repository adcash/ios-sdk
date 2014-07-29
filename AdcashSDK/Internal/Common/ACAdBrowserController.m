//
//  ACAdBrowserController.m
//  Adcash
//
//  Created by Nafis Jamal on 1/19/11.
//  Copyright (c) 2014, Adcash OU and MoPub Inc.
//

#import "ACAdBrowserController.h"
#import "ACLogging.h"
#import "ACGlobal.h"

@interface ACAdBrowserController ()

@property (nonatomic, retain) UIActionSheet *actionSheet;
@property (nonatomic, retain) NSString *HTMLString;
@property (nonatomic, assign) int webViewLoadCount;

- (void)dismissActionSheet;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation ACAdBrowserController

@synthesize webView = _webView;
@synthesize backButton = _backButton;
@synthesize forwardButton = _forwardButton;
@synthesize refreshButton = _refreshButton;
@synthesize safariButton = _safariButton;
@synthesize doneButton = _doneButton;
@synthesize spinnerItem = _spinnerItem;
@synthesize spinner = _spinner;
@synthesize actionSheet = _actionSheet;
@synthesize delegate = _delegate;
@synthesize URL = _URL;
@synthesize webViewLoadCount = _webViewLoadCount;
@synthesize HTMLString = _HTMLString;

#pragma mark -
#pragma mark Lifecycle

- (id)initWithURL:(NSURL *)URL HTMLString:(NSString *)HTMLString delegate:(id<ACAdBrowserControllerDelegate>)delegate
{
    if (self = [super initWithNibName:@"ACAdBrowserController" bundle:nil])
    {
        self.delegate = delegate;
        self.URL = URL;
        self.HTMLString = HTMLString;

        ACLogDebug(@"Ad browser (%p) initialized with URL: %@", self, self.URL);

        self.webView = [[[UIWebView alloc] initWithFrame:CGRectZero] autorelease];
        self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight;
        self.webView.delegate = self;
        self.webView.scalesPageToFit = YES;

        self.spinner = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectZero] autorelease];
        [self.spinner sizeToFit];
        self.spinner.hidesWhenStopped = YES;

        self.webViewLoadCount = 0;
    }
    return self;
}

- (void)dealloc
{
    self.HTMLString = nil;
    self.delegate = nil;
    self.webView.delegate = nil;
    self.webView = nil;
    self.URL = nil;
    self.backButton = nil;
    self.forwardButton = nil;
    self.refreshButton = nil;
    self.safariButton = nil;
    self.doneButton = nil;
    self.spinner = nil;
    self.spinnerItem = nil;
    self.actionSheet = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Set up toolbar buttons
    self.backButton.image = [self backArrowImage];
    self.backButton.title = nil;
    self.forwardButton.image = [self forwardArrowImage];
    self.forwardButton.title = nil;
    self.spinnerItem.customView = self.spinner;
    self.spinnerItem.title = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // Set button enabled status.
    self.backButton.enabled = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;
    self.refreshButton.enabled = NO;
    self.safariButton.enabled = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.webView loadHTMLString:self.HTMLString baseURL:self.URL];
//     NSString *currentURL = [self.webView stringByEvaluatingJavaScriptFromString:@"window.location"];
     ACLogDebug(@"Webview loaded HTML string %@ with baseURL [%@]", self.HTMLString, self.URL);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.webView stopLoading];
    [super viewWillDisappear:animated];
}

#pragma mark - Hidding status bar (iOS 7 and above)

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark -
#pragma mark Navigation

- (IBAction)refresh
{
    [self dismissActionSheet];
    [self.webView reload];
}

- (IBAction)done
{
    [self dismissActionSheet];
    if (self.delegate) {
        [self.delegate dismissBrowserController:self animated:AC_ANIMATED];
    } else {
        [self dismissViewControllerAnimated:AC_ANIMATED completion:nil];
    }
}

- (IBAction)back
{
    [self dismissActionSheet];
    [self.webView goBack];
    self.backButton.enabled = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;
}

- (IBAction)forward
{
    [self dismissActionSheet];
    [self.webView goForward];
    self.backButton.enabled = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;
}

- (IBAction)safari
{
    if (self.actionSheet)
    {
        [self dismissActionSheet];
    }
    else
    {
        self.actionSheet = [[[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Open in Safari", nil] autorelease];

        if ([UIActionSheet instancesRespondToSelector:@selector(showFromBarButtonItem:animated:)]) {
            [self.actionSheet showFromBarButtonItem:self.safariButton animated:YES];
        } else {
            [self.actionSheet showInView:self.webView];
        }
    }
}

- (void)dismissActionSheet
{
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];

}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.actionSheet = nil;
    if (buttonIndex == 0)
    {
        // Open in Safari.
        [[UIApplication sharedApplication] openURL:self.URL];
    }
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    ACLogDebug(@"Ad browser (%p) starting to load URL: %@", self, request.URL);
    self.URL = request.URL;
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.refreshButton.enabled = YES;
    self.safariButton.enabled = YES;
    [self.spinner startAnimating];

    self.webViewLoadCount++;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.webViewLoadCount--;
    if (self.webViewLoadCount > 0) return;

    self.refreshButton.enabled = YES;
    self.safariButton.enabled = YES;
    self.backButton.enabled = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;
    [self.spinner stopAnimating];
     ACLogDebug(@"Ad browser (%p) loaded URL: %@", self, self.URL);

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.webViewLoadCount--;

    self.refreshButton.enabled = YES;
    self.safariButton.enabled = YES;
    self.backButton.enabled = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;
    [self.spinner stopAnimating];

    // Ignore NSURLErrorDomain error (-999).
    if (error.code == NSURLErrorCancelled) return;

    // Ignore "Frame Load Interrupted" errors after navigating to iTunes or the App Store.
    if (error.code == 102 && [error.domain isEqual:@"WebKitErrorDomain"]) return;

    ACLogError(@"Ad browser (%p) experienced an error: %@ when loading URL %@", self, [error localizedDescription], self.URL);
}

#pragma mark -
#pragma mark Drawing

- (CGContextRef)createContext
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(nil,27,27,8,0,
                                                 colorSpace,(CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CFRelease(colorSpace);
    return context;
}

- (UIImage *)backArrowImage
{
    CGContextRef context = [self createContext];
    CGColorRef fillColor = [[UIColor blackColor] CGColor];
    CGContextSetFillColor(context, CGColorGetComponents(fillColor));

    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 8.0f, 13.0f);
    CGContextAddLineToPoint(context, 24.0f, 4.0f);
    CGContextAddLineToPoint(context, 24.0f, 22.0f);
    CGContextClosePath(context);
    CGContextFillPath(context);

    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);

    UIImage *image = [[UIImage alloc] initWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return [image autorelease];
}

- (UIImage *)forwardArrowImage
{
    CGContextRef context = [self createContext];
    CGColorRef fillColor = [[UIColor blackColor] CGColor];
    CGContextSetFillColor(context, CGColorGetComponents(fillColor));

    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 24.0f, 13.0f);
    CGContextAddLineToPoint(context, 8.0f, 4.0f);
    CGContextAddLineToPoint(context, 8.0f, 22.0f);
    CGContextClosePath(context);
    CGContextFillPath(context);

    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);

    UIImage *image = [[UIImage alloc] initWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return [image autorelease];
}

#pragma mark -

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
