##Version 3.0.0

###1. Added

#####1. iOS 9 Support

The SDK now properly supports iOS 9.

##Version 2.9.0

###1. Added

#####1. In-App WebView Events

The SDK now supports tracking events in WebViews handled by the app.

##Version 2.7.0

###1. Added

#####1. Cookie Mapping

You can now enable cookie mapping which causes each deep linked Push notification to redirect the user to the Mobile Web browser on the device (Safari on iOS), set a first party cookie on the RadiumOne domain and bring the user back to the Deep Link section of the App as intended by the custom url. This behavior is only seen once in the lifetime of the cookie or if the IDFA of the user has changed. All future deep link Push notifications will take the user straight to the deep linked section of the app.

##Version 2.6.0

###1. Added

#####1. Rich Push Inbox Feature

The SDK now includes the ability to create an inbox that will house rich pushes.  You have the ability to store, read, delete, and display the count of rich push messages in your application.  The inbox will still function when the user disbles push notifications. 

##Version 2.5.0

###1. Added

#####1. Debugging with SDK Tools on the Portal

You can now see the JSON data sent when triggered by events in your application. You will be able to see the events in the SDK Tools section on the portal. To enable the debugging tool, you should create a flat file titled "r1DebugDevices" with a list of IDFAs and add it to your project root through File -> Add Files to "Project.". There should be one ID per line.

##Version 2.4.0

###1. Added

#####1. Rich push and deep linking support

The SDK now supports sending rich and deep-linking push messages.  Rich push messages open an HTML page.  Deep-linking push messages open a specific page in your application rather than your home screen.

##Version 2.3

Bug fix for a push refactor in 2.2.2 that prevented the SDK from registering for push notifications if it had already done so (in the case of an update, uninstall / reinstall, or third party token collection).  This issue affected all devices with iOS8.  As a result, our backend servers were unable to send push messages through apple to these devices.  The fix forces the app to register for push notifications on every startup.

##Version 2.2.2

Push messaging iOS8 support.  iOS8 users with older versions of the SDK will not properly register for or receive push messages.

##Version 2.1.0

###1. Updated

#####1. Emit Registration

Before:
```objc
[[R1Emitter sharedInstance] emitRegistrationWithUserID:@"userId"
                                              userName:@"userName"
   	                                             email:@"user@email.com"
       	                                 streetAddress:@"streetAddress"
           	                                     phone:@"phone"
               	                                  city:@"city"
                  		                         state:@"state"
                			                       zip:@"zip"
                                        	  otherInfo:@{@"custom_key":@"value"}];
```

Current:
```objc
[[R1Emitter sharedInstance] emitRegistrationWithUserID:@"userId"
                                              userName:@"userName"
                                               country:@"country"
                                                 state:@"state"
                                                  city:@"city"
                                             otherInfo:@{@"custom_key":@"value"}];
```

#####2. Emit Facebook connect

Before:
```objc
NSArray *permissions = @[[R1EmitterSocialPermission socialPermissionWithName:@"photos" granted:YES]];

[[R1Emitter sharedInstance] emitFBConnectWithUserID:@"12345"
                                       	userName:@"user_name"
                                      	 permissions:permissions
                                  		   otherInfo:@{@"custom_key":@"value"}];
```

Current:
```objc
NSArray *permissions = @[[R1EmitterSocialPermission socialPermissionWithName:@"photos" granted:YES]];

[[R1Emitter sharedInstance] emitFBConnectWithPermissions:permissions
                                  				     otherInfo:@{@"custom_key":@"value"}];
```

#####3. LineItem object

Renamed *productID* property to *itemID*

Before:
```objc
R1EmitterLineItem *lineItem = ...

lineItem.productID = @"Line Item ID";
```

Current:
```objc
R1EmitterLineItem *lineItem = ...

lineItem.itemID = @"Line Item ID";
```


###2. Added

#####1. Emit User Info

```objc
R1EmitterUserInfo *userInfo = [R1EmitterUserInfo userInfoWithUserID:@"userID"
                           userName:@"userName"
                              email:@"email"
                          firstName:@"firstName"
                           lastName:@"lastName"
                      streetAddress:@"streetAddress"
                              phone:@"phone"
                               city:@"city"
                              state:@"state"
                                zip:@"zip"];

[[R1Emitter sharedInstance] emitUserInfo:@"userId"
                               otherInfo:@{@"custom_key":@"value"}];
```
#####2. Advertising Enabled

```objc
[R1SDK sharedInstance].advertisingEnabled=NO


```

###3. Deprecated

#####1. Emit Action

Method *emitActive* deprecated.
Use *emitEvent* instead.

Before:
```objc
[[R1Emitter sharedInstance] emitAction:@"Button pressed"
               			  				  label:@"About"
                       				  value:10
                  				  otherInfo:@{@"custom_key":@"value"}];
```

Current:
```objc
[[R1Emitter sharedInstance] emitEvent:@"Button pressed"
			  			withParameters:@{@"label":@"About", @"value":@10, @"custom_key":@"value"}];
```

#####2. sessionStart property
