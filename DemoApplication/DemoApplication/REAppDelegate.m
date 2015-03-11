#import "REAppDelegate.h"
#import "R1SDK.h"
#import "R1Push.h"
#import "R1Emitter.h"

#import "RESharedParametersViewController.h"
#import "REEmitterParametersViewController.h"
#import "REPushParametersViewController.h"
#import "REGeofencingViewController.h"
#import "REEmitterViewController.h"
#import "REInitialViewController.h"

#error Enter your application ID
#define R1_APPLICATION_ID @""

#error Enter your client KEY
#define R1_CLIENT_KEY @""

@implementation REAppDelegate

- (void)dealloc
{
    [_navigationController release];
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    R1SDK *sdk = [R1SDK sharedInstance];
    
    sdk.applicationId = R1_APPLICATION_ID;
    // Only if you want use push
    sdk.clientKey = R1_CLIENT_KEY;

    // Optional emitter parameters
    sdk.emitter.appVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"r1EmitterLastApplicationVersion"];
    sdk.emitter.appId = [[NSUserDefaults standardUserDefaults] objectForKey:@"r1EmitterDemoAppId"];
    sdk.geofencingEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"r1EmitterDemoGeofencingEnabled"];
    sdk.disableAllAdvertisingIds = [[NSUserDefaults standardUserDefaults] boolForKey:@"r1EmitterDemoDisableAllAdvertisingIds"];
    
    [sdk start];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:[[[REInitialViewController alloc] initViewController] autorelease]] autorelease];
    
    [self.window setRootViewController:self.navigationController];
    
    [self.window makeKeyAndVisible];
    
    [R1Push sharedInstance].delegate = (id)self;

    [[R1Push sharedInstance] handleNotification:[launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey]
                               applicationState:application.applicationState];
    
    [[R1Push sharedInstance] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                                          UIRemoteNotificationTypeSound |
                                                                          UIRemoteNotificationTypeAlert)];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    UIViewController *vc = nil;
    
    NSString *host = [url host];
    NSString *path = [url path];
    
    R1SDK *sdk = [R1SDK sharedInstance];
    
    if ([host isEqualToString:@"options"])
    {
        if ([path isEqualToString:@"/shared"])
        {
            vc = [[RESharedParametersViewController alloc] initViewController];
        }else if ([path isEqualToString:@"/emitter"])
        {
            if (sdk.emitter.isStarted)
                vc = [[REEmitterParametersViewController alloc] initViewController];
        }else if ([path isEqualToString:@"/push"])
        {
            if (sdk.push.isStarted)
                vc = [[REPushParametersViewController alloc] initViewController];
        }else if ([path isEqualToString:@"/geofencing"])
        {
            vc = [[REGeofencingViewController alloc] initViewController];
        }
    }else if ([host isEqualToString:@"emitter"])
    {
        if (sdk.emitter.isStarted)
            vc = [[REEmitterViewController alloc] initViewController];
    }
    
    if (vc != nil)
    {
        void (^completion)(void) = ^{
            [self.navigationController popToRootViewControllerAnimated:NO];
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        };
        
        UIViewController *visibleVC = [[self.navigationController viewControllers] lastObject];
        
        if (visibleVC.presentedViewController != nil)
            [visibleVC dismissViewControllerAnimated:NO completion:completion];
        else
            completion();
        
        return YES;
    }
    
    NSString *message = [NSString stringWithFormat:@"URL: %@\nSource Application: %@", [url absoluteString], sourceApplication];
    
    [[[UIAlertView alloc] initWithTitle:@"OpenURL" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Only if you want use push
    [[R1Push sharedInstance] registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error
{
    // Only if you want use push
    [[R1Push sharedInstance] failToRegisterDeviceTokenWithError:error];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // Only if you want use push
    [[R1Push sharedInstance] handleNotification:userInfo
                               applicationState:application.applicationState];
}

- (void) handleForegroundNotification:(NSDictionary *)notification
{
    NSString *message = [NSString stringWithFormat:@"Notification:\n%@", notification];
    
    if (message != nil)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
        
        [alertView show];
        [alertView release];
    }
}

@end
