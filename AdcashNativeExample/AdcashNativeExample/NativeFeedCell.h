//
//  NativeFeedCell.h
//  AdcashNativeExample
//
//  Created by Mert on 06/01/17.
//  Copyright © 2017 Adcash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"

@interface NativeFeedCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *adNameLabel;
@property (nonatomic, weak) IBOutlet HCSStarRatingView *adRatingLabel;
@property (nonatomic, weak) IBOutlet UILabel *adDescriptionLabel;
@property (nonatomic, weak) IBOutlet UIImageView *adIcon;
@property (nonatomic, weak) IBOutlet UILabel *adButton;
@property (nonatomic, weak) IBOutlet UILabel *sponsoredLabel;

@end
