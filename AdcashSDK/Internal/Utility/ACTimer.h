//
//  ACTimer.h
//  Adcash
//
//  Created by Andrew He on 3/8/11.
//  Copyright (c) 2014, Adcash OU and MoPub Inc.
//

#import <Foundation/Foundation.h>

/*
 * ACTimer wraps an NSTimer and adds pause/resume functionality.
 */
@interface ACTimer : NSObject

+ (ACTimer *)timerWithTimeInterval:(NSTimeInterval)seconds
                            target:(id)target
                          selector:(SEL)aSelector
                           repeats:(BOOL)repeats;

- (BOOL)isValid;
- (void)invalidate;
- (BOOL)isScheduled;
- (BOOL)scheduleNow;
- (BOOL)pause;
- (BOOL)resume;
- (NSTimeInterval)initialTimeInterval;

@end
