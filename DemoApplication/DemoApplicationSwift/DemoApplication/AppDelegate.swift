import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, R1PushDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let sdk = R1SDK.sharedInstance();
        
        sdk.applicationId = "YOUR APPLICATION ID";
        sdk.clientKey = "YOUR CLIENT KEY";
        
        sdk.start();
        
        R1Push.sharedInstance().delegate = self;
        
        var remoteNotificationInfo: NSDictionary? = nil
        
        if launchOptions != nil {
            remoteNotificationInfo = (launchOptions![UIApplicationLaunchOptionsRemoteNotificationKey] as? NSDictionary)!;
        }
        
        R1Push.sharedInstance().handleNotification(remoteNotificationInfo as? [NSObject : AnyObject], applicationState: application.applicationState);
        
        R1Push.sharedInstance().registerForRemoteNotificationTypes([.Alert ,.Badge ,.Sound]);

        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        R1Push.sharedInstance().registerDeviceToken(deviceToken);
    }

    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        R1Push.sharedInstance().failToRegisterDeviceTokenWithError(error);
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        R1Push.sharedInstance().handleNotification(userInfo, applicationState: application.applicationState);
    }

}

