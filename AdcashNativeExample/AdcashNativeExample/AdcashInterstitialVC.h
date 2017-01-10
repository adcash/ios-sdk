//
//  AdcashInterstitialVC.h
//  AdcashNativeExample
//
//  Created by Mert on 09/01/17.
//  Copyright © 2017 Adcash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdcashSDK.h"

@interface AdcashInterstitialVC : UIViewController<ADCInterstitialDelegate>

@property (nonatomic, strong) ADCInterstitial *interstitial;

@end
