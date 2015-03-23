//
//  ACEBannerViewController.m
//  AdcashExample
//
//  Created by Martin on 1/30/15.
//  Copyright (c) 2015 Adcash. All rights reserved.
//

#import "ACEBannerViewController.h"
#import <AdcashSDK/AdcashSDK.h>

@interface ACEBannerViewController () <ACBannerViewDelegate>

@end

@implementation ACEBannerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    ACBannerView *bannerView = [[ACBannerView alloc] initWithAdSize:ACAdSizeSmartBanner
                                                           adUnitID:@"409360"
                                                 rootViewController:self];
    bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    bannerView.delegate = self;
    
    [self.view addSubview:bannerView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:bannerView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bannerView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"bannerView":bannerView}]];
    
    [bannerView load];
}

- (void)bannerViewDidReceiveAd:(ACBannerView *)bannerView
{
    NSLog(@"Banner loaded successfully.");
}

- (void)bannerView:(ACBannerView *)bannerView didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"%@", [error localizedDescription]);
}

@end
