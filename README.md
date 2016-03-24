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
      - [iv. In-App Webview Events](#user-content-iv-in-app-webview-events)
      - [v. Best Practices](#user-content-v-best-practices)
      - [vi. Debugging Tool](#user-content-vi-debugging-tool)
    - [b. Push Notification Activation (optional)](#user-content-b-push-notification-activation)
      - [i. Setup Apple Push Notification Services](#user-content-i-setup-apple-push-notification-services)
      - [ii. Initialization](#user-content-ii-initialization)
      - [iii. Rich Push Initialization](#user-content-iii-rich-push-initialization)
      - [iv. Deep Link Initialization](#user-content-iv-deep-link-initialization)
      - [v. Segment your Audience](#user-content-v-segment-your-audience)
      - [vi. Inbox Integration](#user-content-vi-inbox-integration)
    - [c. Attribution Tracking Activation (optional)](#user-content-c-attribution-tracking-activation)
      - [i. Track RadiumOne Campaigns](#user-content-i-track-radiumone-campaigns)
      - [ii. Track 3rd party Campaigns](#user-content-ii-track-3rd-party-campaigns)
    - [d. Geofencing Activation](#user-content-d-geofencing-activation)
  - [4. Submitting your App to Apple](#user-content-4-submitting-your-app)


#1. System Requirements
  The R1 Connect SDK supports all mobile and tablet devices running iOS 6.0 or newer with a base requirement of Xcode 4.5 used for development (Xcode 6.0 or newer is recommended). The downloadable directory (see below "[a. Import Files](#a-import-files)") contains the library and headers for the R1 Connect SDK. 

The library supports the following architectures (iOS version 6.0 and higher):

-arm7, arm7s, arm64 for deploying to physical devices

-i386, x86_64 for Simulator testing
 

#2. SDK Initialization

## a. Import Files
  1.	Download the r1connect lib files:
  git clone git@github.com:radiumone/r1-connect-demo-iOS.git
  2.	Open your iOS project in Xcode.
  3.	Select File -> Add Files to “[YOUR XCODE PROJECT]” project
  4.	Select all header files in the appropriate "Lib" Folder from the repo you just cloned.  The "Bitcode Lib" is built for Xcode 7 version (with bitcode support).  The "Non-Bitcode Lib" should only be used if you are building with Xcode 6.
  5.	When the dialog box appears, check the Copy Items into destination group’s folder checkbox.



  <img src="https://raw.github.com/radiumone/r1-connect-demo-iOS/readme_images/ReadmeImages/library_files.png"  width="440" />

## b. Link the Static Library
Go to "Build Phases" and make sure LibR1Connect.a file is set in the “Link Binary With Libraries” section. If absent, please add it.

Make sure you add:

- libsqlite3.dylib
- CoreLocation.framework
- CoreBluetooth.framework
- AdSupport.framework
- CoreTelephony.framework
- SystemConfiguration.framework


<img src="https://raw.github.com/radiumone/r1-connect-demo-iOS/readme_images/ReadmeImages/link_with_binary.png"  width="440" />

Verify that the Background Modes switch is turned on in the Capabilities tab for your target.

Also, it is important to add an entry to the 'Other Linker Flags' setting in your application's Build Settings in Xcode. Add '-ObjC' to the 'Other Linker Flags' setting if it is not already present. This is a common required flag when integrating static libraries with your code.

##Integrate with your Swift project

If you are using Swift in your project and you want to use R1 Connect SDK in your swift code you should:
* Open **Build Settings** for your project
* Find **Swift Compiler - Code Generation** section
* Add path to *R1SDK-Bridging-Header.h* file to **Objective-C Bridging Header**.

For example if SDK located in *R1SDK* folder inside your root project directory path will be *$(PROJECT_DIR)/R1SDK/R1SDK-Bridging-Header.h*

## c. Initialize the SDK
  You will need to initialize the R1 Connect Library in your App Delegate.
####Import the required header files (Only for *Objective C* code)
  At the top of your application delegate include any required headers:

```objc
#import "R1SDK.h"
#import "R1Emitter.h"
```

####Initialize the R1Connect Instance

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {     
    R1SDK *sdk = [R1SDK sharedInstance];  

    // Initialize SDK
    sdk.applicationId = @"YOUR APPLICATION ID";  //Ask your RadiumOne contact for an app id

    return YES; 
}
```

```swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    let sdk = R1SDK.sharedInstance();
    
    // Initialize SDK
    sdk.applicationId = "YOUR APPLICATION ID";

    return true
}
```

## d. Advanced Settings
The following is a list of configuration parameters for the R1 Connect SDK.  Most of these contain values that are sent to the tracking server to help identify your app on our platform and to provide analytics on sessions and location.

####Configuration Parameters


***applicationUserId***

Optional current user identifier.
```objc
[R1SDK sharedInstance].applicationUserId = @"12345";
```

```swift
R1SDK.sharedInstance().applicationUserId = "12345";
```

***cookieMapping***

Enable or disable cookie mapping. By default is NO.  Setting this first party cookie will enable RadiumOne to be effective in targeting the user for advertising campaigns run on behalf of the Publisher. Only enable this setting if you plan to run advertising with RadiumOne.
```objc
[R1SDK sharedInstance].cookieMapping = YES;
```

```swift
R1SDK.sharedInstance().cookieMapping = true;
```

***deferredDeeplinkScheme***

Enable deferred deeplinking. Value is the app registered URL scheme.
```objc
[R1SDK sharedInstance].deferredDeeplinkScheme = @"your app scheme";
```

```swift
R1SDK.sharedInstance().deferredDeeplinkScheme = "your app scheme";
```

***location***

The current user location coordinates. Use only if your application already uses location services.

```objc
[R1SDK sharedInstance].location = [locations lastObject];
```

```swift
R1SDK.sharedInstance().location = …;
```

***locationService***

If your application did not use location information before this SDK installation, you can use locationService in this SDK to enable or disable it:

```objc
[R1SDK sharedInstance].locationService.enabled = YES;
```

```swift
R1SDK.sharedInstance().locationService.enabled = true;
```

N.B. - The Connect locationService uses the Location Manager in iOS.  For deployment on iOS 8 and newer, it is required that the application's property list (plist) file include one of the two following keys:
    
    NSLocationAlwaysUsageDescription
    //provide location updates whether the user is actively using the application or not via infrequent background location updates
    // OR
    NSLocationWhenInUseUsageDescription
    //provide location updates only while the user has your application as the foreground running app

These are string values that need to include a description suitable to present to a user.  The description should explain the reason the application is requesting access to the user's location.  Therefore, description you give should try to incorporate or reference the user benefit that may be possible through sharing location.

You must import R1LocationService.h to use this feature.

When enabled, such as in the example above, location information will be sent automatically. However, locationService doesn’t fetch the location constantly. For instance, when the location is received the SDK will turn off the location in CLLocationManager and wait 10 minutes (by default) before attempting to retrieve it again. You can change this value:
```objc
[R1SDK sharedInstance].locationService.autoupdateTimeout = 1200; // 20 minutes
```

```swift
R1SDK.sharedInstance().locationService.autoupdateTimeout = 1200; // 20 minutes
```

***appName***

The application name associated with the emitter. By default, this property is populated with the `CFBundleName` string from the application bundle. If you wish to override this property, you must do so before making any tracking calls.

```objc
[R1Emitter sharedInstance].appName = @"Custom application name";
```

```swift
R1Emitter.sharedInstance().appName = "Custom application name";
```

***appId***

Default: nil

The application identifier associated with this emitter.  If you wish to set this property, you must do so before making any tracking calls. Note: that this is not your app's bundle id, like e.g. com.example.appname.

```objc
[R1Emitter sharedInstance].appId = @"12345678";
```

```swift
R1Emitter.sharedInstance().appId = "12345678";
```

***appVersion***

The application version associated with this emitter. By default, this property is populated with the `CFBundleShortVersionString` string from the application bundle. If you wish to override this property, you must do so before making any tracking calls.

```objc
[R1Emitter sharedInstance].appVersion = @"1.0.2";
```

```swift
R1Emitter.sharedInstance().appVersion = "1.0.2";
```

***sessionTimeout***

If positive, indicates how long, in seconds, the application must transition to the inactive or background state for before the tracker will automatically indicate the start of a new session when the app becomes active again by setting sessionStart to true. For example, if this is set to 30 seconds, and the user receives a phone call that lasts for 45 seconds while using the app, upon returning to the app, the sessionStart parameter will be set to true. If the phone call lasted 10 seconds, sessionStart will not be modified.

To disable automatic session tracking, set this to a negative value. To indicate the start of a session anytime the app becomes inactive or backgrounded, set this to zero.

By default, this is 30 seconds.

```objc
[R1Emitter sharedInstance].sessionTimeout = 15;
```

```swift
R1Emitter.sharedInstance().sessionTimeout = 15;
```

#3. Feature Activation
##a. Analytics Activation

####Setup your App Delegate

(Only for *Objective C* code)
```objc
#import "R1SDK.h"
#import "R1Emitter.h"
#import "R1Push.h"
```

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  R1SDK *sdk = [R1SDK sharedInstance];

  // Initialize Analytics      
  sdk.applicationId = @"YOUR APPLICATION ID";  //Ask your RadiumOne contact for an app id

  // Start SDK
  [sdk start];

  return YES;
}
```

```swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    let sdk = R1SDK.sharedInstance();
    
    // Initialize Anlaytics
    sdk.applicationId = "YOUR APPLICATION ID";

    // Start SDK
    sdk.start();

    return true
}
```

### i. Automatic Events


The R1 Connect SDK will automatically capture some generic events in order to get the most meaningful data on how users interact with your app. These events are triggered when the state of the application is changed, and therefore do not require any additional code to work out of the box:

**Launch** - emitted when the app starts

**First Launch** - emitted when the app starts for the first time

**First Launch After Update** - emitted when the app starts for the first time after a version upgrade

**Suspend** - emitted when the app is put into the background state

**Resume** - emitted when the app returns from the background state

**Application Opened** - emitted when the app is opened and can measure when your app is opened after a message is sent

**Session Start** - emitted when a new session begins

**Session End** - emitted when a session ends; includes a Session Length attribute with the session length in seconds.


### ii. Standard Events

Standard events cover all the main user flows (login, register, share, purchase...) in a standardized format for optimized reporting on the portal, providing a great foundation to your analytics strategy. Once you set them up in your code, they unlock great insights, particularly on user lifetime value.

*Note: The last argument in all of the following emitter callbacks, otherInfo, is a dictionary of “key”,”value” pairs or nil, which enables you to customize these events as much as you want.*

**Login**

Tracks a user login within the app

```objc
[[R1Emitter sharedInstance] emitLoginWithUserID:@"userId"
userName:@"user_name"
otherInfo:@{@"custom_key":@"value"}];
```

```swift
R1Emitter.sharedInstance()
    .emitLoginWithUserID("userId", userName: "user_name", otherInfo: ["custom_key": "value"]);
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

```swift
R1Emitter.sharedInstance()
    .emitRegistrationWithUserID("userId", userName: "userName", country: "country", state: "state", city: "city", otherInfo: ["custom_key": "value"]);
```

**Facebook connect**

Allows access to Facebook services

```objc
NSArray *permissions = @[[R1EmitterSocialPermission socialPermissionWithName:@"photos" granted:YES]];

[[R1Emitter sharedInstance] emitFBConnectWithPermissions:permissions
otherInfo:@{@"custom_key":@"value"}];
```

```swift
let permissions = [R1EmitterSocialPermission.init(name: "photos", granted: true)];

R1Emitter.sharedInstance()
    .emitFBConnectWithPermissions(permissions, otherInfo: ["custom_key": "value"]);
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

```swift
let permissions = [R1EmitterSocialPermission.init(name: "photos", granted: true)];

R1Emitter.sharedInstance()
    .emitTConnectWithUserID("12345", userName: "user_name", permissions: permissions, otherInfo: ["custom_key": "value"]);
```

**User Info**

Enables you to send user profiles to the backend.

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

[[R1Emitter sharedInstance] emitUserInfo:userInfo
otherInfo:@{@"custom_key":@"value"}];
```

```swift
let userInfo = R1EmitterUserInfo.init(userID: "userID", userName: "userName", email: "email", firstName: "firstName", lastName: "lastName", streetAddress: "streetAddress", phone: "phone", city: "city", state: "state", zip: "zip");

R1Emitter.sharedInstance().emitUserInfo(userInfo, otherInfo: ["custom_key": "value"]);
```

**Upgrade**

Tracks an application version upgrade

```objc
[[R1Emitter sharedInstance] emitUpgradeWithOtherInfo:@{@"custom_key":@"value"}];
```

```swift
R1Emitter.sharedInstance()
    .emitUpgradeWithOtherInfo(["custom_key": "value"]);
```

**Trial Upgrade**

Tracks an application upgrade from a trial version to a full version

```objc
[[R1Emitter sharedInstance] emitTrialUpgradeWithOtherInfo:@{@"custom_key":@"value"}];
```

```swift
R1Emitter.sharedInstance()
    .emitTrialUpgradeWithOtherInfo(["custom_key": "value"]);
```

**Screen View**

A page view that provides info about that screen

```objc
[[R1Emitter sharedInstance] emitScreenViewWithDocumentTitle:@"title"
contentDescription:@"description"
documentLocationUrl:@"http://www.example.com/path"
documentHostName:@"example.com"
documentPath:@"path"
otherInfo:@{@"custom_key":@"value"}];
```

```swift
R1Emitter.sharedInstance()
    .emitScreenViewWithDocumentTitle("title", contentDescription: "description", documentLocationUrl: "http://www.example.com/path", documentHostName: "example.com", documentPath: "path", otherInfo:["custom_key": "value"]);
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

```swift
R1Emitter.sharedInstance()
    .emitTransactionWithID("transaction_id", storeID: "store_id", storeName: "store_name", cartID: "cart_id", orderID: "order_id", totalSale: 1.5, currency: "USD", shippingCosts: 10.5, transactionTax: 12.0, otherInfo:["custom_key": "value"]);
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

```swift
let lineItem = R1EmitterLineItem.init(
    ID: "product_id",
    name: "product_name",
    quantity: 5,
    unitOfMeasure: "unit",
    msrPrice: 10,
    pricePaid: 10,
    currency: "USD",
    itemCategory: "category");

R1Emitter.sharedInstance()
    .emitTransactionItemWithTransactionID("transaction_id", lineItem: lineItem, otherInfo: ["custom_key": "value"]);
```

**Create Cart**

```objc
[[R1Emitter sharedInstance] emitCartCreateWithCartID:@"cart_id"
otherInfo:@{@"custom_key":@"value"}];
```

```swift
R1Emitter.sharedInstance()
    .emitCartCreateWithCartID("cart_id", otherInfo: ["custom_key": "value"]);
```

**Delete Cart**

```objc
[[R1Emitter sharedInstance] emitCartDeleteWithCartID:@"cart_id"
otherInfo:@{@"custom_key":@"value"}];
```

```swift
R1Emitter.sharedInstance()
    .emitCartDeleteWithCartID("cart_id", otherInfo: ["custom_key": "value"]);
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

```swift
let lineItem = R1EmitterLineItem.init(
    ID: "product_id",
    name: "product_name",
    quantity: 5,
    unitOfMeasure: "unit",
    msrPrice: 10,
    pricePaid: 10,
    currency: "USD",
    itemCategory: "category");

R1Emitter.sharedInstance()
    .emitAddToCartWithCartID("cart_id", lineItem: lineItem, otherInfo: ["custom_key": "value"]);
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

```swift
let lineItem = R1EmitterLineItem.init(
    ID: "product_id",
    name: "product_name",
    quantity: 5,
    unitOfMeasure: "unit",
    msrPrice: 10,
    pricePaid: 10,
    currency: "USD",
    itemCategory: "category");

R1Emitter.sharedInstance()
    .emitDeleteFromCartWithCartID("cart_id", lineItem: lineItem, otherInfo: ["custom_key": "value"]);
```

###iii. Custom Events

Custom events allow you to create and track specific events that are more closely aligned with your app. If planned and structured correctly, custom events can be strong indicators of user intent and behavior. Some examples include pressing the “like” button, playing a song, changing the screen mode from portrait to landscape, and zooming in or out of an image. These are all actions by the user that could be tracked with events.

To include tracking of custom events for the mobile app, the following callbacks need to be included in the application code:

```objc
// Emits a custom event without parameters
[[R1Emitter sharedInstance] emitEvent:@"Your custom event name"];

// Emits a custom event with parameters
[[R1Emitter sharedInstance] emitEvent:@"Your custom event name"
withParameters:@{@"key":@"value"}];
```

```swift
// Emits a custom event without parameters
R1Emitter.sharedInstance().emitEvent("Your custom event name");
// Emits a custom event with parameters
R1Emitter.sharedInstance().emitEvent("Your custom event name", withParameters: ["key": "value"]);
```

###iv. In-App Webview Events

By setting up in-app webview events, you can track events that begin inside your native application but are completed in the embedded browser.  To do so, you will have to embed some JavaScript in the page that you will want to fire the event, and you need to properly trigger the webview in your application.

####JavaScript Setup

To properly fire the event from your webpage, please make the following call:

```js
R1Connect.emitEvent(eventName,eventParameters);
```

For example, both of the following work.  The use of parameters is optional.

```js
R1Connect.emitEvent("Test Event");
R1Connect.emitEvent("Test Event",{"key":"value"});
```

Additionally, please attach the following r1connect.js file to your webpage:

```js
var R1ConnectBridgePlatforms = {
    UNKNOWN: 0,
    IOS: 1,
    ANDROID: 2
};

window.R1Connect = {
    iosBridgeScheme: "r1connectbridge://",

    platform: R1ConnectBridgePlatforms.UNKNOWN,

    iosURLQueue: [],
    iosInProgress: false,

    buildIOSUrl: function(eventName, parameters) {
        var url = this.iosBridgeScheme + 'emit/?event=' + eventName;

        if (parameters)
            url += '&params='+JSON.stringify(parameters);

        return url;
    },

    sendURLInFrame: function(url) {
        var iframe = document.createElement("IFRAME");
        iframe.setAttribute("src", encodeURI(url));
        document.documentElement.appendChild(iframe);
        iframe.parentNode.removeChild(iframe);

        iframe = null;
    },

    emitEvent: function(eventName, parameters) {
        if (this.platform == R1ConnectBridgePlatforms.UNKNOWN) {
            if (window.R1ConnectJSInterface && window.R1ConnectJSInterface.emit)
                this.platform = R1ConnectBridgePlatforms.ANDROID;
            else
                this.platform = R1ConnectBridgePlatforms.IOS;
        }

        if (this.platform == R1ConnectBridgePlatforms.ANDROID) {
            window.R1ConnectJSInterface.emit(eventName, parameters ? JSON.stringify(parameters) : '');
            return;
        }

        var iosURL = this.buildIOSUrl(eventName, parameters);

        if (this.iosInProgress) {
            this.iosURLQueue.push(iosURL);
            return;
        }

        this.iosInProgress = true;
        this.sendURLInFrame(iosURL);
    },

    iosURLReceived: function() {
        setTimeout(function() {
            window.R1Connect._iosURLReceived();
        }, 0);
    },

    _iosURLReceived: function() {
        if (this.iosURLQueue.length == 0) {
            this.iosInProgress = false;
            return;
        }

        var iosURL = this.iosURLQueue.shift();
        this.sendURLInFrame(iosURL);    
    },
};
```

####iOS Setup

To properly handle the events in your application, you first need to import the R1WebViewHelper header file in your ViewController .m implementation file:

(Only for *Objective C* code)
```objc
#import "R1WebViewHelper.h"
```

You then should setup the UIWebView delegate from the Interface Builder or from code:

```objc
- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.webView.delegate = self;
    
    // Your code here
}
```

```swift
override func viewDidLoad() {
    super.viewDidLoad();
        
    webView?.delegate = self;
    
    // Your code here
}
```

Finally, add the delegate method implementation:

```objc
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType { if (![R1WebViewHelper webView:webView shouldStartLoadWithRequest:request navigationType:navigationType]) return NO; // Your code here return YES; }
```

```swift
func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
   if R1WebViewHelper.webView(webView, shouldStartLoadWithRequest: request, navigationType: navigationType) {
      return false;
   }
        
   // Your code here
   return true;
}
```

###v. Best Practices
####Event Naming Convention
One common mistake is to parametrize event names (with user data for example). Event names should be hard-coded values that you use to segement data on a specific category of event. 

Example: "ProfileViewing"

Avoid: "Profile Viewing - Lady Gaga's profile"

As you may have thousands of user profiles in your database, it is preferable to keep the event name high level ("ProfileViewing") so you can run interesting anaytics on it. High level events help answer questions like "how many profiles does a user visit every day on average?" 

####Parameter Variance

Another common mistake is to add parameters to the event that have too many possible values. To follow up on the previous example, one may decide to add the number of profile followers as an event parameter:

```objc
[[R1Emitter sharedInstance] emitEvent:@"ProfileViewing"
withParameters:@{@"profileFollowers":profileFollowers}];
```

```swift
R1Emitter.sharedInstance()
    .emitEvent("ProfileViewing", withParameters: ["profileFollowers": profileFollowers]);
```

Again, the problem here is that each profile may have any number of followers. This will fragment your data too much to extract any valuable information.

A good strategy would be to define relevant buckets for high variance parameters. In this case, it might be more relevant to separate traffic on the profiles with a lot of followers from traffic on profiles with very few followers. You could define 3 categories: 

- "VERY_INFLUENTIAL" for profiles > 100,000 
- "INFLUENTIAL" for profile > 10,000 and <= 100,000
- "NON_INFLUENTIAL" for profile <= 10,000

A proper event could be 

```objc
[[R1Emitter sharedInstance] emitEvent:@"ProfileViewing"
withParameters:@{@"profileFollowersBucket":@"VERY_INFLUENTIAL"}];
```

```swift
R1Emitter.sharedInstance()
    .emitEvent("ProfileViewing", withParameters: ["profileFollowersBucket": "VERY_INFLUENTIAL"]);
```

This will enable you to create more insightful reports.

###vi. Debugging Tool

This tool allows you to verify that the events that you have set up are triggering correctly.  You can access the debugging area of the portal to view the JSON events sent by your application.

####Setup

To enable the debugging tool, you should create a flat file titled "r1DebugDevices" with a list of IDFAs and add it to your project root through File -> Add Files to "Project.".  There should be one ID per line.

Once you build the app and install it on the same test devices that you added in the DebugDevices file, you should see any action taken in the app appear in the debug section of the portal.

##b. Push Notification Activation

###i. Setup Apple Push Notification Services

####Prerequisites for Apple Push Notification Services Setup
######The Importance of Setting your App as in “Production” or in “Development”
When creating or editing an app on RadiumOne Connect you can set the status of the app to either “Production” or “Development”. “Production” status for an app is considered to be a live app that is in the hands of real users and will have notifications and other data running on live servers. A “Development” status for an app is one that you are still performing testing on and will not be viewed by any real-life audiences because it will stay on test servers.

In the context of push notifications, it is important to know this difference because Apple will treat these two servers separately. Also device tokens for “Development” will not work on “Production” and vice versa. We recommend a Development app version and Production app version for your app on RadiumOne Connect to keep Push SSL certificates separate for each. You can also continue testing and experimenting on one app without worrying about it affecting your live app audience in any way.
######iOS Developer Program Enrollment
This doc assumes that you are enrolled in the iOS Developer Program. If you are not, please enroll [here](https://developer.apple.com/programs/ios/). Being in the Apple Developer Program is a required component to have your iOS app communicate with the RadiumOne Connect service for push notifications and is necessary for the next step of setting up your app with the Apple Push Notification Service (APNs). It is also essential that you have “Team Agent” role access in the iOS Developer Program to complete this process.

####Configuring your App for Apple Push Notifications
######Apple Developer Members Center
Make sure you are logged into the [Apple Developer Members Center](https://daw.apple.com/cgi-bin/WebObjects/DSAuthWeb.woa/wa/login?&appIdKey=891bd3417a7776362562d2197f89480a8547b108fd934911bcbea0110d07f757&path=%2F%2Fmembercenter%2Findex.action). Once you are logged in you can locate your application in the “Identifiers” folder list.

![Files in Xcode project](http://mcpdemo.herokuapp.com/static/img/help/ios_integration/image001.jpg)

######Registered App ID
If you have not registered an App ID yet it is important that you do so now. You will need to click the “+” symbol, fill out the form, and check the “Push Notifications” checkbox. Please keep in mind it is possible to edit these choices after the App ID is registered.


![Files in Xcode project](http://mcpdemo.herokuapp.com/static/img/help/ios_integration/image002.jpg)
![Files in Xcode project](http://mcpdemo.herokuapp.com/static/img/help/ios_integration/image003.jpg)

You can expand the application and when doing so you will see two settings for push notifications. They will have either yellow or green status icons like here:

![Files in Xcode project](http://mcpdemo.herokuapp.com/static/img/help/ios_integration/image004.jpg)

You will need to click Edit to continue. If the Edit button is not visible it is because you do not have “Team Agent” role access. This role is necessary for getting an SSL certificate.

######Creating an SSL Certificate
To enable the Development or Production Push SSL Certificate please click Edit. (It is important to note that each certificate is limited to a single app, identified by its bundle ID and limited to one of two environments, either Development or Production. Read more info [here](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Chapters/ProvisioningDevelopment.html#//apple_ref/doc/uid/TP40008194-CH104-SW1).)

Note:  Apple has updated their Push certificate system.  They now offer Universal cerfticates which will work with both Development and Production Provisioning Profiles.  We still support the older, environment-specific certificates as well.

![Files in Xcode project](http://mcpdemo.herokuapp.com/static/img/help/ios_integration/image005.jpg)


You will see a Create Certificate button, after clicking it you will see the “Add iOS Certificate Assistant”. Please follow the instructions presented in the assistant which includes launching the “Keychain Access” application, generating a “Certificate Signing Request (CSR)”, generating an SSL Certificate, etc.

If you follow the assistant correctly, after downloading and opening the SSL Certificate you should have it added under “My Certificates” or “Certificates” in your “Keychain Access” application. Also when you are returned to the Configure App ID page the certificate should be badged with a green circle and the label “Enabled”.

![Files in Xcode project](http://mcpdemo.herokuapp.com/static/img/help/ios_integration/image006.jpg)

######Exporting the SSL Certificate
If not already in the “Keychain Access” app that contains your certificate, please open it and select the certificate that you just added. Once you select the certificate go to File > Export Items and export it as a Personal Information Exchange (.p12) file. When saving the file be sure to use the Personal Information Exchange (.p12) format.

![Files in Xcode project](http://mcpdemo.herokuapp.com/static/img/help/ios_integration/image007.jpg)

######Emailing your SSL certificate
After downloading your 2 certificates (one for production, one for development), please send them to your RadiumOne account manager (with certificate passwords if you choose to add any).


###ii. Initialization

####Setup your App Delegate

(Only for *Objective C* code)
```objc
#import "R1SDK.h"
#import "R1Emitter.h"
#import "R1Push.h"
#import "R1WebCommand.h" // required for rich push
```

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  R1SDK *sdk = [R1SDK sharedInstance];

  // Initialize SDK
  sdk.applicationId = @"Application ID";  //Ask your RadiumOne contact for an app id

  // Initialize Push Notification
  sdk.clientKey = @"Your Client Key";  //Ask your RadiumOne contact for a client key
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

```swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    let sdk = R1SDK.sharedInstance();
    
    // Initialize Anlaytics
    sdk.applicationId = "Application ID";  //Ask your RadiumOne contact for an app id
    
    // Initialize Push Notification
    sdk.clientKey = "Your Client Key";  //Ask your RadiumOne contact for a client key
        
    var remoteNotificationInfo: NSDictionary? = nil
    if launchOptions != nil {
        remoteNotificationInfo = (launchOptions![UIApplicationLaunchOptionsRemoteNotificationKey] as? NSDictionary)!;
    }
        
    R1Push.sharedInstance().handleNotification(remoteNotificationInfo as? [NSObject : AnyObject], applicationState: application.applicationState);
    R1Push.sharedInstance().registerForRemoteNotificationTypes([.Alert ,.Badge ,.Sound]);

    // Start SDK
    sdk.start();

    return true
}

```

####Register for Remote Notifications

```objc
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  [[R1Push sharedInstance] registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  [[R1Push sharedInstance] failToRegisterDeviceTokenWithError:error];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
  [[R1Push sharedInstance] handleNotification:userInfo applicationState:application.applicationState];
}
```

```swift
func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    R1Push.sharedInstance().registerDeviceToken(deviceToken);
}

func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
    R1Push.sharedInstance().failToRegisterDeviceTokenWithError(error);
}

func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
    R1Push.sharedInstance().handleNotification(userInfo, applicationState: application.applicationState);
}
```

Push is disabled by default. You can enable it in the *application:didFinishLaunchingWithOptions* method or later.

```objc
[[R1Push sharedInstance] setPushEnabled:YES];
```

```swift
R1Push.sharedInstance().pushEnabled = true;
```

NOTE: If you enabled it in the *application:didFinishLaunchingWithOptions* method, the Push Notification AlertView will be showed at first application start.


###iii. Rich Push Initialization    

Rich *Push Notifications* send a URL that opens in a WebView upon user response to a system notification.  No set up is required for this feature.

Please note that iOS 9 devices require use of HTTPS.  iOS 8 and previous versions still support HTTP.  Please ensure that you send HTTPS if iOS 9 devices may receive the message.


###iv. Deep Link Initialization    

Deep linking *Push Notifications* open up a designated view in an application upon user response to a system notification.  To properly handle deep link push receipts, please read Apple's documentation:  https://developer.apple.com/library/ios/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/Inter-AppCommunication/Inter-AppCommunication.html#//apple_ref/doc/uid/TP40007072-CH6-SW10
http://wiki.akosma.com/IPhone_URL_Schemes


###v. Segment your Audience    

You can specify Tags for *R1 Connect SDK* to send *Push Notifications* to certain groups of users.

The maximum length of a Tag is 128 characters.

*R1 Connect SDK* saves Tags. You do not have to add Tags every time the application is launched.

***Add a new Tag***

```objc
[[R1Push sharedInstance].tags addTag:@"NEW TAG"];
```

```swift
R1Push.sharedInstance().tags.addTag("NEW TAG");
```

***Add multiple Tags***

```objc
[[R1Push sharedInstance].tags addTags:@[ @"NEW TAG 1", @"NEW TAG 2" ]];
```

```swift
R1Push.sharedInstance().tags.addTags(["NEW TAG 1", "NEW TAG 2"]);
```

***Remove existing Tag***

```objc
[[R1Push sharedInstance].tags removeTag:@"EXIST TAG"];
```

```swift
R1Push.sharedInstance().tags.removeTag("EXIST TAG");
```

***Remove multiple Tags***

```objc
[[R1Push sharedInstance].tags removeTags:@[ @"EXIST TAG 1", @"EXIST TAG 2" ]];
```

```swift
R1Push.sharedInstance().tags.removeTags([ "EXIST TAG 1", "EXIST TAG 2" ]);
```

***Replace all existing Tags***

```objc
[R1Push sharedInstance].tags.tags = @[ @"NEW TAG 1", @"NEW TAG 2" ];
```
or
```objc
[[R1Push sharedInstance].tags setTags:@[ @"NEW TAG 1", @"NEW TAG 2" ]];
```

```swift
R1Push.sharedInstance().tags.tags = ["NEW TAG 1", "NEW TAG 2"];
```

***Get all Tags***

```objc
NSArray *currentTags = [R1Push sharedInstance].tags.tags;
```

```swift
let currentTags = R1Push.sharedInstance().tags.tags;
```

###vi. Inbox Integration
If you want to enable inbox functionality, you need to use R1Inbox class and import *R1Inbox.h* header at the top of your class file (Only for *Objective C* code):

```objc
#import "R1Inbox.h"
```

If you want to add some label or button with count of unread or total Inbox messages, you should implement `-(void) inboxMessageUnreadCountChanged` or `-(void) inboxMessagesDidChanged` (`func inboxMessageUnreadCountChanged()` or `func inboxMessagesDidChanged()` for *swift*) methods from `R1InboxMessagesDelegate` protocol in your class. After that, add your class as delegate to `[R1Inbox sharedInstance].messages` (`R1Inbox.sharedInstance().messages` for *swift*).

```objc
- (void) addInboxMessagesDelegate
{
	[[R1Inbox sharedInstance].messages addDelegate:self];
}

-(void) inboxMessageUnreadCountChanged
{
	NSString *btnTitle = [NSString stringWithFormat:@"Inbox (%lu unread)", (unsigned long)[R1Inbox sharedInstance].messages.unreadMessagesCount];
	
	[self.inboxButton setTitle:btnTitle forState:UIControlStateNormal];
}
```

```swift
func addInboxMessagesDelegate() {
  R1Inbox.sharedInstance().messages.addDelegate(self);
}

func inboxMessageUnreadCountChanged() {
  let btnTitle = String.init(format: "Inbox unread cound: %d", R1Inbox.sharedInstance().messages.unreadMessagesCount);
  inboxButton?.setTitle(btnTitle, forState: .Normal);
}
```

Do not forget to remove your class from delegates when your class gets deallocated:

```objc
- (void) dealloc
{
    [[R1Inbox sharedInstance].messages removeDelegate:self];
    //...
}
```

```swift
deinit {
    R1Inbox.sharedInstance().messages.removeDelegate(self);
    //...
}
```

To display the list of Inbox messages, you should create your own ViewController to provide required customization. In this case, this screen would not look foreign to your application.

You can see the sample of Inbox implementation in DemoApplication project in files *R1SampleInboxTableViewCell.h*, *R1SampleInboxTableViewCell.m*, *R1SampleInboxViewController.h*, *R1SampleInboxViewController.m* (for *Objective C*) and in DemoApplicationSwift project in files *R1SampleInboxTableViewCell.swift*, *R1SampleInboxViewController.swift* (for *swift*)

*R1SampleInboxTableViewCell.h*

```objc
#import <UIKit/UIKit.h>

@class R1InboxMessage;

@interface R1SampleInboxTableViewCell : UITableViewCell

// Sets or Gets R1InboxMessage object and configures cell for it
@property (nonatomic, strong) R1InboxMessage *inboxMessage;

- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier;

// Calculates the height of the cell
+ (CGFloat) heightForCellWithInboxMessage:(R1InboxMessage *) inboxMessage cellWidth:(CGFloat) cellWidth;

@end
```

*R1SampleInboxTableViewCell.m*

```objc
#import "R1SampleInboxTableViewCell.h"
#import "R1Inbox.h"

@interface R1SampleInboxTableViewCell ()

@property (nonatomic, strong) UIView *unreadMarker;
@property (nonatomic, strong) UILabel *alertLabel;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation R1SampleInboxTableViewCell

- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.alertLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.alertLabel.numberOfLines = 0;
        self.alertLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:self.alertLabel];
        
        self.unreadMarker = [[UIView alloc] initWithFrame:CGRectZero];
        self.unreadMarker.layer.cornerRadius = 3;
        self.unreadMarker.backgroundColor = [UIColor blueColor];
        [self.contentView addSubview:self.unreadMarker];
        
        self.textLabel.font = [UIFont boldSystemFontOfSize:14];
        self.alertLabel.font = [UIFont systemFontOfSize:14];
        
        self.detailTextLabel.textAlignment = NSTextAlignmentRight;
        
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [self.dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    }
    return self;
}

// Configures the cell for displaying Inbox Message
- (void) setInboxMessage:(R1InboxMessage *)inboxMessage
{
    if (_inboxMessage == inboxMessage)
    {
        [self configureUnreadMarker];
        return;
    }
    
    _inboxMessage = inboxMessage;
    
    self.textLabel.text = inboxMessage.title;
    self.alertLabel.text = inboxMessage.alert;
    
    self.detailTextLabel.text = [self.dateFormatter stringFromDate:inboxMessage.createdDate];
    [self configureUnreadMarker];
    
    [self setNeedsLayout];
}

// Shows or hides unread marker view
- (void) configureUnreadMarker
{
    if ([self.unreadMarker isHidden] != _inboxMessage.unread)
        return;
    
    [self.unreadMarker setHidden:!_inboxMessage.unread];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.unreadMarker.frame = CGRectMake(4, (self.contentView.bounds.size.height - 6)/2, 6, 6);
    
    self.detailTextLabel.frame = CGRectMake(0, 0, self.contentView.bounds.size.width-10, 20);
    
    if (self.textLabel.text == nil)
    {
        self.alertLabel.frame = CGRectMake(15, 15, self.contentView.bounds.size.width-20, self.contentView.bounds.size.height-20);
    }else
    {
        self.textLabel.frame = CGRectMake(15, 15, self.contentView.bounds.size.width-20, 20);
        self.alertLabel.frame = CGRectMake(15, 35, self.contentView.bounds.size.width-20, self.contentView.bounds.size.height-45);
    }
}

// Calculates the height of the cell
+ (CGFloat) heightForCellWithInboxMessage:(R1InboxMessage *) inboxMessage cellWidth:(CGFloat) cellWidth
{
    CGFloat height = 25;
    
    if (inboxMessage.title != nil)
        height += 20;
    
    if (inboxMessage.alert != nil)
    {
        if ([inboxMessage.alert respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
        {
            NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
            paragraph.lineBreakMode = NSLineBreakByWordWrapping;
            
            NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                         NSParagraphStyleAttributeName: paragraph};
            
            height += [inboxMessage.alert boundingRectWithSize:CGSizeMake(cellWidth-20, 100)
                                                       options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                    attributes:attributes
                                                       context:nil].size.height;
        }else
        {
            height += [inboxMessage.alert sizeWithFont:[UIFont systemFontOfSize:14]
                                     constrainedToSize:CGSizeMake(cellWidth-20, 100)
                                         lineBreakMode:NSLineBreakByWordWrapping].height;
        }
        
        height += 1;
    }
    
    if (height < 50)
        return 50;
    
    return height;
}

@end
```
*R1SampleInboxViewController.h*

```objc
#import <UIKit/UIKit.h>
#import "R1Inbox.h"

@protocol R1SampleInboxViewControllerDelegate;

@interface R1SampleInboxViewController : UITableViewController <R1InboxMessagesDelegate>

@property (nonatomic, assign) id<R1SampleInboxViewControllerDelegate> inboxDelegate;

- (id) initInboxViewController;

@end

@protocol R1SampleInboxViewControllerDelegate <NSObject>

- (void) sampleInboxViewControllerDidFinished:(R1SampleInboxViewController *) sampleInboxViewController;

@end
```

*R1SampleInboxViewController.m*

```objc
#import "R1SampleInboxViewController.h"
#import "R1SampleInboxTableViewCell.h"
#import "R1Inbox.h"

@interface R1SampleInboxViewController ()

@property (nonatomic, strong) R1InboxMessages *inboxMessages;

@end

@implementation R1SampleInboxViewController

// Initialize UITableViewController
- (id) initInboxViewController
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        self.inboxMessages = [R1Inbox sharedInstance].messages;
        
        [self updateTitle];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                              target:self action:@selector(closeInboxViewController)];
    }
    return self;
}

// Called when user presses 'Done' button
- (void) closeInboxViewController
{
    [self.inboxDelegate sampleInboxViewControllerDidFinished:self];
}

// Updates the title of ViewController with number of unread messages
- (void) updateTitle
{
    if (self.inboxMessages.unreadMessagesCount == 0)
        self.navigationItem.title = @"Inbox";
    else
        self.navigationItem.title = [NSString stringWithFormat:@"Inbox (%lu unread)", (unsigned long)self.inboxMessages.unreadMessagesCount];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateTitle];

    // Add this view controller to the list of delegates when it appears
    [self.inboxMessages addDelegate:self];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // Remove this view controller from the list of delegates when it disappears
    [self.inboxMessages removeDelegate:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Returns the total number of Inbox messages
    return self.inboxMessages.messagesCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Returns the calculated height of the cell for R1InboxMessage object in row
    return [R1SampleInboxTableViewCell heightForCellWithInboxMessage:[self.inboxMessages.messages objectAtIndex:indexPath.row]
                                                           cellWidth:self.tableView.frame.size.width];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    R1SampleInboxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil)
    {
        cell = [[R1SampleInboxTableViewCell alloc] initWithReuseIdentifier:@"Cell"];
    }
    
    // Sets up the cell for displaying R1InboxMessage object
    cell.inboxMessage = [self.inboxMessages.messages objectAtIndex:indexPath.row];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    R1InboxMessage *message = [self.inboxMessages.messages objectAtIndex:indexPath.row];

    // Shows Inbox message when user interacts to the cell
    [[R1Inbox sharedInstance] showMessage:message
                           messageDidShow:^{
                               [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                           }];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    R1InboxMessage *message = [self.inboxMessages.messages objectAtIndex:indexPath.row];
    
    [self.inboxMessages deleteMessage:message];
}

#pragma mark - R1InboxMessagesDelegate methods

// This method called when the list of Inbox messages gets updated
- (void) inboxMessagesWillChanged
{
    [self.tableView beginUpdates];
}

// This method called when any item in the list of Inbox messages gets changed (modified, inserted or removed)
- (void) inboxMessagesDidChangeMessage:(R1InboxMessage *) inboxMessage
                               atIndex:(NSUInteger) index
                         forChangeType:(R1InboxMessagesChangeType)changeType
                              newIndex:(NSUInteger) newIndex
{
    switch (changeType)
    {
        case R1InboxMessagesChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:index inSection:0] ]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case R1InboxMessagesChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:index inSection:0] ]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case R1InboxMessagesChangeUpdate:
            ((R1SampleInboxTableViewCell *)[self.tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow:index inSection:0] ]).inboxMessage = [self.inboxMessages.messages objectAtIndex:index];

            break;
            
        default:
            break;
    }
}

// This method called when the changes to list of Inbox messages are over
- (void) inboxMessagesDidChanged
{
    [self.tableView endUpdates];
}

// This method called when the number of unread Inbox messages gets changed
- (void) inboxMessageUnreadCountChanged
{
    [self updateTitle];
}

@end
```

*R1SampleInboxViewController.swift*

```swift
import UIKit

protocol R1SampleInboxViewControllerDelegate {
    func sampleInboxViewControllerDidFinished(sampleInboxViewController: R1SampleInboxViewController);
}

class R1SampleInboxViewController: UITableViewController, R1InboxMessagesDelegate {
    
    var inboxMessages: R1InboxMessages?
    var inboxDelegate: R1SampleInboxViewControllerDelegate?;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        inboxMessages = R1Inbox.sharedInstance().messages;
        
        updateTitle();
    }
    
    func updateTitle() {
        if (inboxMessages?.unreadMessagesCount == 0) {
            navigationItem.title = "Inbox";
        } else {
            navigationItem.title = String.init(format: "Inbox (%lu unread)", (inboxMessages?.unreadMessagesCount)!);
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        updateTitle();
        inboxMessages?.addDelegate(self);
    }
    
    override func viewDidDisappear(animated: Bool) {
        inboxMessages?.removeDelegate(self);
    }
    
    @IBAction func closeButtonPressed(sender: UIBarButtonItem) {
        inboxDelegate?.sampleInboxViewControllerDidFinished(self);
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int((inboxMessages?.messagesCount)!);
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let message : R1InboxMessage = (inboxMessages?.messages[indexPath.row])! as! R1InboxMessage;
        
        return R1SampleInboxTableViewCell.heightForCell(message, cellWidth: tableView.frame.size.width)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! R1SampleInboxTableViewCell;
        
        let message : R1InboxMessage = (inboxMessages?.messages[indexPath.row])! as! R1InboxMessage;
        
        cell.setInboxMessage(message);

        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let message : R1InboxMessage = (inboxMessages?.messages[indexPath.row])! as! R1InboxMessage;
            
            inboxMessages?.deleteMessage(message);
        }
    }
    
    // MARK: - Table view delegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let message : R1InboxMessage = (inboxMessages?.messages[indexPath.row])! as! R1InboxMessage;
        
        R1Inbox.sharedInstance().showMessage(message) { () -> Void in
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    // MARK: - R1InboxMessagesDelegate
    
    func inboxMessagesWillChanged() {
        tableView.beginUpdates()
    }
    
    func inboxMessagesDidChangeMessage(inboxMessage: R1InboxMessage!, atIndex index: UInt, forChangeType changeType: UInt, newIndex: UInt) {
        if (changeType == UInt(R1InboxMessagesChangeInsert)) {
            tableView.insertRowsAtIndexPaths([ NSIndexPath.init(forRow: Int(index), inSection: 0)], withRowAnimation: .Automatic);
        } else if (changeType == UInt(R1InboxMessagesChangeDelete)) {
            tableView.deleteRowsAtIndexPaths([ NSIndexPath.init(forRow: Int(index), inSection: 0)], withRowAnimation: .Automatic);
        } else if (changeType == UInt(R1InboxMessagesChangeUpdate)) {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath.init(forRow: Int(index), inSection: 0)) as! R1SampleInboxTableViewCell;
            let message : R1InboxMessage = (inboxMessages?.messages[Int(index)])! as! R1InboxMessage;
            
            cell.setInboxMessage(message);
        }
    }
    
    func inboxMessagesDidChanged() {
        tableView.endUpdates()
    }
    
    func inboxMessageUnreadCountChanged() {
        updateTitle()
    }
}
```

*R1SampleInboxTableViewCell.swift*

```swift
import UIKit

class R1SampleInboxTableViewCell: UITableViewCell {
    
    @IBOutlet weak var unreadMarkerView: UIView?
    @IBOutlet weak var alertLabel: UILabel?
    @IBOutlet weak var messageLabel: UILabel?
    @IBOutlet weak var dateLabel: UILabel?
    
    var dateFormatter: NSDateFormatter?
    
    func setInboxMessage(inboxMessage: R1InboxMessage) {
        unreadMarkerView?.hidden = !inboxMessage.unread;
        
        self.messageLabel?.text = inboxMessage.title;
        self.alertLabel?.text = inboxMessage.alert;
        self.dateLabel?.text = dateFormatter?.stringFromDate(inboxMessage.createdDate);
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        dateFormatter = NSDateFormatter?.init();
        dateFormatter?.dateStyle = .ShortStyle;
        dateFormatter?.timeStyle = .MediumStyle;
    }
    
    static func heightForCell(inboxMessage: R1InboxMessage, cellWidth: CGFloat) -> CGFloat {
        var height: CGFloat = 16+40;
        
        if (inboxMessage.alert != nil) {
            let paragraph : NSMutableParagraphStyle = NSMutableParagraphStyle.init();
            paragraph.lineBreakMode = .ByWordWrapping;
            
            height += inboxMessage.alert!._bridgeToObjectiveC().boundingRectWithSize(CGSize.init(width: cellWidth-16-15, height: 100), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(14), NSParagraphStyleAttributeName: paragraph], context: nil).size.height;
        }
        
        return height;
    }
}
```

In *Objective C* example, initialize the R1SampleInboxViewController with the following method:

 ```objc
 [[R1SampleInboxViewController alloc] initInboxViewController]
  ```



##c. Attribution Tracking Activation
###i. Track RadiumOne Campaigns
Please contact your Account Manager to setup R1 ad campaign as well as tracking campaigns.  If you don't have one, please contact us [here](http://radiumone.com/contact-mobile-team.html) and one of our Account Managers will assist you.

Once your Account Manager has set up tracking, you will start receiving attribution tracking report automatically!

###ii. Track 3rd party Campaigns
1. Please contact your Account Manager to setup tracking URLs for your 3rd party campaigns.  If you don't have one, please contact us [here](http://radiumone.com/contact-mobile-team.html) and one of our Account Managers will assist you.
2. Send the list of all your media suppliers (anyone you run a mobile advertising campaign with).
3. For each media supplier, your account manager will send you 2 tracking URLs (one impression tracking URL, 1 click tracking URL).
4. Send each pair of URLs to the relevant Media Supplier so they can set these tracking URLs on the creatives
5. You're all set and will start having access to Attribution Tracking Reports

##d. Geofencing Activation

(Only for *Objective C* code)
```objc
#import "R1GeofencingSDK.h"
```

Geofencing is disabled by default.  You can enable it in the `application:didFinishLaunchingWithOptions:` method or later.

```objc
sdk.geofencingEnabled = YES;
```

```swift
sdk.geofencingEnabled = false;
```

To disable geofencing, either remove the above call or set its value to NO

The R1GeofencingSDK also allows you to notify your users and drive engagements
via local notification. When a user `entered` or `exited` a region (both
    `CLGeographicalRegion` and `CLBeaconRegion`) you can obtain relevant information
using the `NSNotification` object, and the notification object has the following
keys to access the `CLRegion` object and its name string respectively:
````
kR1LocationRegionObjectKey
kR1LocationRegionNameKey
````
You can register region enter/exit notifications as needed as shown below:

```objc
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendLocalEnterNotification:) name:kR1GeofenceDidEnterNotification object:nil];
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendLocalExitNotification:) name:kR1GeofenceDidExitNotification object:nil];
```

```swift
NSNotificationCenter.defaultCenter().addObserver(self, selector: "sendLocalEnterNotification:", name: kR1GeofenceDidEnterNotification, object: nil);
NSNotificationCenter.defaultCenter().addObserver(self, selector: "sendLocalExitNotification:", name: kR1GeofenceDidExitNotification, object: nil);
```

In your `sendLocalEnterNotification:` and `sendLocalExitNotification:` methods,
you can relay your event messages to `application:didReceiveLocalNotification:`
by overriding it on your application delegate to display these local notifications using your own keys. For example:


```objc
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
	if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
		// you may want to show an alert
		
		NSString *alertString = [notification.userInfo objectForKey:<Your_Own_NotificationAlertBodyKey>];
		application.applicationIconBadgeNumber = 0; // reset the badge to zero
		
		NSString *alertTitle = [notification.userInfo objectForKey:<Your__Own_NotificationAlertTypeKey>];
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
	}
}
```

```swift
func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
	if application.applicationState == .Active {
	    let alertString : String = notification.userInfo![""] as! String;
	    let alertTitle : String = notification.userInfo![""] as! String;
	    
	    application.applicationIconBadgeNumber = 0;
	    
	    UIAlertView.init(title: alertTitle, message: alertString, delegate: self, cancelButtonTitle: "OK").show();
	}
}
```

N.B. - The Connect locationService uses the Location Manager in iOS.  For
deployment on iOS 8 and newer, it is required that the application's property
list (plist) file include one of the two following keys:

    NSLocationAlwaysUsageDescription
    //provide location updates whether the user is actively using the
    application or not via infrequent background location updates
    // OR
    NSLocationWhenInUseUsageDescription
    //provide location updates only while the user has your application as the
    foreground running app

These are string values that need to include a description suitable to present
to a user.  The description should explain the reason the application is
requesting access to the user's location.  Therefore, description you give
should try to incorporate or reference the user benefit that may be possible
through sharing location.

#4. Submitting your App

When preparing to send your binary to Apple, you will set up an application target in the iTunes Connect portal (http://itunesconnect.apple.com for details).  During this process, you will be presented with the question, "Does this app use the Advertising Identifier (IDFA)?"

  ![Image of idfaCheck]
(Doc/idfaCheck.png)

Your application may or may not be using this value for your own purposes, but the Connect SDK does access it (described below). So, it is required that you answer, "Yes" to the aforementioned question.

If your application is utilizing Connect's analytics, geofencing or push notification features, be sure to check the last use case option - that the application uses the IDFA to "Attribute an action taken within this app to a previously served advertisement" as advertisments that you might have served can be related to users actions within your app.

  ![Image of idfaAnalyticsOption]
(Doc/idfaAnalyticsOption.png)

If your application is also using Connect's Engage (display advertisements) feature, be sure to select the option: "Serve advertisements within the app". Naturally, if your application is only using the Engage functionality, leave all other options unchecked (as related to Connect's use of the IDFA)

  ![Image of idfaAllOptions]
(Doc/idfaAllOptions.png)


You will also need to confirm that your app honors a user's "Limit Ad Tracking" setting in iOS.  The Connect SDK does honor this flag and will not access or otherwise utilize the IDFA value if the user has selected the "Limit Ad Tracking" feature.  Ensure that this confirmation and the previously mentioned IDFA use options are checked to facilitate a smooth application review process.
