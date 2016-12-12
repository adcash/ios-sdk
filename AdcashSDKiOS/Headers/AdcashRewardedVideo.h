//
//  AdcashRewardedVideo.h
//  adcash-ios-sdk
//
//  Created by Mert on 14/11/16.
//  Copyright © 2016 Adcash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AdcashRewardedVideo;

/**
 AdcashRewardedVideoDelegate is the class for receiving
 state change events from AdcashRewardedVideo instances. Use it to receive
 state callbacks for rewarded video ad request success, fail or any other event
 triggered by the user.
 @since 2.3.0
 */

@protocol AdcashRewardedVideoDelegate <NSObject>

/**
 @brief Sent when rewarded video is finished playing successfully and user should be rewarded for
 watching the rewarded video.
 
 @param rewardedVideo An AdcashRewardedVideo instance that has successfully completed playing.
 @param reward An integer that represents the amount of in-game goods that user should rewarded with.
 
 @since 2.3.0
 */
- (void)rewardedVideoDidComplete:(AdcashRewardedVideo *)rewardedVideo withReward:(double)reward;

@optional

/**
 @brief Sent when the ad request has succeeded and the rewarded video is ready to be shown.
 
 @param rewardedVideo An AdcashRewardedVideo instance that succeeded to load.
 @discussion
 When rewarded video is loaded, you can use this callback to present the rewarded video in
 your view controller, like so;
 
 - (void)rewardedVideoDidReceiveAd:(AdcashRewardedVideo *)rewardedVideo
 {
 [rewardedVideo playRewardedVideoFrom:self];
 }
 @since 2.3.0
 */
- (void)rewardedVideoDidReceiveAd:(AdcashRewardedVideo *)rewardedVideo;

/**
 @brief Sent when the rewarded video has failed to load.
 User error param to determine what is the cause. Usually this is because there is no internet connectivity
 or there are no more video ads to show.
 
 @param rewardedVideo An AdcashRewardedVideo instance that has failed to load.
 @param error A NSError instance. Use it to determine why the loading has failed.
 @since 2.3.0
 */
- (void)rewardedVideoDidFailToReceiveAd:(AdcashRewardedVideo *)rewardedVideo withError:(NSError *)error;

/**
 @brief Sent just before presenting the rewarded video.
 
 @param rewardedVideo An AdcashRewardedVideo instance that is about to be shown.
 @since 2.3.0
 */
- (void)rewardedVideoWillPresentScreen:(AdcashRewardedVideo *)rewardedVideo;

/**
 @brief Sent just before the rewarded video is to be dismissed.
 
 @param rewardedVideo An AdcashRewardedVideo instance that is about to be dismissed.
 @since 2.3.0
 */
- (void)rewardedVideoWillDismissScreen:(AdcashRewardedVideo *)rewardedVideo;

/**
 @brief Sent just after the rewarded video is finished playing.
 
 @param rewardedVideo An AdcashRewardedVideo instance that is just finished playing.
 @since 2.3.0
 */
- (void)rewardedVideoDidDismissScreen:(AdcashRewardedVideo *)rewardedVideo;

/**
 @brief Sent when the app is about to enter in background because user has clicked on an ad
 that navigates outside of the app to another application (e.g. App Store).
 Method 'applicationDidEnterBackground:' of you app delegate is called immediately after this.
 
 @note The method is called before calling '[[UIApplication sharedApplication] openURL:]'.
 Therefore, the application will not enter in background if 'openURL:' does not succeed.
 Do not rely on the assumption that 'rewardedVideoWillLeaveApplication:' will always be followed by
 entering the application in background mode.
 
 @param rewardedVideo An AdcashRewardedVideo instance.
 @since 2.3.0
 */
- (void)rewardedVideoWillLeaveApplication:(AdcashRewardedVideo *)rewardedVideo;

@end


/**
 Class to display a Rewarded Video Ad.
 Videos are full screen advertisements that are shown at natural transition points in your application
 such as between game levels, when switching news stories, in general when transitioning from one view controller
 to another. It's best to request for a video some time before when it's actually needed, so it can preload it's
 content and become ready to present, and when the time comes, it can be immediately presented to the user
 with a smooth experience.
 */
@interface AdcashRewardedVideo : UIViewController

/**
 An object that comforms to the AdcashRewardedVideoDelegate and can receive callbacks for rewarded video
 state change.
 @since 2.3.0
 */
@property(nonatomic,weak) id <AdcashRewardedVideoDelegate> delegate;

/**
 This is the designated initializer for the AdcashRewardedVideo class.
 
 @param zoneID Is a unique zone ID that is created in Adcash Publisher Portal.
 @return An initialized AdcashRewardedVideo instance.
 @since 2.3.0
 */
- (instancetype)initRewardedVideoWithZoneID:(NSString *)zoneID;

/**
 Call after initialized rewarded video, to present it on screen.
 @param controller Is an UIViewController instance that is used to present modal overlay.
 @since 2.3.0
 */
- (void)playRewardedVideoFrom:(UIViewController *)controller;

@end
