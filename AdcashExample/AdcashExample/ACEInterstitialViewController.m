//
//  ACEInterstitialViewController.m
//  AdcashExample
//
//  Created by Martin on 1/30/15.
//  Copyright (c) 2015 Adcash. All rights reserved.
//

#import "ACEInterstitialViewController.h"
#import <AdcashSDK/AdcashSDK.h>

@interface ACEInterstitialViewController () <ACInterstitialDelegate>

@property (nonatomic, strong) ACInterstitial * interstitial;

@end


@implementation ACEInterstitialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.interstitial = [[ACInterstitial alloc] initWithAdUnitId:@"409359"];
    self.interstitial.delegate = self;
    
    [self.interstitial load];
}

- (void)interstitialDidReceiveAd:(ACInterstitial *)interstitial
{
    NSLog(@"Interstitial loaded successfully.");
    
    [interstitial presentFromRootViewController:self];
}

@end
