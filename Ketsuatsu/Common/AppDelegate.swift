//
//  AppDelegate.swift
//  Ketsuatsu
//
//  Created by NguyenVanChien on 4/6/18.
//  Copyright © 2018 NguyenVanChien. All rights reserved.
//

import UIKit
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var deepLink: RemoteNotificationDeepLink?
    static let shareInstance = UIApplication.shared.delegate as! AppDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

extension AppDelegate {
    func setRootViewController(_ vc: UIViewController) {
        self.window?.rootViewController = vc
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.host == nil {
            return true
        }
        if let scheme = url.scheme {
            if scheme == "fb2130880833865442" {
                let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
                print("host \(String(describing: url.scheme ))")
                
                return handled
            } else if scheme == "ketsuatsuDeepLink" {
                let urlString = url.absoluteString
                let queryArray = urlString.components(separatedBy: "/")
                let query = queryArray[2]
                if query.range(of: "deeplink") != nil {
                    let data = urlString.components(separatedBy: "/")
                    if data.count >= 5 {
                        let parameterDirection = data[3]
                        let parameterToken = data[4]
                        UIUtils.storeObjectToUserDefault(data.last as AnyObject, key: KEY_EMAIL)
                        let userInfo = [RemoteNotificationDeepLinkAppSectionKey: parameterDirection, RemoteNotificationDeepLinkAppTokenKey: parameterToken]
                        applicationHandleRemoteNotification(app, didReceiveRemoteNotification: userInfo)
                    }
                    
                }
            }
        }
        return true
    }
    
    func applicationHandleRemoteNotification(_ app: UIApplication, didReceiveRemoteNotification userInfo: [String: String]) {
        if app.applicationState == .background || app.applicationState == .inactive
        {
            self.deepLink = RemoteNotificationDeepLink.create(userInfo: userInfo)
            _ = self.triggerDeepLinkIfPresent()
        }
        
    }
    
    func triggerDeepLinkIfPresent() -> Bool
    {
        let ret = (self.deepLink?.trigger() != nil)
        self.deepLink = nil
        return ret
    }
}
