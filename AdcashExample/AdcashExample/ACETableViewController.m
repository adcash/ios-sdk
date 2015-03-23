//
//  ACETableViewController.m
//  AdcashExample
//
//  Created by Martin on 1/30/15.
//  Copyright (c) 2015 Adcash. All rights reserved.
//

#import "ACETableViewController.h"
#import "ACEBannerViewController.h"
#import "ACEInterstitialViewController.h"


@implementation ACETableViewController

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self navigateToBannerController];
            break;
        case 1:
            [self navigateToInterstitialController];
        default:
            break;
    }
}
             
- (void) navigateToBannerController
{
    ACEBannerViewController *bannerViewController = [[ACEBannerViewController alloc] init];
    [self.navigationController pushViewController:bannerViewController animated:YES];
}

- (void) navigateToInterstitialController
{
    ACEInterstitialViewController *interstitialController = [[ACEInterstitialViewController alloc] init];
    [self.navigationController pushViewController:interstitialController animated:YES];
}

@end
