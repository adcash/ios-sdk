//
//  ACTimer.m
//  Adcash
//
//  Created by Andrew He on 3/8/11.
//  Copyright (c) 2014, Adcash OU and MoPub Inc.
//

#import "ACTimer.h"
#import "ACLogging.h"

@interface ACTimer ()
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, copy) NSDate *pauseDate;
@property (nonatomic, assign) BOOL isPaused;
@property (nonatomic, assign) NSTimeInterval secondsLeft;
@end

@interface ACTimer ()

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL selector;

@end

@implementation ACTimer

@synthesize timeInterval = _timeInterval;
@synthesize timer = _timer;
@synthesize pauseDate = _pauseDate;
@synthesize target = _target;
@synthesize selector = _selector;
@synthesize isPaused = _isPaused;
@synthesize secondsLeft = _secondsLeft;

+ (ACTimer *)timerWithTimeInterval:(NSTimeInterval)seconds
                            target:(id)target
                          selector:(SEL)aSelector
                           repeats:(BOOL)repeats
{
    ACTimer *timer = [[ACTimer alloc] init];
    timer.target = target;
    timer.selector = aSelector;
    timer.timer = [NSTimer timerWithTimeInterval:seconds
                                      target:timer
                                    selector:@selector(timerDidFire)
                                    userInfo:nil
                                     repeats:repeats];
    timer.timeInterval = seconds;
    return [timer autorelease];
}

- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
    self.pauseDate = nil;

    [super dealloc];
}

- (void)timerDidFire
{
    [self.target performSelector:self.selector];
}

- (BOOL)isValid
{
    return [self.timer isValid];
}

- (void)invalidate
{
    self.target = nil;
    self.selector = nil;
    [self.timer invalidate];
    self.timer = nil;
}

- (BOOL)isScheduled
{
    if (!self.timer) {
        return NO;
    }
    CFRunLoopRef runLoopRef = [[NSRunLoop currentRunLoop] getCFRunLoop];
    return CFRunLoopContainsTimer(runLoopRef, (CFRunLoopTimerRef)self.timer, kCFRunLoopDefaultMode);
}

- (BOOL)scheduleNow
{
    if (![self.timer isValid])
    {
        ACLogDebug(@"Could not schedule invalidated ACTimer (%p).", self);
        return NO;
    }

    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    return YES;
}

- (BOOL)pause
{
    if (self.isPaused)
    {
        ACLogDebug(@"No-op: tried to pause an ACTimer (%p) that was already paused.", self);
        return NO;
    }

    if (![self.timer isValid])
    {
        ACLogDebug(@"Cannot pause invalidated ACTimer (%p).", self);
        return NO;
    }

    if (![self isScheduled])
    {
        ACLogDebug(@"No-op: tried to pause an ACTimer (%p) that was never scheduled.", self);
        return NO;
    }

    NSDate *fireDate = [self.timer fireDate];
    self.pauseDate = [NSDate date];
    self.secondsLeft = [fireDate timeIntervalSinceDate:self.pauseDate];
    if (self.secondsLeft <= 0)
    {
        ACLogWarn(@"An ACTimer was somehow paused after it was supposed to fire.");
        self.secondsLeft = 5;
    }
    else ACLogDebug(@"Paused ACTimer (%p) %.1f seconds left before firing.", self, self.secondsLeft);

    // Pause the timer by setting its fire date far into the future.
    [self.timer setFireDate:[NSDate distantFuture]];
    self.isPaused = YES;

    return YES;
}

- (BOOL)resume
{
    if (![self.timer isValid])
    {
        ACLogDebug(@"Cannot resume invalidated ACTimer (%p).", self);
        return NO;
    }

    if (!self.isPaused)
    {
        ACLogDebug(@"No-op: tried to resume an ACTimer (%p) that was never paused.", self);
        return NO;
    }

    ACLogDebug(@"Resumed ACTimer (%p), should fire in %.1f seconds.", self, self.secondsLeft);

    // Resume the timer.
    NSDate *newFireDate = [NSDate dateWithTimeInterval:self.secondsLeft sinceDate:[NSDate date]];
    [self.timer setFireDate:newFireDate];

    if (![self isScheduled])
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];

    self.isPaused = NO;
    return YES;
}

- (NSTimeInterval)initialTimeInterval
{
    return self.timeInterval;
}

@end

