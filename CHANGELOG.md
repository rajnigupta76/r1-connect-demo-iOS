##Version 2.4.0

###1. Added

#####1. Rich push and deep linking support

    #import "R1WebCommand.h"


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
