//
//  ACLastResortDelegate+EventKit.m
//  Adcash
//
//  Copyright (c) 2014 Adcash. All rights reserved.
//

#import "ACLastResortDelegate+EventKit.h"
#import "ACGlobal.h"
#import "UIViewController+ACAdditions.h"


@implementation ACLastResortDelegate (EventKit)

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
    [controller mp_dismissModalViewControllerAnimated:AC_ANIMATED];
}

@end
