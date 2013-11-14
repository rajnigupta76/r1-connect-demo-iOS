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

![Files in xCode project](https://raw.github.com/radiumone/r1-connect-demo-iOS/readme_images/ReadmeImages/library_files.png)

###Link against the static library

![Linked binaries](https://raw.github.com/radiumone/r1-connect-demo-iOS/readme_images/ReadmeImages/link_with_binary.png)

###Check Background modes

![Background modes](https://raw.github.com/radiumone/r1-connect-demo-iOS/readme_images/ReadmeImages/enable_background_mode.png)


###Setting up your App Delegate

You will need to initialize the R1 Connect Library in your App Delegate.



•	If you want to use emitter and push

 
 

If you enabled it in *application:didFinishLaunchingWithOptions:* method, Push Notification AlertView will be showed at first application start.
#Emitter & Push Parameters
The following is a list of configuration parameters for the R1 Connect SDK, most of these contain values that are sent to the tracking server to help identify your app on our platform and to provide analytics on sessions and location.

##Configuration Parameters

***applicationUserId***

Optional current user identifier.

	[R1SDK sharedInstance].applicationUserId = @"12345";






The application name associated with emitter. By default, this property is populated with the `CFBundleName` string from the application bundle. If you wish to override this property, you must do so before making any tracking calls.
		
	[R1Emitter sharedInstance].appName = @"Custom application name";

***appId***

Default: nil


	[R1Emitter sharedInstance].appId = @"12345678";


The application version associated with this emitter. By default, this property is populated with the `CFBundleShortVersionString` string from the application bundle. If you wish to override this property, you must do so before making any tracking calls.

	[R1Emitter sharedInstance].appVersion = @"1.0.2";


If true, indicates the start of a new session. Note that when a emitter is first instantiated, this is initialized to true. To prevent this default
 behavior, set this to `NO` when the tracker is first obtained.
 
 By itself, setting this does not send any data. If this is true, when the next emitter call is made, a parameter will be added to the resulting emitter
 information indicating that it is the start of a session, and this flag will be cleared.

	[R1Emitter sharedInstance].sessionStart = YES;
	// Your code here
	[R1Emitter sharedInstance].sessionStart = NO;

***sessionTimeout***

If non-negative, indicates how long, in seconds, the application must transition to the inactive or background state for before the tracker will automatically indicate the start of a new session when the app becomes active again by setting sessionStart to true. For example, if this is set to 30 seconds, and the user receives a phone call that lasts for 45 seconds while using the app, upon returning to the app, the sessionStart parameter will be set to true. If the phone call instead lasted 10 seconds, sessionStart will not be modified.
 
To disable automatic session tracking, set this to a negative value. To indicate the start of a session anytime the app becomes inactive or backgrounded, set this to zero.
 
By default, this is 30 seconds.

	[R1Emitter sharedInstance].sessionTimeout = 15;
	
#Push Tags
You can specify Tags for *R1 Connect SDK* to send *Push Notifications* for certain groups of users.

The maximum length of the Tag is 128 characters.

*R1 Connect SDK* saves Tags. You do not have to add Tags every time the application is launch.

***Add a new Tag***

	[[R1Push sharedInstance].tags addTag:@"NEW TAG"];
	
***Add multiple Tags***
	
	[[R1Push sharedInstance].tags addTags:@[ @"NEW TAG 1", @"NEW TAG 2" ]];
	
***Remove exist Tag***
	
	[[R1Push sharedInstance].tags removeTag:@"EXIST TAG"];
	
***Remove multiple Tags***

	[[R1Push sharedInstance].tags removeTags:@[ @"EXIST TAG 1", @"EXIST TAG 2" ]];
	
***Replace all exist Tags***

	[R1Push sharedInstance].tags.tags = @[ @"NEW TAG 1", @"NEW TAG 2" ];
or

	[[R1Push sharedInstance].tags setTags:@[ @"NEW TAG 1", @"NEW TAG 2" ]];
	
***Get all Tags***
	
	NSArray *currentTags = [R1Push sharedInstance].tags.tags;


#Emitter Events

##State Events

Some events are emitted automatically when the state of the application is changed by the OS and, therefore, they do not require any additional code to be written in the app in order to work out of the box:


##Pre-Defined Events

Pre-Defined Events are also helpful in measuring certain metrics within the apps and do not require further developer input to function. These particular events below are used to help measure app open events and track Sessions.



##User-Defined Events

User-Defined Events are not sent automatically so it is up to you if you want to use them or not. They can provide some great insights on popular user actions if you decide to track them.  In order to set this up the application code needs to include the emitter callbacks in order to emit these events.

*Note: The last argument in all of the following emitter callbacks, otherInfo, is a dictionary of “key”,”value” pairs or nil*

**Action**

A generic user action, such as a button click.

        			  				  label:@"About"
                      				  value:10
                  				  otherInfo:@{"custom_key":"value"}];

**Login**

Tracks a user login within the app
	[[R1Emitter sharedInstance] emitLoginWithUserID:[R1Emitter sha1:@"userId"]
                           				    userName:@"user_name"
                          				   otherInfo:@{"custom_key":"value"}];

**Registration**

Records a user registration within the app
**Facebook connect**

Allows access to Facebook services

	NSArray *permissions = @[[R1EmitterSocialPermission socialPermissionWithName:@"photos" granted:YES]];

	[[R1Emitter sharedInstance] emitFBConnectWithUserID:[R1Emitter sha1:@"12345"]
                                       			   userName:@"user_name"
                                      			permissions:permissions
                                  				  otherInfo:@{"custom_key":"value"}];

**Twitter connect**

Allows access to Twitter services
	NSArray *permissions = @[[R1EmitterSocialPermission socialPermissionWithName:@"photos" granted:YES]];

	[[R1Emitter sharedInstance] emitTConnectWithUserID:[R1Emitter sha1:@"12345"]
                                       			  userName:@"user_name"
                                      		   permissions:permissions
                                  			     otherInfo:@{"custom_key":"value"}];

**Upgrade**

Tracks an application version upgrade

	[[R1Emitter sharedInstance] emitUpgradeWithOtherInfo:@{"custom_key":"value"}];

**Trial Upgrade**

Tracks an application upgrade from a trial version to a full version

**Screen View**

Basically, a page view, it provides info about that screen

	[[R1Emitter sharedInstance] emitScreenViewWithDocumentTitle:@"title"
                            					 contentDescription:@"description"
                           						documentLocationUrl:@"http://www.example.com/path"
                              					   documentHostName:@"example.com"
                                  					   documentPath:@"path"
                                     					  otherInfo:@{"custom_key":"value"}];

###E-Commerce Events

**Transaction**

	[[R1Emitter sharedInstance] emitTransactionWithID:@"transaction_id"
                                   				  storeID:@"store_id"]
                                 				storeName:@"store_name"
                                    			   cartID:@"cart_id"
                                   				  orderID:@"order_id"
                                 				totalSale:1.5
                                  				 currency:@"USD"
                             				shippingCosts:10.5
                            			   transactionTax:12.0
                                 				otherInfo:@{"custom_key":"value"}];


**TransactionItem**

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
                                                			   otherInfo:@{"custom_key":"value"}];


**Create Cart**

    [[R1Emitter sharedInstance] emitCartCreateWithCartID:@"cart_id"
                                    			   otherInfo:@{"custom_key":"value"}];

**Delete Cart**

	[[R1Emitter sharedInstance] emitCartDeleteWithCartID:@"cart_id"
                                    			   otherInfo:@{"custom_key":"value"}];

**Add To Cart**

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
                                   				  otherInfo:@{"custom_key":"value"}];

**Delete From Cart**

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
                                        			   otherInfo:@{"custom_key":"value"}];


##Custom Events


	// Emits a custom event without parameters
	[[R1Emitter sharedInstance] emitEvent:@"Your custom event name"];
	// Emits a custom event with parameters
	[[R1Emitter sharedInstance] emitEvent:@"Your custom event name"
			  			   withParameters:@{"key":"value"}];