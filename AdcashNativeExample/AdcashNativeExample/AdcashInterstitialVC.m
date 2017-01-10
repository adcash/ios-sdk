//
//  AdcashInterstitialVC.m
//  AdcashNativeExample
//
//  Created by Mert on 09/01/17.
//  Copyright © 2017 Adcash. All rights reserved.
//

#import "AdcashInterstitialVC.h"

@implementation AdcashInterstitialVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.interstitial = [[ADCInterstitial alloc] initWithZoneID:@"1461189"];
    self.interstitial.delegate = self;
    
    [self.interstitial load];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Adcash Interstitial Delegate Methods

-(void)interstitialDidReceiveAd:(ADCInterstitial *)interstitial {
    NSLog(@"Interstitial loaded");
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.interstitial presentFromRootViewController:self];
}

-(void)interstitial:(ADCInterstitial *)interstitial didFailToReceiveAdWithError:(NSError *)error {
    NSLog(@"Interstitial failed to load. Error: %@",[error localizedDescription]);
}

-(void)interstitialWillPresentScreen:(ADCInterstitial *)interstitial {
    NSLog(@"Interstitial will present screen.");
}

-(void)interstitialWillDismissScreen:(ADCInterstitial *)interstitial {
    NSLog(@"Interstitial will dismiss screen");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)interstitialWillLeaveApplication:(ADCInterstitial *)interstitial {
    NSLog(@"Interstitial will leave application");
}
@end
