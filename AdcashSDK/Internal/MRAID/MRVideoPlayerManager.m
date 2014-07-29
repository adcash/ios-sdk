//
// Copyright (c) 2013 Adcash. All rights reserved.
//

#import "MRVideoPlayerManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ACInstanceProvider.h"
#import "UIViewController+ACAdditions.h"

@implementation MRVideoPlayerManager

@synthesize delegate = _delegate;

- (id)initWithDelegate:(id<MRVideoPlayerManagerDelegate>)delegate
{
    self = [super init];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:nil];

    [super dealloc];
}

- (void)playVideo:(NSURL *)url
{
    if (!url) {
        [self.delegate videoPlayerManager:self didFailToPlayVideoWithErrorMessage:@"URI was not valid."];
        return;
    }

    ACMoviePlayerViewController *controller = [[ACInstanceProvider sharedProvider] buildACMoviePlayerViewControllerWithURL:url];

    [self.delegate videoPlayerManagerWillPresentVideo:self];
    [[self.delegate viewControllerForPresentingVideoPlayer] mp_presentModalViewController:controller
                                                                                 animated:AC_ANIMATED];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerPlaybackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
}

- (void)moviePlayerPlaybackDidFinish:(NSNotification *)notification
{
    [self.delegate videoPlayerManagerDidDismissVideo:self];
}

@end
