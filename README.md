
#**Adcash iOS SDK v2.2.0**

##Release notes
- Video advertisements
- Statistics improvements
- Refresh rate setting moved to publisher panel
- Conversion tracking parameters changed
- Bitcode support
- Accidental clicks optimized
- UI enhancements
- Debug mode*

> *When your application is not running on real device, you will get placeholder ads for interstitial and banner.

---

This is a step by step guide that describes how to download and integrate Adcash iOS SDK to your application for monetisation.

The methods for adding an advertisement types are included for;
* Banner Advertisements
* Interstitial advertisements
* Video advertisements

And also if you are an advertiser, Conversion Tracking section is for you.

**Prerequisites**
* Zone ID(s) that you created at [Adcash platform](https://www.myadcash.com/)
* [Adcash iOS SDK](https://github.com/adcash/ios-sdk/blob/master/AdcashSDKiOS_beta.zip)
* Xcode 5 or higher
* Project deployment target iOS 6.0 or higher

**Integration with CocoaPods :**

> _Integration with Cocoapods will be added_

**Manual Integration :**

1. Download the [Adcash iOS SDK](https://github.com/adcash/ios-sdk/blob/master/AdcashSDKiOS_beta.zip) and unzip it.
2. Right click on your project in the **Project Navigator** menu and select **Add Files to "name-of-your-project"**:
![Alt text](http://i2.wp.com/104.197.107.57/wp-content/uploads/2015/08/install-instructions-2.png)
3. Select the AdcashSDK folder you just unzipped and press **Add**. Make sure you choose **Copy items if needed**.
![Alt text](http://i2.wp.com/104.197.107.57/wp-content/uploads/2015/08/install-instructions-3.png)
4. Add the **-ObjC** linker flag to your project by going to **Build Settings > Other Linker Flags** :
![Alt text](http://i0.wp.com/104.197.107.57/wp-content/uploads/2015/08/install-instructions-4.png)
5. **Build** and **Run**. Your project should start without any errors.

---

##Banner Advertisements

Banner advertisements are the most common advertising formats. They consist of an image and a link that leads user to a website. The images can be animated or static. Banner advertisements cover the entire width of the screen and are usually placed on the bottom or the top of the screen.

###Banner Size

The Adcash iOS SDK currently only supports one banner size, Smart Banners. Smart Banners are the ad units with a screen-wide width and their height depends on the size of the device. The table below shows how the Smart Banner size varies in different devices :

Height | Device | Device Orientation
------------ | ------------- | ------------
50 | Phone | Portrait, Landscape
90 | Tablet | Portrait, Landscape
>Note : All sizes are in dp(density-independent pixels).

###Adding a Banner Advertisement

   Here is how you can integrate a banner into your app just in few steps :
   1. Import AdcashSDK.h header file in your view controller's file;
   
   ```objc
   #import<AdcashSDK.h>
   ```
   2. Set your view controller to conform to ADCBannerViewDelegate protocol;
   
   ```objc
      @interface ViewController () <ADCBannerViewDelegate>
      ...
   	@end
   ```
   3. Add the following code to viewDidLoad: method of your view controllers .m file;

   ```objc
      //Initialize the banner
      ADCBannerView *bannerView = [[ADCBannerView alloc] initWithAdSize:ADCAdSizeSmartBanner
   	                                                    zoneID:@“<YOUR_ZONE_ID>”
                                                     rootViewController:self];

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
   
   4. (Optional)You can catch status updates from your banner by implementing the optional methods in ADCBannerViewDelegate protocol:
     ```objc
      -(void) bannerViewDidReceiveAd: (ADCBannerView *)bannerView;
      -(void) bannerView: (ADCBannerView *)bannerView didFailToReceiveAdWithError:(NSError *)error;
      -(void) bannerViewWillPresentScreen: (ADCBannerView *) bannerView;
      -(void) bannerViewWillLeaveApplication:(ADCBannerView *) bannerView;
      -(void) bannerViewWillDismissScreen: (ADCBannerView *) bannerView;
      ```
      
---
##Interstitial Advertisements

Interstitials are full screen advertisement formats that can be displayed either horizontally or vertically on screen of the device and typically generate a higher click rate. The best time to show an interstitial is usually on application launch or in transition points (e.g. between game levels).

###Adding an Interstitial Advertisement

   Here is how you can integrate an interstitial into your app just in few steps :
   1. Import AdcashSDK.h header file in your view controller's file;
   
   ```objc
   #import<AdcashSDK.h>
   ```
   2. Declare an interstitial property in your file and make your view controller conform to the ADCInterstitialDelegate protocol. Your interface should look like this;
   
   ```objc
   @interface ViewController : UIViewController <ADCInterstitialDelegate>
@property (nonatomic,strong) ADCInterstitial *interstitial;
@end
   ```
   3. Add the following code to the viewDidLoad: method;
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
   5. (Optional)You can catch other status updates of your interstitial by implementing the optional methods in ADCInterstitialDelegate protocol;
   
   ```objc
      -(void) interstitialDidReceiveAd: (ADCInterstitial *)interstitial;
      -(void) interstitial: (ADCInterstitial *)interstitial didFailToReceiveAdWithError:(NSError *)error;
      -(void) interstitialWillPresentScreen: (ADCInterstitial *)interstitial;
      -(void) interstitialWillDismissScreen: (ADCInterstitial *)interstitial;
      -(void) interstitialWillLeaveApplication: (ACInterstitial *)interstitial;
      ```

---
##Video Advertisements

Video advertisements are full screen ad formats that can be displayed either horizontally or vertically on the screen of the device and typically generate higher click rate.

###Adding a Video Advertisement

   Here is how you can integrate a video into your app just in few steps :
   1. Import AdcashSDK.h header file into your view controllers file;
   
    ```objc
   #import<AdcashSDK.h>
   ```
   2. Declare a video property in your file :
   
    ```objc
   @interface ViewController : UIViewController
@property (nonatomic,strong) ADCVideo *video;
@end
   ```
   3. Add the following code to viewDidLoad: method;
   
    ```objc
   //Assign ADCVideo instance to your property.
self.video = [[ADCVideo alloc] initVideoWithZoneID:@“<YOUR_ZONE_ID>”];
   ```
    4. (Optional)You can catch status updates from your video by implementing the optional methods in  ADCVideoDelegate protocol:
    ```objc
    -(void) videoDidReceiveAd: (ADCVideo *)video;
    -(void) videoDidFailToReceiveAd:(ADCVideo *)video withError:(NSError *)error;
    -(void) videoWillPresentScreen:(ADCVideo *)video;
    -(void) videoWillDismissScreen:(ADCVideo *)video;
    -(void) videoDidDismissScreen:(ADCVideo *)video;
    -(void) videoWillLeaveApplication:(ADCVideo *)video;
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
   >If you do not follow the above instructions for apps built on Xcode 7, monetisation will be severely impacted as some >connections might fail resulting in the ads not rendering.
   
##Conversion Tracking

Conversion tracking allows advertisers to track user actions on their app(e.g. app downloads, new in-app purchases).

You can easily integrate conversion tracking into your app with the Adcash iOS SDK or by manually sending a server-to-server request to a provided URL.

###Server-to-server (S2S) Tracking

To help launch CPI campaigns, we provide the capability to send Install tracking information via a server-to-server integration so that advertiser apps do not need to be updated specifically for Adcash ads.

Perform the following steps for integration:

**Step 1:** Your app should send a request to your tracking system.

**Step 2:** Your app needs to notify the Adcash tracking system by sending an
HTTP GET request to the post-back URL.

Notes on post-back URLs:

You can get the post-back URL directly from the Conversion Tracking page of your user account.
The post-back URL will depend on the tracking option you choose. Example URLs of each tracking option is below:

**1. Single Campaign**

 > http://imcounting.com/ad/event.php?type=Installation&campaign=123456&cid=12356&udid=549B0538-5B7D-4C93-ACDA-FE79583ED645&variable=XX

**2. Multiple Campaigns**

 > http://imcounting.com/ad/event.php?type=Installation&list=2253241,226453&cid=12356&udid=549B0538-5B7D-4C93-ACDA-FE79583ED645&variable=XX

**3. Global Campaigns**

 > http://imcounting.com/ad/event.php?type=Installation&advertiser=4444&cid=12356&udid=549B0538-5B7D-4C93-ACDA-FE79583ED645&variable=XX

The values for type, campaign, list, and advertiser are auto-populated by Adcash when the S2S call is generated.

The advertiser needs to populate the values for the cid, variable and udid parameters.

Below is a table of the post-back URL parameters and their descriptions:  

Parameter | Description 
------------ | ------------- 
type | Type of Event ex. Registration, Installation, Sale(auto-populated) 
campaign | Campaign ID(auto-populated)
cid | Click ID associated with event(input manually by advertiser)
variable | For any extra information such as Email ID etc.(input manually by advertiser)
list | Comma seperated Campaign ID's(auto-populated)
advertiser | Advertiser ID(auto-populated)
udid | Unique Identifier
   
##License
[License](https://github.com/adcash/ios-sdk/blob/master/LICENSE.md)

##Support
If you need any support or assistance you can contact us by sending email to mobile@adcash.com.