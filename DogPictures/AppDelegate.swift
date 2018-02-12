//
//  AppDelegate.swift
//  DogPictures
//
//  Created by William Grand on 2/8/18.
//  Copyright © 2018 William Grand. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds);
        window?.rootViewController = UINavigationController(rootViewController: DogPicturesViewController());
        window?.makeKeyAndVisible();
    
        return true
    }
}

