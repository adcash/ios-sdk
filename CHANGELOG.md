# Changelog
---

## Version 1.3.0

Released on 08 October 2015.

* iOS 9 support
	* `[UIApplication canOpenURL:]` is not used anymore. Therefore you do not have to specify scheme exceptions in your `Info.plist`.
	* Delegate methods `[ACBannerViewDelegate bannerViewWillLeaveApplication:]` and `[ACInterstitialDelegate interstitialWillLeaveApplication:]` will not always be followed by entering the app in background mode, so you should not rely on this assumption.
	* Documented the recommended way to use App Transport Security. You may take a look at the example project for an example.

	> Please note that this release does not have bitcode support yet. If you are using Xcode 7, then you have to set build setting ENABLE_BITCODE=NO
* Fixed some warnings in Xcode 7 related to minimum deployment target.

## Version 1.2.0

Released on 23 March 2015.

* Initial release.
