//
//  ACTableViewCellImpressionTracker.h
//  Copyright (c) 2014 Adcash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ACTableViewCellImpressionTrackerDelegate;

@interface ACTableViewCellImpressionTracker : NSObject

- (id)initWithTableView:(UITableView *)tableView delegate:(id<ACTableViewCellImpressionTrackerDelegate>)delegate;
- (void)startTracking;
- (void)stopTracking;

@end

@protocol ACTableViewCellImpressionTrackerDelegate <NSObject>

- (void)tracker:(ACTableViewCellImpressionTracker *)tracker didDetectVisibleRowsAtIndexPaths:(NSArray *)indexPaths;

@end