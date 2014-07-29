//
//  ACGlobal.h
//  Adcash
//
//  Created by Andrew He on 5/5/11.
//  Copyright (c) 2014, Adcash OU and MoPub Inc.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef AC_ANIMATED
#define AC_ANIMATED YES
#endif

UIInterfaceOrientation ACInterfaceOrientation(void);
UIWindow *ACKeyWindow(void);
CGFloat ACStatusBarHeight(void);
CGRect ACApplicationFrame(void);
CGRect ACScreenBounds(void);
CGFloat ACDeviceScaleFactor(void);
NSDictionary *ACDictionaryFromQueryString(NSString *query);
NSString *ACSHA1Digest(NSString *string);
BOOL ACViewIsVisible(UIView *view);

////////////////////////////////////////////////////////////////////////////////////////////////////

/*
 * Availability constants.
 */

#define AC_IOS_2_0  20000
#define AC_IOS_2_1  20100
#define AC_IOS_2_2  20200
#define AC_IOS_3_0  30000
#define AC_IOS_3_1  30100
#define AC_IOS_3_2  30200
#define AC_IOS_4_0  40000
#define AC_IOS_4_1  40100
#define AC_IOS_4_2  40200
#define AC_IOS_4_3  40300
#define AC_IOS_5_0  50000
#define AC_IOS_5_1  50100
#define AC_IOS_6_0  60000
#define AC_IOS_7_0  70000

////////////////////////////////////////////////////////////////////////////////////////////////////

enum {
    ACInterstitialCloseButtonStyleAlwaysVisible,
    ACInterstitialCloseButtonStyleAlwaysHidden,
    ACInterstitialCloseButtonStyleAdControlled
};
typedef NSUInteger ACInterstitialCloseButtonStyle;

enum {
    ACInterstitialOrientationTypePortrait,
    ACInterstitialOrientationTypeLandscape,
    ACInterstitialOrientationTypeAll
};
typedef NSUInteger ACInterstitialOrientationType;


////////////////////////////////////////////////////////////////////////////////////////////////////

@interface NSString (ACAdditions)

/*
 * Returns string with reserved/unsafe characters encoded.
 */
- (NSString *)URLEncodedString;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface UIDevice (ACAdditions)

- (NSString *)hardwareDeviceName;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
// Optional Class Forward Def Protocols
////////////////////////////////////////////////////////////////////////////////////////////////////

@class ACAdConfiguration, CLLocation;

@protocol ACAdAlertManagerProtocol <NSObject>

@property (nonatomic, retain) ACAdConfiguration *adConfiguration;
@property (nonatomic, copy) NSString *adUnitId;
@property (nonatomic, copy) CLLocation *location;
@property (nonatomic, assign) UIView *targetAdView;
@property (nonatomic, assign) id delegate;

- (void)beginMonitoringAlerts;
- (void)processAdAlertOnce;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
// Small alert wrapper class to handle telephone protocol prompting
////////////////////////////////////////////////////////////////////////////////////////////////////

@class ACTelephoneConfirmationController;

typedef void (^ACTelephoneConfirmationControllerClickHandler)(NSURL *targetTelephoneURL, BOOL confirmed);

@interface ACTelephoneConfirmationController : NSObject <UIAlertViewDelegate>

- (id)initWithURL:(NSURL *)url clickHandler:(ACTelephoneConfirmationControllerClickHandler)clickHandler;
- (void)show;

@end
