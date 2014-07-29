//
//  ACProgressOverlayView.h
//  Adcash
//
//  Created by Andrew He on 7/18/12.
//  Copyright 2012 MoPub, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ACProgressOverlayViewDelegate;

@interface ACProgressOverlayView : UIView {
    id<ACProgressOverlayViewDelegate> _delegate;
    UIView *_outerContainer;
    UIView *_innerContainer;
    UIActivityIndicatorView *_activityIndicator;
    UIButton *_closeButton;
    CGPoint _closeButtonPortraitCenter;
}

@property (nonatomic, assign) id<ACProgressOverlayViewDelegate> delegate;
@property (nonatomic, retain) UIButton *closeButton;

- (id)initWithDelegate:(id<ACProgressOverlayViewDelegate>)delegate;
- (void)show;
- (void)hide;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@protocol ACProgressOverlayViewDelegate <NSObject>

@optional
- (void)overlayCancelButtonPressed;
- (void)overlayDidAppear;

@end
