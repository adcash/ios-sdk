//
//  AdcashRewardedVC.m
//  AdcashNativeExample
//
//  Created by Mert on 09/01/17.
//  Copyright © 2017 Adcash. All rights reserved.
//

#import "AdcashRewardedVC.h"

@implementation AdcashRewardedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.video = [[AdcashRewardedVideo alloc] initRewardedVideoWithZoneID:@"1461193"];
    self.video.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Adcash Rewarded Video Delegate Methods

-(void)rewardedVideoDidReceiveAd:(AdcashRewardedVideo *)rewardedVideo {
    NSLog(@"Rewarded video loaded.");
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.video playRewardedVideoFrom:self];
    
}

-(void)rewardedVideoDidComplete:(AdcashRewardedVideo *)rewardedVideo withReward:(int)reward {
    NSLog(@"Rewarded Video completed. %d unit reward earned.",reward);
}

-(void)rewardedVideoDidFailToReceiveAd:(AdcashRewardedVideo *)rewardedVideo withError:(NSError *)error {
    NSLog(@"Rewarded Video failed to load. Error: %@",[error localizedDescription]);
}

-(void)rewardedVideoWillPresentScreen:(AdcashRewardedVideo *)rewardedVideo {
    NSLog(@"Rewarded Video will present screen.");
}

-(void)rewardedVideoWillDismissScreen:(AdcashRewardedVideo *)rewardedVideo {
    NSLog(@"Rewarded Video will dismiss screen.");
}

-(void)rewardedVideoDidDismissScreen:(AdcashRewardedVideo *)rewardedVideo {
    NSLog(@"Rewarded Video did dismiss screen.");
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)rewardedVideoWillLeaveApplication:(AdcashRewardedVideo *)rewardedVideo {
    NSLog(@"Rewarded Video will leave the application");
}
@end
