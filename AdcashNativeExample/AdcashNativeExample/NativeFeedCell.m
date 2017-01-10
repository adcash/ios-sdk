//
//  NativeFeedCell.m
//  AdcashNativeExample
//
//  Created by Mert on 06/01/17.
//  Copyright © 2017 Adcash. All rights reserved.
//

#import "NativeFeedCell.h"

@implementation NativeFeedCell

@synthesize adNameLabel = _adNameLabel;
@synthesize adRatingLabel = _adRatingLabel;
@synthesize adDescriptionLabel = _adDescriptionLabel;
@synthesize adIcon = _adIcon;
@synthesize adButton = _adButton;
@synthesize sponsoredLabel = _sponsoredLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
