//
//  AppDelegate.swift
//  ChillZone
//
//  Created by David James on 2/9/18.
//  Copyright © 2018 David James. All rights reserved.
//

import UIKit
import UserNotifications
import MapKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //var locationManager : CLLocationManager = CLLocationManager();
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        LocationHandler.setup();
        UIApplication.shared.setMinimumBackgroundFetchInterval(2);
        
        //locationManager.requestAlwaysAuthorization();
        //locationManager?.requestLocation();
        //locationManager.delegate = LocationHandler();
        //UIApplication.shared.setMinimumBackgroundFetchInterval(5);
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
        //LocationHandler.update();
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        var result = UIBackgroundFetchResult.noData;
        //check Chore norifications
        //check chat updates
        if let userinfo = NSKeyedUnarchiver.unarchiveObject(withFile: AutoLoginViewController.archURL.path) as? [String:String]{
            print("doing a log in with cred")
            User.login(username: userinfo["username"], password: userinfo["password"], isGuest: false){
                if(HttpHandler.noConnection){
                    print("No Cnn")
                    return;
                }
                var noteText = "";
                if(ChoreHandler.newChores()){
                    print("new chore")
                    noteText += "Do Your Chores!! "
                    result = UIBackgroundFetchResult.newData;
                }
                if(MessageHandler.newMessage()){
                    print("new message")
                    noteText += "You've got some mail!!"
                    result = UIBackgroundFetchResult.newData;
                }
                if(result == UIBackgroundFetchResult.newData){
                    //show notification
                    // configure notification content
                    let content = UNMutableNotificationContent()
                    content.title = NSString.localizedUserNotificationString(forKey: "Updates", arguments: nil)
                    content.body = NSString.localizedUserNotificationString(forKey: noteText,arguments: nil)
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    
                    // Create the request object.
                    let request = UNNotificationRequest(identifier: "newDataUpdate", content: content, trigger: trigger)
                    
                    // Schedule the request
                    let center = UNUserNotificationCenter.current()
                    center.add(request) { (error : Error?) in
                        if let theError = error {
                            print(theError.localizedDescription)
                            print("*****")
                        }
                    }
                }
                print("did it")
                completionHandler(result);
            }
        } else {
            completionHandler(.failed);
        }
    }
}

