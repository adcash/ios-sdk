//
//  NativeFeedVC.m
//  AdcashNativeExample
//
//  Created by Mert on 06/01/17.
//  Copyright © 2017 Adcash. All rights reserved.
//

#import "NativeFeedVC.h"
#import "NativeFeedCell.h"


@interface NativeFeedVC ()
@property (nonatomic, strong) NSString *nativeZone;
@end

@implementation NativeFeedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self presentWarning];
    self.nativeZone = @"1479695";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableData = [NSArray arrayWithObjects:@"Item 1",@"Item 2",@"Item 3",@"Item 4",@"Item 5",@"Item 6",@"Item 7",@"Item 8",@"Item 9",@"Item 10",@"Item 11",@"Item 12",@"Item 13",nil];
    
    self.native = [[AdcashNative alloc] initAdcashNativeWithZoneID:_nativeZone];
    self.native.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Delegate Functions

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tableData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    _tablee = tableView;
    static NSString *simpleTableIdentifier = @"NativeFeedCell";
    
    NativeFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NativeFeedCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if(indexPath.row == 7) {
        cell.adNameLabel.text = [self.native getAdTitle];
        cell.adIcon.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[self.native getAdIconURL]]];
        [cell.adIcon setContentMode:UIViewContentModeScaleAspectFit];
        cell.adDescriptionLabel.text = [self.native getAdDescription];
        cell.adRatingLabel.maximumValue = 5;
        cell.adRatingLabel.minimumValue = 0;
        cell.adRatingLabel.value =[[self.native getAdRating] floatValue];
        cell.adRatingLabel.allowsHalfStars = YES;
        cell.adRatingLabel.accurateHalfStars = YES;
        cell.adRatingLabel.tintColor = [UIColor orangeColor];
        cell.adButton.text = [self.native getAdButtonText];
        cell.tag = [_nativeZone integerValue];
    } else {
        cell.adDescriptionLabel.text = @"";
        cell.sponsoredLabel.text = @"";
        cell.adButton.backgroundColor = [UIColor clearColor];
        cell.adNameLabel.text = [_tableData objectAtIndex:indexPath.row];
        cell.adIcon.image = [UIImage imageNamed:@"Adcash.png"];
        [cell.adRatingLabel removeFromSuperview];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 7)
    {
        
        [self.native openClick];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)AdcashNativeAdReceived:(AdcashNative *)native {
    [_tablee reloadData];
}

-(void)AdcashNativeFailedToReceiveAd:(AdcashNative *)native withError:(NSError *)error {
    NSLog(@"%@",[error localizedDescription]);
    /*
     HANDLE REMOVING AD CELL THEN RELOAD TABLE
     */
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSArray *indexes = [_tablee indexPathsForVisibleRows];
    for(NSIndexPath *index in indexes) {
        if([_tablee cellForRowAtIndexPath:index].tag == [_nativeZone integerValue]) {
            [self.native trackImpression];
        }
    }
}

-(void)presentWarning {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Important Information"
                                                                   message:@"For showing rating as stars, external library (HCSStarRating) used. You should handle it yourself as well."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //do nothing.
    }];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
