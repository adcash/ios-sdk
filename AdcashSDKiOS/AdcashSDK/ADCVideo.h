//
//  ADCVideo.h
//  adcash-ios-sdk
//
//  Created by Mert on 25/05/16.
//  Copyright © 2016 Adcash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ADCVideo;

/**
 ADCVideoDelegate is the delegate class for receiving
 state change events from ADCVideo instances. Use it to receive
 state callbacks for interstitial ad request success, fail, or any other event
 triggered by the user.
 @since 2.0.0
 */
@protocol ADCVideoDelegate <NSObject>

@optional
/**
 @brief Sent when the ad request has succeeded and the interstitial is ready to be shown.
 
 @param video An ADCVideo instance that succeeded to load.
 @discussion
 When the video is loaded, you can use this callback to present the video in
 your view controller, like so;
    
    -(void) videoDidReceiveAd:(ADCVideo *)video
    {
        [video playVideoFromViewController:self];
    }
 @since 2.0.0
 */
-(void)videoDidReceiveAd:(ADCVideo *)video;

/**
 @brief Sent when the video has failed to load.
 Use error param to determine what is the cause. Usually this is because there is no
 internet connectivity or because there are no more video ads to show.
 
 @param video An ADCVideo instance that failed to load.
 @param error A NSError instance. Use it to determine why the loading has failed.
 
 @since 2.0.0
 */
-(void)videoDidFailToReceiveAd:(ADCVideo *)video withError:(NSError *)error;

/**
 @brief Sent just before presenting the video.
 
 @param video An ADCVideo instance that is about to be shown.
 
 @since 2.0.0
 */
-(void)videoWillPresentScreen:(ADCVideo *)video;

/**
 @brief Sent just before the video is to be dismissed.
 
 @param video An ADCVideo instance that is about to be dismissed.
 
 @since 2.0.0
 */
-(void)videoWillDismissScreen:(ADCVideo *)video;

/**
 @brief Sent just after the video is finished playing.
 
 @param video An ADCVideo instance that is just finished playing.
 
 @since 2.0.0
 */
-(void)videoDidDismissScreen:(ADCVideo *)video;

/**
 @brief Sent when the app is about to enter in background because user 
 has clicked on an ad that navigates outside of the app to another application (e.g. App Store).
 Method `applicationDidEnterBackground:` of your app delegate is called immediately after this.
 
 @note The method is called before calling `[[UIApplication sharedApplication] openURL:]`.
 Therefore, the application will not enter in background if `openURL:` does not succeed.
 Do not rely on the assumption that `videoWillLeaveApplication:` will always be followed by
 entering the application in background mode.
 
 @param video An ADCVideo instance.
 
 @since 2.0.0
 */
-(void)videoWillLeaveApplication:(ADCVideo *)video;

@end


/**
 Class to display a Video Ad.
 Videos are full screen advertisements that are shown at natural transition
 points in your application such as between game levels, when switching news stories,
 in general when transitioning from one view controller to another. It's best to request
 for an video some time before when it's actually needed, so it can preload it's content and 
 become ready to present, and when the time comes, it can be immediately presented to the user
 with a smooth expericence.
 */
@interface ADCVideo : NSObject

/**
 An object that comforms to the ADCVideoDelegate and can receive callbacks
 for video state change. May be nil.
 */
@property(nonatomic,weak) id <ADCVideoDelegate> delegate;

/**
 This is the designated initializer for the ADCVideo class.
 @param zoneID is a unique zone ID that is created in Adcash Publisher Portal.
 @return An initialized ADCVideo instance
 @since 2.0.0
 */
-(instancetype)initVideoWithZoneID:(NSString *)zoneID;


/**
 Call after initializing video to present it on screen.
 @param YourViewController is an UIViewController instance that is used to present modal overlay.
 @since 2.0.0
 */
-(void)playVideoFromViewController:(UIViewController *)YourViewController;

@end
