//
//  AppDelegate.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 09.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import CoreData
import INSPersistentContainer
import SWRevealViewController
import OneSignal
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        chooseViewControllerToPresent()
        setupPushNotificationsWith(launchOptions)
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
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: INSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = INSPersistentContainer(name: "UREClub")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

// MARK: Auth
extension AppDelegate {
    
    func chooseViewControllerToPresent() {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        if CurrentUser.isLoggedIn {
            let overviewVC = UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            self.window?.rootViewController = overviewVC
        } else {
            let loginVC = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.window?.rootViewController = loginVC
        }
        
        self.window?.makeKeyAndVisible()
        
    }
}

// Notifications Push Remote
extension AppDelegate {
    
    func setupPushNotificationsWith(_ launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        
        let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
            guard let payload: OSNotificationPayload = result!.notification.payload
                else { return }
            guard let additionalData = payload.additionalData as? [String: Any]
                else { return }
            let articleData = DataFromPushNotification(withResult: additionalData)
            
            let revealVC = UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            self.window?.rootViewController = revealVC
            
            if articleData.postType == "news" {
                let eventsNavController = UIStoryboard(name: "News", bundle: nil).instantiateViewController(withIdentifier: "NewsNavBar") as! UINavigationController
                let eventsListVC = UIStoryboard(name: "News", bundle: nil).instantiateViewController(withIdentifier: "NewsListVC") as! NewsListVC
                eventsListVC.dataFromNotification = articleData
                eventsNavController.viewControllers = [eventsListVC]
                revealVC.setFront(eventsNavController, animated: true)
            } else if articleData.postType == "member" {
                let eventsNavController = UIStoryboard(name: "Members", bundle: nil).instantiateViewController(withIdentifier: "MembersNavBar") as! UINavigationController
                let eventsListVC = UIStoryboard(name: "Members", bundle: nil).instantiateViewController(withIdentifier: "MembersVC") as! MembersVC
                eventsListVC.dataFromNotification = articleData
                eventsNavController.viewControllers = [eventsListVC]
                revealVC.setFront(eventsNavController, animated: true)
            } else {
                let eventsNavController = UIStoryboard(name: "Events", bundle: nil).instantiateViewController(withIdentifier: "EventsNavBar") as! UINavigationController
                let eventsListVC = UIStoryboard(name: "Events", bundle: nil).instantiateViewController(withIdentifier: "EventsListVC") as! EventsListVC
                eventsListVC.dataFromNotification = articleData
                eventsNavController.viewControllers = [eventsListVC]
                revealVC.setFront(eventsNavController, animated: true)
            }
            
            self.window?.makeKeyAndVisible()
            
        }
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false, kOSSettingsKeyInAppLaunchURL: false]
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "0f76fddd-eae8-4997-a323-24a52c726937",
                                        handleNotificationAction: notificationOpenedBlock,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification
    }
    
}

