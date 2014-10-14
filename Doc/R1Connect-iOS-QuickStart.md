#R1 Connect Library for iOS

##Overview
Downloading LibR1Connect.a allows you to begin the integration process of adding R1 Connect services to your app. It supports all mobile and tablet devices running iOS 5.0 with Xcode 4.5 and above. The file itself contains the library and headers of the R1 Connect SDK for iOS. The library supports the following architectures:

*	arm7
*	arm7s
*	arm64
*	i386
*	x86_64

##Setup
The following steps will explain how to integrate with R1 Connect to enable both push notifications and event tracking. You have the option to use the [R1 Connect Demo](https://github.com/radiumone/r1-connect-demo-iOS/tree/master/DemoApplication) as a sample app project to begin with or you can use your own app. Once you have downloaded the R1 Connect Library from this repo you can add it to the same directory as your project. 

###Required Libraries 
Your application must link against the following frameworks:

![Required Libraries](https://raw.github.com/radiumone/r1-connect-demo-iOS/readme_images/ReadmeImages/required_libraries.png)

###How to Add the R1 Connect files to Your Project

1.	Open up your iOS project in xCode.
2.	Select File -> Add Files to “[your project]”
3.	Select Folder with R1Connect library and headers in dialog
4.	When the dialog box appears, check the Copy Items into destination group’s folder checkbox. 

![Files in xCode project](https://raw.github.com/radiumone/r1-connect-demo-iOS/readme_images/ReadmeImages/library_files.png)

###Link against the static library

Check that the LibR1Connect.a file in the “Link Binary With Libraries” section is in the Build Phases tab for your target. If it’s absent, please add it.

![Linked binaries](https://raw.github.com/radiumone/r1-connect-demo-iOS/readme_images/ReadmeImages/link_with_binary.png)

###Check Background modes

Check Background modes switch is turned on in Capabilities tab for your target. If it’s turned off, please turn on.

![Background modes](https://raw.github.com/radiumone/r1-connect-demo-iOS/readme_images/ReadmeImages/enable_background_mode.png)


###Setting up your App Delegate

You will need to initialize the R1 Connect Library in your App Delegate.

####Import the required header files
At the top of your application delegate include any required headers:


•	If you want to use Analytics (without push notification)

```objc
#import R1SDK.h
```

•	If you want to use Analytics and Push Notifications (optional)
 
```objc
#import "R1SDK.h"
#import "R1Push.h"
```

####Initialize R1Connect Instance

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    R1SDK *sdk = [R1SDK sharedInstance];
    
    // Initialize Anlaytics
    sdk.applicationId = @"[Application ID]"; 
    sdk.applicationUserId = @"[(Optional) Application User Id]";
    
    
    // Initialize Push Notification (Optional)
    sdk.clientKey = @"[Your Client Key]";
    [[R1Push sharedInstance] handleNotification:[launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey]
                                 applicationState: application.applicationState];
    [[R1Push sharedInstance] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                                 UIRemoteNotificationTypeSound |
                                                                 UIRemoteNotificationTypeAlert)];
    
    // Start SDK
    [sdk start];
    
    return YES
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


CAUTION: If you enabled it in the *application:didFinishLaunchingWithOptions* method, the Push Notification AlertView will be showed at first application start.

#Emitter & Push Parameters
The following is a list of configuration parameters for the R1 Connect SDK, most of these contain values that are sent to the tracking server to help identify your app on our platform and to provide analytics on sessions and location.

##Configuration Parameters

***applicationUserId***

Optional current user identifier.

```objc
[R1SDK sharedInstance].applicationUserId = @"12345";
```

***location***


The current user location coordinates. Use it only if your application already uses location services.


```objc
[R1SDK sharedInstance].location = …;
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

#Push Tags
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

#Emitter Events

The R1 Connect SDK will automatically capture some generic events, but in order to get the most meaningful data on how users interact with your app the SDK also offers pre-built user-defined events for popular user actions as well as the ability to create your own custom events.

##State Events

Some events are emitted automatically when the state of the application is changed by the OS and, therefore, they do not require any additional code to be written in the app in order to work out of the box:

**Launch** - emitted when the app starts

**First Launch** - emitted when the app starts for the first time

**First Launch After Update** - emitted when the app starts for the first time after a version upgrade

**Suspend** - emitted when the app is put into the background state

**Resume** - emitted when the app returns from the background state

##Pre-Defined Events

Pre-Defined Events are also helpful in measuring certain metrics within the apps and do not require further developer input to function. These particular events below are used to help measure app open events and track Sessions.

**Application Opened** - This event is very useful for push notifications and can measure when your app is opened after a message is sent.

**Session Start** - As the name implies the Session Start event is used to start a session.

**Session End** - The Session End event is used to end a session and passes with it a Session Length attribute that calculates the session length in seconds.

##User-Defined Events

User-Defined Events are not sent automatically so it is up to you if you want to use them or not. They can provide some great insights on popular user actions if you decide to track them.  In order to set this up the application code needs to include the emitter callbacks in order to emit these events.

*Note: The last argument in all of the following emitter callbacks, otherInfo, is a dictionary of “key”,”value” pairs or nil*

**Action**

A generic user action, such as a button click.

```objc
[[R1Emitter sharedInstance] emitAction:@"Button pressed"
               			  				  label:@"About"
                       				  value:10
                  				  otherInfo:@{@"custom_key":@"value"}];
```

**Login**

Tracks a user login within the app

```objc
[[R1Emitter sharedInstance] emitLoginWithUserID:@"userId"
                           				    userName:@"user_name"
                          				   otherInfo:@{@"custom_key":@"value"}];
```

**User Info**

Records an user information

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

###E-Commerce Events

**Transaction**

```objc
[[R1Emitter sharedInstance] emitTransactionWithID:@"transaction_id"
                                   				  storeID:@"store_id"]
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

##Custom Events

With custom events you have the ability to create and track specific events that are more closely aligned with your app. If planned and structured correctly, custom events can be strong indicators of user intent and behavior. Some examples include pressing the “like” button, playing a song, changing the screen mode from portrait to landscape, and zooming in or out of an image. These are all actions by the user that could be tracked with events.

To include tracking of custom events for the mobile app, the following callbacks need to be included in the application code:

```objc
// Emits a custom event without parameters
[[R1Emitter sharedInstance] emitEvent:@"Your custom event name"];
// Emits a custom event with parameters
[[R1Emitter sharedInstance] emitEvent:@"Your custom event name"
			  			   withParameters:@{"key":"value"}];
```