
# **Adcash iOS SDK v2.3**


## **Prerequisites**
* Zone ID(s) that you created at [Adcash platform](https://www.myadcash.com/)
* [Adcash iOS SDK](https://github.com/adcash/ios-sdk/raw/master/AdcashSDKiOS.zip)
* Xcode 5 or higher
* Project deployment target iOS 7.0 or higher

**Integration with CocoaPods :**

> _Integration with Cocoapods will be added_

**Manual Integration :**

1. Download the [Adcash iOS SDK](https://github.com/adcash/ios-sdk/raw/master/AdcashSDKiOS.zip) and unzip it.
2. Right click on your project in the **Project Navigator** menu and select **Add Files to "name-of-your-project"**:
![Alt text](http://i2.wp.com/104.197.107.57/wp-content/uploads/2015/08/install-instructions-2.png)
3. Select the AdcashSDK folder you just unzipped and press **Add**. Make sure you choose **Copy items if needed**.
![Alt text](http://i2.wp.com/104.197.107.57/wp-content/uploads/2015/08/install-instructions-3.png)
4. Add the **-ObjC** linker flag to your project by going to **Build Settings > Other Linker Flags** :
![Alt text](http://i0.wp.com/104.197.107.57/wp-content/uploads/2015/08/install-instructions-4.png)
5. **Build** and **Run**. Your project should start without any errors.

---

##Banner Advertisements

   Here is how you can integrate a banner into your app just in few steps :
   1. Import `AdcashSDK.h` header file in your view controller's file;

   ```objc
   #import<AdcashSDK.h>
   ```
   2. Set your view controller to conform to `ADCBannerViewDelegate` protocol;

   ```objc
      @interface ViewController () <ADCBannerViewDelegate>
      ...
   	@end
   ```
   3. Add the following code to `viewDidLoad:` method of your view controllers .m file;

   ```objc
      //Initialize the banner
      ADCBannerView *bannerView = [[ADCBannerView alloc] initWithZoneID:@“<YOUR_ZONE_ID>”
                                                       onViewController:self];

   	//Do not translate autoresizing mask into constraints
   	bannerView.translatesAutoresizingMaskIntoConstraints = NO;

   	//Add your banner as a subview to your view
   	[self.view addSubview:bannerView];

   	//Add constraints to the banner
   	NSDictionary *views = NSDictionaryOfVariableBindings(bannerView);

   	//Set banner to take the width of it’s parent view
   	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@“H: | [bannerView] | ”
   	                                                                 options:0
   	                                                                 metrics:nil
   	                                                                 views:views]];


   //Set banner to stick to the bottom of it’s parent
   [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@“V: [bannerView] | ”
                                                                     options:0
                                                                     metrics:nil
                                                                     views:views]];

   //Set the banner’s delegate to be your view controller
   bannerView.delegate = self;

   //Show the banner
   [bannerView load];
   ```

   4. _**(Optional)**_ You can catch status updates from your banner by implementing the optional methods in `ADCBannerViewDelegate` protocol:
     ```objc
      -(void) bannerViewDidReceiveAd: (ADCBannerView *)bannerView;
      -(void) bannerView: (ADCBannerView *)bannerView didFailToReceiveAdWithError:(NSError *)error;
      -(void) bannerViewWillPresentScreen: (ADCBannerView *) bannerView;
      -(void) bannerViewWillLeaveApplication:(ADCBannerView *) bannerView;
      -(void) bannerViewWillDismissScreen: (ADCBannerView *) bannerView;
      ```


---

##Interstitial Advertisements

   Here is how you can integrate an interstitial into your app just in few steps :
   1. Import `AdcashSDK.h` header file in your view controller's file;

   ```objc
   #import<AdcashSDK.h>
   ```
   2. Declare an interstitial property in your file and make your view controller conform to the `ADCInterstitialDelegate` protocol. Your interface should look like this;

   ```objc
   @interface ViewController : UIViewController <ADCInterstitialDelegate>
@property (nonatomic,strong) ADCInterstitial *interstitial;
@end
   ```
   3. Add the following code to the `viewDidLoad:` method;
   ```objc
   //Assign an ADCInterstitial instance to your property.
self.interstitial = [[ADCInterstitial alloc] initWithZoneID:@“<YOUR_ZONE_ID>”];

//Make your view controller a delegate to the interstitial.
self.interstitial.delegate = self;

//Load the interstitial.
[self.interstitial load];
   ```
   4. When the interstitial is loaded successfully, you can catch the status update and present to the screen like the following;

   ```objc
   -(void) interstitialDidReceiveAd:(ADCInterstitial *)interstitial
{
[interstitial presentFromRootViewController:self];
}
   ```
   5. _**(Optional)**_ You can catch other status updates of your interstitial by implementing the optional methods in `ADCInterstitialDelegate` protocol;

   ```objc
      -(void) interstitialDidReceiveAd: (ADCInterstitial *)interstitial;
      -(void) interstitial: (ADCInterstitial *)interstitial didFailToReceiveAdWithError:(NSError *)error;
      -(void) interstitialWillPresentScreen: (ADCInterstitial *)interstitial;
      -(void) interstitialWillDismissScreen: (ADCInterstitial *)interstitial;
      -(void) interstitialWillLeaveApplication: (ACInterstitial *)interstitial;
      ```

---
##Rewarded Video Advertisements

   Here is how you can integrate a rewarded video into your app just in few steps :
   1. Import `AdcashSDK.h` header file into your view controllers file;

   ```objc
   #import<AdcashSDK.h>
   ```
   2. Declare a rewarded video property in your header file and make your view controller conform to the `AdcashRewardedVideoDelegate` protocol. Your interface should look like this;

   ```objc
   @interface ViewController : UIViewController<AdcashRewardedVideoDelegate>
   @property (nonatomic,strong) AdcashRewardedVideo *video;
   @end
   ```
   3. To load the rewarded video, add the following code to `viewDidLoad:` method;

   ```objc
   //Assign AdcashRewardedVideo instance to your property.
   self.video = [[AdcashRewardedVideo alloc] initRewardedVideoWithZoneID:@“<YOUR_ZONE_ID>”];
   self.video.delegate = self;
   ```

   4. To play the video, call:
   ```objc
   [self.video playRewardedVideoFrom:self];
   ```

   >Example below

    ```objc
    -(void)rewardedVideoDidReceiveAd:(AdcashRewardedVideo *)rewardedVideo
    {
        [self.video playRewardedVideoFrom:self];
    }
    ```


   5. To use ad events:

    _**(Required)**_
    ```objc
    -(void)rewardedVideoDidComplete:(AdcashRewardedVideo *)rewardedVideo withReward:(int)reward;
    ```
    > This method is called when user completed watching rewarded video and it's time to reward the user.
    Example below

    ```objc
    -(void)rewardedVideoDidComplete:(AdcashRewardedVideo *)rewardedVideo withReward:(int)reward
    {
        user.coins += reward;
        //or you can disregard "reward" value and use your own, if you have other algorithms
        //to reward the user.
    }
    ```

    _**(Optional)**_ You can catch status updates from your video by implementing the optional methods in  `AdcashRewardedVideoDelegate` protocol:
   ```objc
   -(void) RewardedVideoDidReceiveAd: (AdcashRewardedVideo *)video;
   -(void) RewardedVideoDidFailToReceiveAd:(AdcashRewardedVideo *)video withError:(NSError *)error;
   -(void) RewardedVideoWillPresentScreen:(AdcashRewardedVideo *)video;
   -(void) RewardedVideoWillDismissScreen:(AdcashRewardedVideo *)video;
   -(void) RewardedVideoDidDismissScreen:(AdcashRewardedVideo *)video;
   -(void) RewardedVideoWillLeaveApplication:(AdcashRewardedVideo *)video;
   ```

---
##Native Advertisements

Native is an ad format that is rendered by the publisher, allowing them to give users a unique experience with finely tuned look and design.

Here is how you can integrate a native ad into your app just in few steps :
  1. Import `AdcashSDK.h` header file into your view controllers file;

  ```objc
  #import<AdcashSDK.h>
  ```
  2. Declare a native ad property in your header file and make your view controller conform to the `AdcashNativeDelegate` protocol. Your interface should look like this;

  ```objc
  @interface ViewController : UIViewController<AdcashNativeDelegate>
  @property (nonatomic,strong) AdcashNative *native;
  @end
  ```
  3. To load the native ad, call;

  ```objc

  self.native = [[AdcashNative alloc] initAdcashNativeWithZoneID:@“<YOUR_ZONE_ID>”];
  self.native.delegate = self;
  ```

  4. After loading, if response is successful, native instance is filled with information about the ad, that contains:

    >Title

    >Description

    >Rating

    >Icon

    >Image

    >Action button text

  to get these values, you should use the provided functions below:   

   ```objc
   -(NSString *)getAdTitle;
   -(NSString *)getAdDescription;
   -(NSString *)getAdRating;
   -(NSURL *)getAdIcon;
   -(NSURL *)getAdImage;
   -(NSString *)getAdButtonText;
   ```


  5. To use ad events:

   ```objc
   -(void)AdcashNativeAdReceived:(AdcashNative *)native;
   -(void)AdcashNativeFailedToReceiveAd:(AdcashNative *)native withError:(NSError *)error;
   ```



##App Transport Security

With the release of iOS 9, Apple introduced a new default setting, called App Transport Security(ATS). ATS requires apps to make network connection only over SSL. It also allows specific encryption ciphers,SSL version and key length to be used when creating HTTPS connections.

Therefore, all iOS 9 devices running apps built with Xcode 7 that doesn’t disable ATS will be affected by this change. When a non-ATS compliant app attempts to serve an ad via HTTP on iOS 9, the following message appears:
>App Transport Security has blocked a cleartext HTTP(http://) resource load since it is insecure. Temporary exceptions can be configured via your app’s Info.plist file.

While Adcash acknowledges the need for secure connections, our ad network is not ready yet with the compliance of the requirements. Therefore, Adcash iOS SDK will work only by disabling App Transport Security in your Info.plist. You can do so by using one of the following two ways depending on your preference:

   1.**Disable ATS for all domains**

   This is the easiest solution. Right click on your **Info.plist** and select **Open As > Source Code**, then paste the snippet below at the end of the code.


      <key>NSAppTransportSecurity</key>
      <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
      </dict>

   It should look like this;
   ![Alt text](http://i1.wp.com/developer.adca.sh/wp-content/uploads/2015/10/app_transport_security_option1.png)

   2.**Disable ATS for all domains, with some exceptions**

   You may only want ATS to work on domains you specifically know can support it. For example, if you knew that your server supports ATS and you would want things like login calls, and other requests to your server to use ATS, but ad requests to Adcash to bypass ATS requirements.

   In this case you should set **NSAllowsArbitraryLoads** to true, then define the URLs that you want to be secure in your NSExceptionDomains dictionary. Each domain you wish to be secure should have its own dictionary, and the NSExceptionAllowsInsecureHTTPLoads for that dictionary should be set to false.


      <key>NSAppTransportSecurity</key>
      <dict>
         <key>NSAllowsArbitraryLoads</key>
         <true/>
         <key>NSExceptionDomains</key>
         <dict>
            <key>secure.yourdomain.com</key>
            <dict>
               <key>NSExceptionAllowsInsecureHTTPLoads</key>
               <false/>
            </dict>
         </dict>
      </dict>


   It should look like this;
   ![Alt text](http://i0.wp.com/developer.adca.sh/wp-content/uploads/2015/10/app_transport_security_option2.png)
   >If you do not follow the above instructions for apps built on Xcode 7, monetisation will be severely impacted as some connections might fail resulting in the ads not rendering.

##License
[License](https://github.com/adcash/ios-sdk/blob/master/LICENSE.md)

##Support
If you need any support or assistance you can contact us by sending email to mobile@adcash.com.
