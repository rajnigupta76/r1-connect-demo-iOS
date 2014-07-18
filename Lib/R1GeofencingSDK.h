#import <Foundation/Foundation.h>

extern NSString *const R1_DEVLOG_CONSOLE_SECRET;
extern NSString *const R1_DEVLOG_DATABASE_SECRET;

extern NSString *const kR1LocationRegionObjectKey;
extern NSString *const kR1LocationRegionNameKey;

extern NSString *const kR1GeofenceDidExitNotification;
extern NSString *const kR1GeofenceDidEnterNotification;

@interface R1GeofencingSDK : NSObject

@property (nonatomic, readonly) NSString *applicationID;

/*!
 @brief
 Singleton
 */
+ (instancetype)sharedInstance;

/*!
 @brief
 By setting a valid applicationID, you enabled RadiumOne Geofencing SDK for your App
 
 @params applicationID
 The token you obtained from RadiumOne Geofencing SDK portal

 */
- (void)setApplicationID:(NSString *)applicationID;

@end
