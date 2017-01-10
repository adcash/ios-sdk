//
//  AdcashTableViewController.m
//  AdcashNativeExample
//
//  Created by Mert on 06/01/17.
//  Copyright © 2017 Adcash. All rights reserved.
//

#import "AdcashTableViewController.h"
#import "NativeFeedVC.h"
#import "ContentStreamVC.h"
#import "ContentWallVC.h"
#import "AdcashBannerVC.h"
#import "AdcashInterstitialVC.h"
#import "AdcashRewardedVC.h"

@interface AdcashTableViewController ()

@end

@implementation AdcashTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setAccessibilityIdentifier:@"tableView"];
    self.navigationItem.backBarButtonItem.isAccessibilityElement = YES;
    self.navigationItem.backBarButtonItem.accessibilityLabel = @"Back";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self navigateToNativeFeedVC];
            break;
        case 1:
            [self navigateToContentStreamVC];
            break;
        case 2:
            [self navigateToContentWallVC];
            break;
        case 3:
            [self navigateToAdcashBannerVC];
            break;
        case 4:
            [self navigateToAdcashInterstitialVC];
            break;
        case 5:
            [self navigateToAdcashRewardedVC];
            break;
        default:
            break;
    }
}

-(void)navigateToNativeFeedVC {
    NativeFeedVC *VCNativeFeed = [[NativeFeedVC alloc] init];
    [self.navigationController pushViewController:VCNativeFeed animated:YES];
}
-(void)navigateToContentStreamVC {
    ContentStreamVC *VCContentStream = [[ContentStreamVC alloc] init];
    [self.navigationController pushViewController:VCContentStream animated:YES];
}
-(void)navigateToContentWallVC {
    ContentWallVC *VCContentWall = [[ContentWallVC alloc] init];
    [self.navigationController pushViewController:VCContentWall animated:YES];
}
-(void)navigateToAdcashBannerVC {
    AdcashBannerVC *VCAdcashBanner = [[AdcashBannerVC alloc] init];
    [self.navigationController pushViewController:VCAdcashBanner animated:YES];
}
-(void)navigateToAdcashInterstitialVC {
    AdcashInterstitialVC *VCAdcashInterstitial = [[AdcashInterstitialVC alloc] init];
    [self.navigationController pushViewController:VCAdcashInterstitial animated:YES];
}
-(void)navigateToAdcashRewardedVC {
    AdcashRewardedVC *VCAdcashRewarded = [[AdcashRewardedVC alloc] init];
    [self.navigationController pushViewController:VCAdcashRewarded animated:YES];
}


@end
