//
//  ACAdAlertManager.h
//  Adcash
//
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ACGlobal.h"

@class CLLocation;
@protocol ACAdAlertManagerDelegate;

@class ACAdConfiguration;

@interface ACAdAlertManager : NSObject <ACAdAlertManagerProtocol>

@end

@protocol ACAdAlertManagerDelegate <NSObject>

@required
- (UIViewController *)viewControllerForPresentingMailVC;
- (void)adAlertManagerDidTriggerAlert:(ACAdAlertManager *)manager;

@optional
- (void)adAlertManagerDidProcessAlert:(ACAdAlertManager *)manager;

@end