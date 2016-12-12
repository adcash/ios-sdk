//
//  ViewController.m
//  AdcashExample
//
//  Copyright © 2016 Adcash. All rights reserved.
//

#import "ViewController.h"
#import "AdcashSDK.h"

@interface ViewController () <ADCBannerViewDelegate,ADCInterstitialDelegate,AdcashRewardedVideoDelegate>

@property (nonatomic, strong) ADCBannerView *banner;
@property (nonatomic, strong) ADCInterstitial *interstitial;
@property (nonatomic, strong) AdcashRewardedVideo *video;
@property (nonatomic, strong) IBOutlet UIButton *showBanner;
@property (nonatomic, strong) IBOutlet UIButton *showInterstitial;
@property (nonatomic, strong) IBOutlet UIButton *showVideo;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Banner-------------------------------------------------------------------------------------------------------
    _banner = [[ADCBannerView alloc] initWithZoneID:@"1461197" onViewController:self];
    
    _banner.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:_banner];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_banner);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_banner]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_banner]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    
    _banner.delegate = self;
    //-------------------------------------------------------------------------------------------------------------
    
    
    
    //User Interface-----------------------------------------------------------------------------------------------
    _showBanner = [UIButton buttonWithType:UIButtonTypeSystem];
    
    _showBanner.frame = CGRectMake(0, 0, 50, 100);
    
    [_showBanner setTitle:@" Show Banner " forState:UIControlStateNormal];
    
    [[_showBanner layer] setBorderWidth:2.0f];
    
    [_showBanner setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [_showBanner addTarget:self
                    action:@selector(bannerButton)
          forControlEvents:UIControlEventTouchUpInside];
    
    
    _showInterstitial = [UIButton buttonWithType:UIButtonTypeSystem];
    
    _showInterstitial.frame = CGRectMake(0, 0, 50, 100);
    
    [_showInterstitial setTitle:@" Show Interstitial " forState:UIControlStateNormal];
    
    [[_showInterstitial layer] setBorderWidth:2.0f];
    
    [_showInterstitial setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [_showInterstitial addTarget:self
                          action:@selector(interstitialButton)
                forControlEvents:UIControlEventTouchUpInside];
    
    
    _showVideo = [UIButton buttonWithType:UIButtonTypeSystem];
    
    _showVideo.frame = CGRectMake(0, 0, 50, 100);
    
    [_showVideo setTitle:@" Show Rewarded " forState:UIControlStateNormal];
    
    [[_showVideo layer] setBorderWidth:2.0f];
    
    [_showVideo setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [_showVideo addTarget:self
                   action:@selector(videoButton)
         forControlEvents:UIControlEventTouchUpInside];
    
    
    NSLayoutConstraint *InterstitialConstraintVertical = [NSLayoutConstraint constraintWithItem:_showInterstitial
                                                                               attribute:NSLayoutAttributeCenterX
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:self.view
                                                                               attribute:NSLayoutAttributeCenterX
                                                                              multiplier:1.0
                                                                                constant:0];
    
    NSLayoutConstraint *InterstitialConstraintHorizontal = [NSLayoutConstraint constraintWithItem:_showInterstitial
                                                                               attribute:NSLayoutAttributeCenterY
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:self.view
                                                                               attribute:NSLayoutAttributeCenterY
                                                                              multiplier:1.0
                                                                                constant:0];
    
    NSLayoutConstraint *BannerConstraintVertical = [NSLayoutConstraint constraintWithItem:_showBanner
                                                                                attribute:NSLayoutAttributeCenterX
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:self.view
                                                                                attribute:NSLayoutAttributeCenterX
                                                                               multiplier:1.0
                                                                                 constant:0];
    
    NSLayoutConstraint *BannerConstraintHorizontal = [NSLayoutConstraint constraintWithItem:_showBanner
                                                                                  attribute:NSLayoutAttributeBottom
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:_showInterstitial
                                                                                  attribute:NSLayoutAttributeTop
                                                                                 multiplier:1.0
                                                                                   constant:-30];
    
    NSLayoutConstraint *VideoConstraintVertical = [NSLayoutConstraint constraintWithItem:_showVideo
                                                                               attribute:NSLayoutAttributeCenterX
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:self.view
                                                                               attribute:NSLayoutAttributeCenterX
                                                                              multiplier:1.0
                                                                                constant:0];
    
    NSLayoutConstraint *VideoConstraintHorizontal = [NSLayoutConstraint constraintWithItem:_showVideo
                                                                                 attribute:NSLayoutAttributeTop
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:_showInterstitial
                                                                                 attribute:NSLayoutAttributeBottom
                                                                                multiplier:1.0
                                                                                  constant:30];
    
    
    [self.view addSubview:_showBanner];
    
    [self.view addSubview:_showInterstitial];
    
    [self.view addSubview:_showVideo];
    
    [self.view addConstraints:@[BannerConstraintVertical,BannerConstraintHorizontal,
                                InterstitialConstraintVertical,InterstitialConstraintHorizontal,
                                VideoConstraintVertical,VideoConstraintHorizontal]];
    
    
    //-------------------------------------------------------------------------------------------------------------
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark Button Functions

-(void)bannerButton
{
    [_banner load];
}

-(void)interstitialButton
{
    _interstitial = [[ADCInterstitial alloc] initWithZoneID:@"1253058"];
    _interstitial.delegate = self;
    [_interstitial load];
}

-(void)videoButton
{
    _video = [[AdcashRewardedVideo alloc] initRewardedVideoWithZoneID:@"1461193"];
    _video.delegate = self;
}

#pragma mark Delegate Examples

-(void)rewardedVideoDidReceiveAd:(AdcashRewardedVideo *)rewardedVideo
{
    NSLog(@"Rewarded video received and ready to be shown.");
    [_video playRewardedVideoFrom:self];
}

-(void)rewardedVideoDidComplete:(AdcashRewardedVideo *)rewardedVideo withReward:(double)reward
{
    NSLog(@"Rewarded video complete. User earned %.f reward",reward);
}

-(void)interstitialDidReceiveAd:(ADCInterstitial *)interstitial
{
    NSLog(@"Interstitial received an ad and ready to be shown.");
    [_interstitial presentFromRootViewController:self];
}

@end
