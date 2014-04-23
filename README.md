#Table of Contents
- [1. System Requirements](#user-content-1-system-requirements)
- [2. SDK Initialization](#user-content-2-sdk-initialization)
	- [a. Import Files](#user-content-a-import-files)
	- [b. Link the Static Library](#user-content-b-link-the-static-library)
	- [c. Initialize the SDK](#user-content-c-initialize-the-sdk)
	- [d. Advanced Settings](#user-content-d-advanced-settings)
- [3. Feature Activation](#user-content-3-feature-activation)
	- [a. Analytics Activation (optional)](#user-content-a-analytics-activation)
		- [i. Automatic Events](#user-content-i-automatic-events)
		- [ii. Standard Events](#user-content-ii-standard-events)
		- [iii. Custom Events](#user-content-iii-custom-events)
		- [iv. Best Practices](#user-content-iv-best-practices)
	- [b. Push Notification Activation (optional)](#user-content-b-push-notification-activation)
		- [i. Initialization](#user-content-i-initialization)
		- [ii. Setup Apple Push Notification Services](#user-content-ii-setup-apple-push-notification-services)
		- [iii. Segment your Audience](#user-content-iii-segment-your-audience)
	- [c. Attribution Tracking Activation (optional)](#user-content-c-attribution-tracking-activation)
		- [i. Track RadiumOne Campaigns](#user-content-i-track-radiumone-campaigns)
		- [ii. Track 3rd party Campaigns](#user-content-ii-track-3rd-party-campaigns)
		

#1. System Requirements
The R1 Connect SDK supports all mobile and tablet devices running iOS 5.0 with Xcode 4.5 and above. The downloadable directory (see below "[a. Import Files](#a-import-files)") contains the library and headers of the R1 Connect SDK for iOS. 

The library supports the following architectures:

*       arm7
*	arm7s
*	arm64
*	i386
*	x86_64

It supports iOS 5 and up.

#2. SDK Initialization

## a. Import Files
1.	Download the r1connect lib files:
           git clone git@github.com:radiumone/r1-connect-demo-iOS.git
2.	Open up your iOS project in xCode.
3.	Select File -> Add Files to “[YOUR XCODE PROJECT]” project
4.	Select all files in "Lib" Folder from the repo you just cloned
5.	When the dialog box appears, check the Copy Items into destination group’s folder checkbox.
 


<img src="https://raw.github.com/radiumone/r1-connect-demo-iOS/readme_images/ReadmeImages/library_files.png"  width="440" />

## b. Link the Static Library
Go to "Build Phases" and make sure LibR1Connect.a file is set in the “Link Binary With Libraries” section. If it’s absent, please add it.

Make sure you also add:

+	AdSupport.framework
+	CoreTelephony.framework
+	SystemConfiguration.framework
+	libsqlite3.dylib
+	CoreLocation.framework


 <img src="https://raw.github.com/radiumone/r1-connect-demo-iOS/readme_images/ReadmeImages/link_with_binary.png"  width="440" />

 
Check Background modes switch is turned on in Capabilities tab for your target. If it’s turned off, please turn on.
 
## c. Initialize the SDK
You will need to initialize the R1 Connect Library in your App Delegate.
####Import the required header files
At the top of your application delegate include any required headers:


```objc
#import "R1SDK.h"
#import "R1Emitter.h"
```


####Initialize R1Connect Instance


```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:
(NSDictionary *)launchOptions {     
    R1SDK *sdk = [R1SDK sharedInstance];  
    
    // Initialize Anlaytics      
    sdk.applicationId = @"[YOUR APPLICATION ID]";  //Ask your RadiumOne contact for an app id
    
    [R1Emitter sharedInstance].appVersion = @"1.0.2";
    [R1Emitter sharedInstance].appId = @"12345678";
    
    // Start SDK     
   [sdk start];      
    return YES; 
}
```

## d. Advanced Settings
The following is a list of configuration parameters for the R1 Connect SDK, most of these contain values that are sent to the tracking server to help identify your app on our platform and to provide analytics on sessions and location.

####Configuration Parameters

***applicationUserId***

Optional current user identifier.
```objc
[R1SDK sharedInstance].applicationUserId = @"12345";
```

***location***

The current user location coordinates. Use it only if your application already uses location services.

```objc
[R1SDK sharedInstance].location = [locations lastObject];
```

***locationService***

If your application did not use location information before this SDK installation, you can use locationService in this SDK to enable or disable it:

```objc
[R1SDK sharedInstance].locationService.enabled = YES;
```

When enabled, such as in the example above, location information will be sent automatically. However, locationService doesn’t fetch the location constantly. For instance, when the location is received the SDK will turn off the location in CLLocationManager and wait 10 minutes (by default) before attempting to retrieve it again. You can change this value:
```objc
[R1SDK sharedInstance].locationService.autoupdateTimeout = 1200; // 20 minutes
```

***appName***

The application name associated with emitter. By default, this property is populated with the `CFBundleName` string from the application bundle. If you wish to override this property, you must do so before making any tracking calls.
		
```objc
[R1Emitter sharedInstance].appName = @"Custom application name";
```

***appId***

Default: nil

The application identifier associated with this emitter.  If you wish to set this property, you must do so before making any tracking calls. Note: that this is not your app's bundle id, like e.g. com.example.appname.

```objc
[R1Emitter sharedInstance].appId = @"12345678";
```

***appVersion***

The application version associated with this emitter. By default, this property is populated with the `CFBundleShortVersionString` string from the application bundle. If you wish to override this property, you must do so before making any tracking calls.

```objc
[R1Emitter sharedInstance].appVersion = @"1.0.2";
```

***sessionStart***

If true, indicates the start of a new session. Note that when a emitter is first instantiated, this is initialized to true. To prevent this default
 behavior, set this to `NO` when the tracker is first obtained.
 
 By itself, setting this does not send any data. If this is true, when the next emitter call is made, a parameter will be added to the resulting emitter
 information indicating that it is the start of a session, and this flag will be cleared.

```objc
[R1Emitter sharedInstance].sessionStart = YES;
// Your code here
[R1Emitter sharedInstance].sessionStart = NO;
```

***sessionTimeout***

If non-negative, indicates how long, in seconds, the application must transition to the inactive or background state for before the tracker will automatically indicate the start of a new session when the app becomes active again by setting sessionStart to true. For example, if this is set to 30 seconds, and the user receives a phone call that lasts for 45 seconds while using the app, upon returning to the app, the sessionStart parameter will be set to true. If the phone call instead lasted 10 seconds, sessionStart will not be modified.
 
To disable automatic session tracking, set this to a negative value. To indicate the start of a session anytime the app becomes inactive or backgrounded, set this to zero.
 
By default, this is 30 seconds.

```objc
[R1Emitter sharedInstance].sessionTimeout = 15;
```

#3. Feature Activation
##a. Analytics Activation
### i. Automatic Events


The R1 Connect SDK will automatically capture some generic events, but in order to get the most meaningful data on how users interact with your app the SDK. These events are triggered when the state of the application is changed and, therefore, they do not require any additional code to be written in the app in order to work out of the box:

**Launch** - emitted when the app starts

**First Launch** - emitted when the app starts for the first time

**First Launch After Update** - emitted when the app starts for the first time after a version upgrade

**Suspend** - emitted when the app is put into the background state

**Resume** - emitted when the app returns from the background state

**Application Opened** - This event is very useful for push notifications and can measure when your app is opened after a message is sent.

**Session Start** - As the name implies the Session Start event is used to start a new session.

**Session End** - The Session End event is used to end a session and passes with it a Session Length attribute that calculates the session length in seconds.


### ii. Standard Events

Standard Events give you an easy way to cover all the main user flows (login, register, share, purchase...) in a standardized format for optimized reporting on the portal. They provide some great foundation for your analytics strategy. Once you set them up in your code, they unlock great insights, especially on user lifetime value.

*Note: The last argument in all of the following emitter callbacks, otherInfo, is a dictionary of “key”,”value” pairs or nil, which enables you to customize these events as much as you want.*

**Login**

Tracks a user login within the app

```objc
[[R1Emitter sharedInstance] emitLoginWithUserID:@"userId"
                           	       userName:@"user_name"
                         	      otherInfo:@{@"custom_key":@"value"}];
```

**Registration**

Records a user registration within the app

```objc
[[R1Emitter sharedInstance] emitRegistrationWithUserID:@"userId"
                                              userName:@"userName"
                                               country:@"country"
                                                 state:@"state"
                                                  city:@"city"
                                             otherInfo:@{@"custom_key":@"value"}];
```

**Facebook connect**

Allows access to Facebook services

```objc
NSArray *permissions = @[[R1EmitterSocialPermission socialPermissionWithName:@"photos" granted:YES]];

[[R1Emitter sharedInstance] emitFBConnectWithPermissions:permissions
                                  	       otherInfo:@{@"custom_key":@"value"}];
```

**Twitter connect**

Allows access to Twitter services

```objc
NSArray *permissions = @[[R1EmitterSocialPermission socialPermissionWithName:@"photos" granted:YES]];

[[R1Emitter sharedInstance] emitTConnectWithUserID:@"12345"
                                          userName:@"user_name"
                                       permissions:permissions
                                  	 otherInfo:@{@"custom_key":@"value"}];
```

**User Info**

This event enables you to send user profiles to the backend.

```objc
R1EmitterUserInfo *userInfo = [R1EmitterUserInfo userInfoWithUserID:@"userId"
                           userName:@"userName"
                              email:@"user@email.com"
                          firstName:@"first name"
                           lastName:@"last name"
                      streetAddress:@"streetAddress"
                              phone:@"phone"
                               city:@"city"
                              state:@"state"
                                zip:@"zip"];

[[R1Emitter sharedInstance] emitUserInfo:@"userId"
                               otherInfo:@{@"custom_key":@"value"}];
```

**Upgrade**

Tracks an application version upgrade

```objc
[[R1Emitter sharedInstance] emitUpgradeWithOtherInfo:@{@"custom_key":@"value"}];
```

**Trial Upgrade**

Tracks an application upgrade from a trial version to a full version

```objc
[[R1Emitter sharedInstance] emitTrialUpgradeWithOtherInfo:@{@"custom_key":@"value"}];
```

**Screen View**

Basically, a page view, it provides info about that screen

```objc
[[R1Emitter sharedInstance] emitScreenViewWithDocumentTitle:@"title"
                            					 contentDescription:@"description"
                           						documentLocationUrl:@"http://www.example.com/path"
                              					   documentHostName:@"example.com"
                                  					   documentPath:@"path"
                                     					  otherInfo:@{@"custom_key":@"value"}];
```

**Transaction**

```objc
[[R1Emitter sharedInstance] emitTransactionWithID:@"transaction_id"
                                  	  storeID:@"store_id"
                                 	storeName:@"store_name"
                                    	   cartID:@"cart_id"
                                   	  orderID:@"order_id"
                                 	totalSale:1.5
                                  	 currency:@"USD"
                             	    shippingCosts:10.5
                            	   transactionTax:12.0
                                 	otherInfo:@{@"custom_key":@"value"}];
```

**TransactionItem**

```objc
R1EmitterLineItem *lineItem = [R1EmitterLineItem itemWithID:@"product_id"
                              			       name:@"product_name"
                          			   quantity:5
                     			      unitOfMeasure:@"unit"
                          			   msrPrice:10
                         			  pricePaid:10
                          			   currency:@"USD"
                      			       itemCategory:@"category"];

[[R1Emitter sharedInstance] emitTransactionItemWithTransactionID:@"transaction_id"
                                                 	lineItem:lineItem
                                                       otherInfo:@{@"custom_key":@"value"}];
```

**Create Cart**

```objc
[[R1Emitter sharedInstance] emitCartCreateWithCartID:@"cart_id"
                                	   otherInfo:@{@"custom_key":@"value"}];
```

**Delete Cart**

```objc
[[R1Emitter sharedInstance] emitCartDeleteWithCartID:@"cart_id"
                       			   otherInfo:@{@"custom_key":@"value"}];
```

**Add To Cart**

```objc
R1EmitterLineItem *lineItem = [R1EmitterLineItem itemWithID:@"product_id"
                              			       name:@"product_name"
                          			   quantity:5
                     			      unitOfMeasure:@"unit"
                          			   msrPrice:10
                         			  pricePaid:10
                          			   currency:@"USD"
                      			       itemCategory:@"category"];

[[R1Emitter sharedInstance] emitAddToCartWithCartID:@"cart_id"
        				   lineItem:lineItem
                                 	  otherInfo:@{@"custom_key":@"value"}];
```

**Delete From Cart**

```objc
R1EmitterLineItem *lineItem = [R1EmitterLineItem itemWithID:@"product_id"
                              			       name:@"product_name"
                          			   quantity:5
                     			      unitOfMeasure:@"unit"
                          			   msrPrice:10
                         			  pricePaid:10
                          			   currency:@"USD"
                      			       itemCategory:@"category"];

[[R1Emitter sharedInstance] emitDeleteFromCartWithCartID:@"cart_id"
        					lineItem:lineItem
                                 	       otherInfo:@{@"custom_key":@"value"}];
```


###iii. Custom Events



With custom events you have the ability to create and track specific events that are more closely aligned with your app. If planned and structured correctly, custom events can be strong indicators of user intent and behavior. Some examples include pressing the “like” button, playing a song, changing the screen mode from portrait to landscape, and zooming in or out of an image. These are all actions by the user that could be tracked with events.

To include tracking of custom events for the mobile app, the following callbacks need to be included in the application code:

```objc
// Emits a custom event without parameters
[[R1Emitter sharedInstance] emitEvent:@"Your custom event name"];

// Emits a custom event with parameters
[[R1Emitter sharedInstance] emitEvent:@"Your custom event name"
			  			   withParameters:@{"key":"value"}];
```


###iv. Best Practices
####Event Naming Convention
One common mistake is to parametrize event names (with user data for example). Event names should be hard-coded values that you use to segement data on a specific category of event. 

Example: "ProfileViewing"

Avoid: "Profile Viewing - Lady Gaga's profile"

As you may have thousands of user profiles in your database, it is preferable to keep the event name high level ("ProfileViewing") so you can run interesting anaytics on it. For example, it will be much easier to answer this question: "how many profiles does a user visit every day on average?". 

####Parameter Variance

Another common mistake is to add parameters to the event that have too many possible values. To follow up on the previous example, one may decide to add the number of profile followers as an event parameter:

```objc
[[R1Emitter sharedInstance] emitEvent:@"ProfileViewing"
			withParameters:@{"profileFollowers":profileFollowers}];
```
			  			   
Again, the problem here is that each profile may have any number of followers. This will result in having your data much too fragmented to extract any valuable information.

Instead, a good strategy would be to define relevant buckets to replace high variance parameters. For example, in this case, it might be more relevant to separate traffic on the profiles with a lot of followers from traffic on frofiles with very few followers. You could define 3 categories: 

- "VERY_INFLUENTIAL" for profiles > 100,000 
- "INFLUENTIAL" for profile > 10,000 and <= 100,000
- "NON_INFLUENTIAL" for profile <= 10,000

Then a proper event would be 

```objc
[[R1Emitter sharedInstance] emitEvent:@"ProfileViewing"
			withParameters:@{"profileFollowersBucket":@"VERY_INFLUENTIAL"}];
```

			  			   
This will enable you to create much more insightful reports.

##b. Push Notification Activation

###i. Initialization


####Setup your App Delegate


```objc
#import "R1SDK.h"
#import "R1Emitter.h"
#import "R1Push.h"
```


```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    R1SDK *sdk = [R1SDK sharedInstance];
    
    // Initialize SDK
    sdk.applicationId = @"[Application ID]";  //Ask your RadiumOne contact for an app id
    
    // Initialize Push Notification
    sdk.clientKey = @"[Your Client Key]";  //Ask your RadiumOne contact for a client key
    [[R1Push sharedInstance] handleNotification:[launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey]
                                 applicationState: application.applicationState];
    [[R1Push sharedInstance] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                                 UIRemoteNotificationTypeSound |
                                                                 UIRemoteNotificationTypeAlert)];
    
    // Start SDK
    [sdk start];
    return YES;
}
```


####Register for Remote Notifications



```objc
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[R1Push sharedInstance] registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [[R1Push sharedInstance] failToRegisterDeviceTokenWithError:error];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[R1Push sharedInstance] handleNotification:userInfo applicationState:application.applicationState];
}
```
 
Push is disabled by default. You can enable it in the *application:didFinishLaunchingWithOptions* method or later.

```objc
[[R1Push sharedInstance] setPushEnabled:YES];
```


NOTE: If you enabled it in the *application:didFinishLaunchingWithOptions* method, the Push Notification AlertView will be showed at first application start.


###ii. Setup Apple Push Notification Services

####Prerequisites for Apple Push Notification Services Setup
######The Importance of Setting your App as in “Production” or in “Development”
When creating or editing an app on RadiumOne Connect you can set the status of the app to either “Production” or “Development”. “Production” status for an app is considered to be a live app that is in the hands of real users and will have notifications and other data running on live servers. A “Development” status for an app is one that you are still performing testing on and will not be viewed by any real-life audiences because it will stay on test servers.

In the context of push notifications, it is important to know this difference because Apple will treat these two servers separately. Also device tokens for “Development” will not work on “Production” and vice versa. We recommend a Development app version and Production app version for your app on RadiumOne Connect to keep Push SSL certificates separate for each. You can also continue testing and experimenting on one app without worrying about it affecting your live app audience in any way.
######iOS Developer Program Enrollment
This doc assumes that you are enrolled in the iOS Developer Program. If you are not, please enroll [here](https://developer.apple.com/programs/ios/). Being in the Apple Developer Program is a required component to have your iOS app communicate with the RadiumOne Connect service for push notifications and is necessary for the next step of setting up your app with the Apple Push Notification Service (APNs). It is also essential that you have “Team Agent” role access in the iOS Developer Program to complete this process.

####Configuring your App for Apple Push Notifications
######Apple Developer Members Center
Make sure you are logged into the [Apple Developer Members Center](https://daw.apple.com/cgi-bin/WebObjects/DSAuthWeb.woa/wa/login?&appIdKey=891bd3417a7776362562d2197f89480a8547b108fd934911bcbea0110d07f757&path=%2F%2Fmembercenter%2Findex.action). Once you are logged in you can locate your application in the “Identifiers” folder list.

![Files in xCode project](http://mcpdemo.herokuapp.com/static/img/help/ios_integration/image001.jpg)

######Registered App ID
If you have not registered an App ID yet it is important that you do so now. You will need to click the “+” symbol, fill out the form, and check the “Push Notifications” checkbox. Please keep in mind it is possible to edit these choices after the App ID is registered.


![Files in xCode project](http://mcpdemo.herokuapp.com/static/img/help/ios_integration/image002.jpg)
![Files in xCode project](http://mcpdemo.herokuapp.com/static/img/help/ios_integration/image003.jpg)

You can expand the application and when doing so you will see two settings for push notifications. They will have either yellow or green status icons like here:

![Files in xCode project](http://mcpdemo.herokuapp.com/static/img/help/ios_integration/image004.jpg)

You will need to click Edit to continue. If the Edit button is not visible it is because you do not have “Team Agent” role access. This role is necessary for getting an SSL certificate.

######Creating an SSL Certificate
To enable the Development or Production Push SSL Certificate please click Edit. (It is important to note that each certificate is limited to a single app, identified by its bundle ID and limited to one of two environments, either Development or Production. Read more info [here](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Chapters/ProvisioningDevelopment.html#//apple_ref/doc/uid/TP40008194-CH104-SW1).)

![Files in xCode project](http://mcpdemo.herokuapp.com/static/img/help/ios_integration/image005.jpg)


You will see a Create Certificate button, after clicking it you will see the “Add iOS Certificate Assistant”. Please follow the instructions presented in the assistant which includes launching the “Keychain Access” application, generating a “Certificate Signing Request (CSR)”, generating an SSL Certificate, etc.

If you follow the assistant correctly, after downloading and opening the SSL Certificate you should have it added under “My Certificates” or “Certificates” in your “Keychain Access” application. Also when you are returned to the Configure App ID page the certificate should be badged with a green circle and the label “Enabled”.

![Files in xCode project](http://mcpdemo.herokuapp.com/static/img/help/ios_integration/image006.jpg)

######Exporting the SSL Certificate
If not already in the “Keychain Access” app that contains your certificate, please open it and select the certificate that you just added. Once you select the certificate go to File > Export Items and export it as a Personal Information Exchange (.p12) file. When saving the file be sure to use the Personal Information Exchange (.p12) format.

![Files in xCode project](http://mcpdemo.herokuapp.com/static/img/help/ios_integration/image007.jpg)
    
######Emailing your SSL certificate
After downloading your 2 certificates (one for production, one for development), please send them to your RadiumOne account manager (with certificate passwords if you chose to add any).


###iii. Segment your Audience    

You can specify Tags for *R1 Connect SDK* to send *Push Notifications* for certain groups of users.

The maximum length of a Tag is 128 characters.

*R1 Connect SDK* saves Tags. You do not have to add Tags every time the application is launched.

***Add a new Tag***

```objc
[[R1Push sharedInstance].tags addTag:@"NEW TAG"];
```

***Add multiple Tags***
	
```objc
[[R1Push sharedInstance].tags addTags:@[ @"NEW TAG 1", @"NEW TAG 2" ]];
```

***Remove existing Tag***

```objc
[[R1Push sharedInstance].tags removeTag:@"EXIST TAG"];
```

***Remove multiple Tags***

```objc
[[R1Push sharedInstance].tags removeTags:@[ @"EXIST TAG 1", @"EXIST TAG 2" ]];
```

***Replace all existing Tags***

```objc
[R1Push sharedInstance].tags.tags = @[ @"NEW TAG 1", @"NEW TAG 2" ];
```
or
```objc
[[R1Push sharedInstance].tags setTags:@[ @"NEW TAG 1", @"NEW TAG 2" ]];
```

***Get all Tags***
	
```objc
NSArray *currentTags = [R1Push sharedInstance].tags.tags;
```

##c. Attribution Tracking Activation
###i. Track RadiumOne Campaigns
Please contact your Account Manager to setup R1 ad campaign as well as tracking campaigns.  If you don't have one, please contact us  [here](http://radiumone.com/contact-mobile-team.html) and one of our Account Managers will assist you.

Once your Account Manager has set up tracking, you will start receiving attribution tracking report automatically!

###ii. Track 3rd party Campaigns
1. Please contact your Account Manager to setup tracking URLs for your 3rd party campaigns.  If you don't have one, please contact us [here](http://radiumone.com/contact-mobile-team.html) and one of our Account Managers will assist you.
2. Send the list of all your media suppliers (anyone you run a mobile advertising campaign with).
3. For each media supplier, your account manager will send you 2 tracking URLs (one impression tracking URL, 1 click tracking URL).
4. Send each pair of URLs to the relevant Media Supplier so they can set these tracking URLs on the creatives
5. You're all set and will start having access to Attribution Tracking Reports

