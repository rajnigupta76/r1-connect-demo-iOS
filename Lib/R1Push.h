#import <Foundation/Foundation.h>
#import "R1PushTags.h"
#import "R1LocationService.h"

@interface R1Push : NSObject

// Singleton
+ (instancetype) sharedInstance;

@property (nonatomic) BOOL pushEnabled;

@property (nonatomic, copy, readonly) NSString *deviceToken;

@property (nonatomic, readonly) R1PushTags *tags;

@property (nonatomic, retain) NSTimeZone *timeZone;

@property (nonatomic, assign) NSUInteger badgeNumber;

@property (nonatomic, readonly) BOOL isStarted;

- (void) registerDeviceToken:(NSData *)token;
- (void) failToRegisterDeviceTokenWithError:(NSError *)error;

- (void) registerForRemoteNotificationTypes:(UIRemoteNotificationType)types;

- (void) handleNotification:(NSDictionary *)notification applicationState:(UIApplicationState)state;

- (void) start;

@end
