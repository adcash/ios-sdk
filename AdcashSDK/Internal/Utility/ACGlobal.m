//
//  ACGlobal.m
//  Adcash
//
//  Created by Andrew He on 5/5/11.
//  Copyright (c) 2014, Adcash OU and MoPub Inc.
//

#import "ACGlobal.h"
#import "ACConstants.h"
#import "ACLogging.h"
#import "NSURL+ACAdditions.h"
#import <CommonCrypto/CommonDigest.h>

#import <sys/types.h>
#import <sys/sysctl.h>

BOOL ACViewHasHiddenAncestor(UIView *view);
BOOL ACViewIsDescendantOfKeyWindow(UIView *view);
BOOL ACViewIntersectsKeyWindow(UIView *view);
NSString *ACSHA1Digest(NSString *string);

UIInterfaceOrientation ACInterfaceOrientation()
{
    return [UIApplication sharedApplication].statusBarOrientation;
}

UIWindow *ACKeyWindow()
{
    return [UIApplication sharedApplication].keyWindow;
}

CGFloat ACStatusBarHeight() {
    if ([UIApplication sharedApplication].statusBarHidden) return 0.0;

    UIInterfaceOrientation orientation = ACInterfaceOrientation();

    return UIInterfaceOrientationIsLandscape(orientation) ?
        CGRectGetWidth([UIApplication sharedApplication].statusBarFrame) :
        CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
}

CGRect ACApplicationFrame()
{
    CGRect frame = ACScreenBounds();

    frame.origin.y += ACStatusBarHeight();
    frame.size.height -= ACStatusBarHeight();

    return frame;
}

CGRect ACScreenBounds()
{
    CGRect bounds = [UIScreen mainScreen].bounds;

    if (UIInterfaceOrientationIsLandscape(ACInterfaceOrientation()))
    {
        CGFloat width = bounds.size.width;
        bounds.size.width = bounds.size.height;
        bounds.size.height = width;
    }

    return bounds;
}

CGFloat ACDeviceScaleFactor()
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        [[UIScreen mainScreen] respondsToSelector:@selector(scale)])
    {
        return [[UIScreen mainScreen] scale];
    }
    else return 1.0;
}

NSDictionary *ACDictionaryFromQueryString(NSString *query) {
    NSMutableDictionary *queryDict = [NSMutableDictionary dictionary];
    NSArray *queryElements = [query componentsSeparatedByString:@"&"];
    for (NSString *element in queryElements) {
        NSArray *keyVal = [element componentsSeparatedByString:@"="];
        NSString *key = [keyVal objectAtIndex:0];
        NSString *value = [keyVal lastObject];
        [queryDict setObject:[value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                      forKey:key];
    }
    return queryDict;
}

NSString *ACSHA1Digest(NSString *string)
{
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    NSData *data = [string dataUsingEncoding:NSASCIIStringEncoding];
    CC_SHA1([data bytes], [data length], digest);

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}

BOOL ACViewIsVisible(UIView *view)
{
    // In order for a view to be visible, it:
    // 1) must not be hidden,
    // 2) must not have an ancestor that is hidden,
    // 3) must be a descendant of the key window, and
    // 4) must be within the frame of the key window.
    //
    // Note: this function does not check whether any part of the view is obscured by another view.

    return (!view.hidden &&
            !ACViewHasHiddenAncestor(view) &&
            ACViewIsDescendantOfKeyWindow(view) &&
            ACViewIntersectsKeyWindow(view));
}

BOOL ACViewHasHiddenAncestor(UIView *view)
{
    UIView *ancestor = view.superview;
    while (ancestor) {
        if (ancestor.hidden) return YES;
        ancestor = ancestor.superview;
    }
    return NO;
}

BOOL ACViewIsDescendantOfKeyWindow(UIView *view)
{
    UIView *ancestor = view.superview;
    UIWindow *keyWindow = ACKeyWindow();
    while (ancestor) {
        if (ancestor == keyWindow) return YES;
        ancestor = ancestor.superview;
    }
    return NO;
}

BOOL ACViewIntersectsKeyWindow(UIView *view)
{
    UIWindow *keyWindow = ACKeyWindow();

    // We need to call convertRect:toView: on this view's superview rather than on this view itself.
    CGRect viewFrameInWindowCoordinates = [view.superview convertRect:view.frame toView:keyWindow];

    return CGRectIntersectsRect(viewFrameInWindowCoordinates, keyWindow.frame);
}

////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation NSString (ACAdditions)

- (NSString *)URLEncodedString
{
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                           (CFStringRef)self,
                                                                           NULL,
                                                                           (CFStringRef)@"!*'();:@&=+$,/?%#[]<>",
                                                                           kCFStringEncodingUTF8);
    return [result autorelease];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation UIDevice (ACAdditions)

- (NSString *)hardwareDeviceName
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface ACTelephoneConfirmationController ()

@property (nonatomic, retain) UIAlertView *alertView;
@property (nonatomic, retain) NSURL *telephoneURL;
@property (nonatomic, copy) ACTelephoneConfirmationControllerClickHandler clickHandler;

@end

@implementation ACTelephoneConfirmationController

- (id)initWithURL:(NSURL *)url clickHandler:(ACTelephoneConfirmationControllerClickHandler)clickHandler
{
    if (![url mp_hasTelephoneScheme] && ![url mp_hasTelephonePromptScheme]) {
        // Shouldn't be here as the url must have a tel or telPrompt scheme.
        ACLogError(@"Processing URL as a telephone URL when %@ doesn't follow the tel:// or telprompt:// schemes", url.absoluteString);
        [self release];
        return nil;
    }

    if (self = [super init]) {
        // If using tel://xxxxxxx, the host will be the number.  If using tel:xxxxxxx, we will try the resourceIdentifier.
        NSString *phoneNumber = [url host];

        if (!phoneNumber) {
            phoneNumber = [url resourceSpecifier];
            if ([phoneNumber length] == 0) {
                ACLogError(@"Invalid telelphone URL: %@.", url.absoluteString);
                [self release];
                return nil;
            }
        }

        _alertView = [[UIAlertView alloc] initWithTitle: @"Are you sure you want to call?"
                                                message:phoneNumber
                                               delegate:self
                                      cancelButtonTitle:@"Cancel"
                                      otherButtonTitles:@"Call", nil];
        self.clickHandler = clickHandler;

        // We want to manually handle telPrompt scheme alerts.  So we'll convert telPrompt schemes to tel schemes.
        if ([url mp_hasTelephonePromptScheme]) {
            self.telephoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneNumber]];
        } else {
            self.telephoneURL = url;
        }
    }

    return self;
}

- (void)dealloc
{
    self.alertView.delegate = nil;
    [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
    self.alertView = nil;
    
    self.clickHandler = nil;
    self.telephoneURL = nil;
    [super dealloc];
}

- (void)show
{
    [self.alertView show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    BOOL confirmed = (buttonIndex == 1);

    if (self.clickHandler) {
        self.clickHandler(self.telephoneURL, confirmed);
    }

}

@end

