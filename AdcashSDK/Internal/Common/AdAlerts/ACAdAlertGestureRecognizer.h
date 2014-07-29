//
//  ACAdAlertGestureRecognizer.h
//  Adcash
//
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSInteger const kACAdAlertGestureMaxAllowedYAxisMovement;

typedef enum
{
    ACAdAlertGestureRecognizerState_ZigRight1,
    ACAdAlertGestureRecognizerState_ZagLeft2,
    ACAdAlertGestureRecognizerState_Recognized
} ACAdAlertGestureRecognizerState;

@interface ACAdAlertGestureRecognizer : UIGestureRecognizer

// default is 4
@property (nonatomic, assign) NSInteger numZigZagsForRecognition;

// default is 100
@property (nonatomic, assign) CGFloat minTrackedDistanceForZigZag;

@property (nonatomic, readonly) ACAdAlertGestureRecognizerState currentAlertGestureState;
@property (nonatomic, readonly) CGPoint inflectionPoint;
@property (nonatomic, readonly) BOOL thresholdReached;
@property (nonatomic, readonly) NSInteger curNumZigZags;

@end
