//
//  ACAdBrowserController.h
//  Adcash
//
//  Created by Nafis Jamal on 1/19/11.
//  Copyright (c) 2014, Adcash OU and MoPub Inc.
//

#import <UIKit/UIKit.h>

#ifndef CF_RETURNS_RETAINED
#if __has_feature(attribute_cf_returns_retained)
#define CF_RETURNS_RETAINED __attribute__((cf_returns_retained))
#else
#define CF_RETURNS_RETAINED
#endif
#endif

@protocol ACAdBrowserControllerDelegate;

@interface ACAdBrowserController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate>

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *backButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *forwardButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *refreshButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *safariButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *spinnerItem;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;

@property (nonatomic, assign) id<ACAdBrowserControllerDelegate> delegate;
@property (nonatomic, copy) NSURL *URL;

- (id)initWithURL:(NSURL *)URL HTMLString:(NSString *)HTMLString delegate:(id<ACAdBrowserControllerDelegate>)delegate;

// Navigation methods.
- (IBAction)back;
- (IBAction)forward;
- (IBAction)refresh;
- (IBAction)safari;
- (IBAction)done;

// Drawing methods.
- (CGContextRef)createContext CF_RETURNS_RETAINED;
- (UIImage *)backArrowImage;
- (UIImage *)forwardArrowImage;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@protocol ACAdBrowserControllerDelegate <NSObject>

- (void)dismissBrowserController:(ACAdBrowserController *)browserController animated:(BOOL)animated;

@end
