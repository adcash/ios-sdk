//
//  NativeFeedVC.h
//  AdcashNativeExample
//
//  Created by Mert on 06/01/17.
//  Copyright © 2017 Adcash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdcashSDK.h"

@interface NativeFeedVC : UITableViewController <UITableViewDelegate, UITableViewDataSource, AdcashNativeDelegate>

@property (nonatomic, strong) NSArray *tableData;
@property (nonatomic, strong) UITableView *tablee;
@property (nonatomic, strong) AdcashNative *native;

@end
