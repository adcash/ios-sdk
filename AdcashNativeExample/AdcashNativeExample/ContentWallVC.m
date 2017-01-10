//
//  ContentWallVC.m
//  AdcashNativeExample
//
//  Created by Mert on 06/01/17.
//  Copyright © 2017 Adcash. All rights reserved.
//

#import "ContentWallVC.h"
#import "ContentWallCell.h"


@interface ContentWallVC ()
@property (nonatomic, strong) NSString *nativeZone;
@end

@implementation ContentWallVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.nativeZone = @"1479695";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableData = [NSArray arrayWithObjects:@"Item 1",@"Item 2",@"Item 3",@"Item 4",@"Item 5",@"Item 6",nil];
    
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    _tablee = tableView;
    static NSString *simpleTableIdentifier = @"ContentWallCell";
    
    ContentWallCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ContentWallCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if(indexPath.row == 2) {
        cell.adNameLabel.text = [self.native getAdTitle];
        cell.adNameLabel.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
        cell.adNameLabel.textColor = [UIColor whiteColor];
        cell.adImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[self.native getAdImageURL]]];
        [cell.adImage setContentMode:UIViewContentModeScaleAspectFill];
        cell.adButton.text = [self.native getAdButtonText];
        cell.tag = [_nativeZone integerValue];
    } else {
        cell.adButton.backgroundColor = [UIColor clearColor];
        cell.adNameLabel.text = [_tableData objectAtIndex:indexPath.row];
        cell.adImage.image = [UIImage imageNamed:@"adcash.jpg"];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 280.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 2)
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

@end
