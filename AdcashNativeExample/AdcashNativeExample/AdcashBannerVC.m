//
//  AdcashBannerVC.m
//  AdcashNativeExample
//
//  Created by Mert on 09/01/17.
//  Copyright © 2017 Adcash. All rights reserved.
//

#import "AdcashBannerVC.h"

@implementation AdcashBannerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    ADCBannerView *bannerView = [[ADCBannerView alloc] initWithZoneID:@"1461197" onViewController:self];
    bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:bannerView];
    NSDictionary *views = NSDictionaryOfVariableBindings(bannerView);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bannerView]|" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bannerView]|" options:0 metrics:nil views:views]];
    
    bannerView.delegate = self;
    
    [bannerView load];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Adcash Banner Delegate Methods
-(void)bannerViewDidReceiveAd:(ADCBannerView *)bannerView {
    NSLog(@"Banner loaded.");
}

-(void)bannerView:(ADCBannerView *)bannerView didFailToReceiveAdWithError:(NSError *)error {
    NSLog(@"Banner failed to load. Error: %@",[error localizedDescription]);
}

-(void)bannerViewWillPresentScreen:(ADCBannerView *)bannerView {
    NSLog(@"Banner will present screen.");
}

-(void)bannerViewWillDismissScreen:(ADCBannerView *)bannerView {
    NSLog(@"Banner will dismiss screen.");
}

-(void)bannerViewWillLeaveApplication:(ADCBannerView *)bannerView {
    NSLog(@"Banner will leave application.");
}

@end